# Module ApplicationLoader loads the application.
module ApplicationLoader
  def load_application
    RackApplication.new
  end

  def load_all_files
    ["controllers", "views"].each do |folder|
      Dir["../app/#{folder}/*.rb"].each {|file| require_relative file}
    end
  end
end