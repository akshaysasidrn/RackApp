require './routes.rb'
require './environment.rb'

class RackApplication
  # include ApplicationLoader
  include Routes
  
  def load_all_files
    ["controllers", "views"].each do |folder|
      Dir["../app/#{folder}/*.rb"].each {|file| require_relative file}
    end
  end

  def call(env)
    begin
      puts env
      load_all_files
      controller, method = match_route(env)
      result = send(method)
      puts result
      [200, {'Content-Type' => 'text/html'}, result]
    rescue StandardError => e
      puts e.message
      puts e.backtrace
      [500, {'Content-Type' => 'text/html'}, e.message]
    end
  end
end