#!/usr/bin/env ruby

# api_demo_server_app.rb

# Copyright 2013 Robert Jones  (jones@craic.com)   Craic Computing LLC
# This code and associated data files are distributed freely under the terms of the MIT license

# This is the demo server for the Craic Web API tutorials

# Each 'post' is associated with one or more demo pages on this site
# Demo pages may be static or dynamic, but all are written as views

# Naming convention is tutorial_1_demo_1.erb


require 'erb'
require 'open-uri'
require 'json'


$:.unshift File.join(File.dirname(__FILE__))

class WebApprenticeDemoApp < Sinatra::Base

  set :root, File.dirname(__FILE__)

  root_dir = File.dirname(__FILE__)

  set :static, true

  disable :show_exceptions

  not_found do
    'That page does not exist'
  end

  get '/' do
    erb :index
  end

  # Embed a basic Google Map
  get '/tutorials' do
    tutorial = params[:tutorial]
    demo = params[:demo] || 1
    link = "tutorial_#{tutorial}_demo_#{demo}"
    if File.exists?("#{root_dir}/views/#{link}.erb")
      erb link.to_sym
    else
      erb '404'.to_sym
    end
  end

  # # Embed a basic Google Map
  # get '/tutorial_1_demo_1' do
  #   erb :tutorial_1_demo_1
  # end


  # # Embed a single Tweet
  # get '/tutorial_2_demo_1' do
  #   erb :tutorial_2_demo_1
  # end

  # # Embed a Forecast Embed weather forecast
  # get '/tutorial_3_demo_1' do
  #   erb :tutorial_3_demo_1
  # end

  # # Embed a YouTube video
  # get '/tutorial_4_demo_1' do
  #   erb :tutorial_4_demo_1
  # end
  # # Play an audio file with the audio tag
  # get '/tutorial_5_demo_1' do
  #   erb :tutorial_5_demo_1
  # end

  # # Play an audio file with the audio tag
  # get '/tutorial_6_demo_1' do
  #   erb :tutorial_6_demo_1
  # end

  # # Play an audio file with the audio tag
  # get '/tutorial_7_demo_1' do
  #   erb :tutorial_7_demo_1
  # end

  # # Use Google Fonts in a page
  # get '/tutorial_8_demo_1' do
  #   erb :tutorial_8_demo_1
  # end

  # # Embed Vimeo video in a page
  # get '/tutorial_9_demo_1' do
  #   erb :tutorial_9_demo_1
  # end

  # # Embed Bing map in a page
  # get '/tutorial_10_demo_1' do
  #   erb :tutorial_10_demo_1
  # end

  # # Embed Google Calendar in a page
  # get '/tutorial_11_demo_1' do
  #   erb :tutorial_11_demo_1
  # end

  # get '/tutorial_12_demo_1' do
  #   erb :tutorial_12_demo_1
  # end
  # get '/tutorial_13_demo_1' do
  #   erb :tutorial_13_demo_1
  # end
  # get '/tutorial_14_demo_1' do
  #   erb :tutorial_14_demo_1
  # end

  # get '/tutorial_15_demo_1' do
  #   erb :tutorial_15_demo_1
  # end
end
