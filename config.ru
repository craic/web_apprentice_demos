# Run this with 'rackup -p 4567'

require 'bundler'
Bundler.require

require 'sinatra'

require './api_demo_server_app.rb'

run ApiDemoServerApp.new
