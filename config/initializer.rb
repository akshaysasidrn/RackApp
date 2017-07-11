require_relative "../web_server.rb"
include WebServer

puts "Enter the port on which server must run:"
port_no = gets.chomp.to_i
puts "Enter the number of workers:"
workers_no = gets.chomp.to_i
RequestHandler.new(port: port_no, workers: workers_no)
