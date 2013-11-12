# Run this with 'rackup -p 4567'

require 'bundler'
Bundler.require

require 'sinatra'

require './web_apprentice_demo_app.rb'

run WebApprenticeDemoApp.new
