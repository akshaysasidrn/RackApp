# Rack compliant web server
require 'socket'
require 'http/parser'
require_relative './config/environment.rb'

module WebServer
  # Class RequestHandler handles HTTP requests and makes rack compliant env hash.
  class RequestHandler
    include ApplicationLoader

    HTTP_CODES = {
      200 => 'OK',
      404 => 'Not Found',
      500 => 'Internal Server Error'
    }

    def initialize(port: 3000, workers: 4)
      @web_server  = TCPServer.new('localhost', port)
      @http_parser = Http::Parser.new(self)
      @app         = load_application
      prefork(workers)
    end

    def prefork(workers)
      workers.times do
        fork do
          process_request
        end
      end
      Process.waitall # To avoid zombie-processes
    end

    def process_request
      @socket = @web_server.accept
      until @socket.closed? || @socket.eof?
        data = @socket.readpartial(2048)
        # p data
        @http_parser << data
      end
    end

    # Callback method from Http::Parser library.
    def on_message_complete
      send_response
      close_socket
    end

    def send_response
      status, headers, body = @app.call(rack_compliant_env)
      # To tell the browser that we are a HTTP server
      @socket.write "HTTP/1.1 #{status} #{HTTP_CODES[status]}\r\n"
      # Providing the HTTP headers
      headers.each_pair { |key, value| @socket.write "#{key}: #{value}\r\n" }
      # CRLF for seperating head from body
      @socket.write "\r\n"
      # Body of the HTML
      body.each { |chunk| @socket.write chunk }
      body.close if body.respond_to?(:close)
    end

    def rack_compliant_env
      env = {
        "REQUEST_METHOD" => @http_parser.http_method,
        "PATH_INFO"      => @http_parser.request_url.to_s,
      }
    end

    def close_socket
      @socket.close
    end
  end
end