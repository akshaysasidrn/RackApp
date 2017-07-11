require './application.rb'

# Module ApplicationLoader loads the application.
module ApplicationLoader
  def load_application
    RackApplication.new
  end
end