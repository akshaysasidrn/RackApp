require "./routes.rb"
require "./environment.rb"

# Class RackApplication includes the routes and does controller hits.
class RackApplication
  include Routes
  extend ApplicationLoader

  def call(env)
    begin
      puts env
      RackApplication.load_all_files
      controller, method = match_route(env)
      result = send(method)
      puts result
      [200, {"Content-Type" => "text/html"}, result]
    rescue StandardError => e
      puts e.message
      puts e.backtrace
      [404, {"Content-Type" => "text/html"}, ["<h2>Oops page not found!</h2>"]]
    end
  end
end