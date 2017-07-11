module Routes
  ROUTES = {
    "/"      => "application_controller.rb#welcome",
    "/hello" => "hello_controller.rb#hello"
  }
  
  def get_controller_method(controller_path)
    controller_path.split("#")
  end

  def match_route(env)
    controller_path = ROUTES[env["PATH_INFO"]]
    raise "Route not defined for: #{env["PATH_INFO"]}" if controller_path.nil?
    controller, controller_method = get_controller_method(controller_path)
    relative_path = File.expand_path('../app/controllers', File.dirname(__FILE__))
    if File.file?("#{relative_path}/#{controller}")  
      [controller, controller_method] 
    else 
      raise "Controller not defined for: #{env["PATH_INFO"]}"
    end
  end
end