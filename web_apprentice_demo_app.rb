#!/usr/bin/env ruby

# web_apprentice_demo_app.rb

# Copyright 2013 Robert Jones  (jones@craic.com)   Craic Computing LLC
# This code and associated data files are distributed freely under the terms of the MIT license

# This is the demo server for the Craic Web Apprentice tutorials

# Each 'tutorial' is associated with one or more demo pages on this site
# Demo pages may be static or dynamic, but all are written as views

# Naming convention is tutorial_1_demo_1.erb


require 'erb'
require 'open-uri'
require 'json'


$:.unshift File.join(File.dirname(__FILE__))

class WebApprenticeDemoApp < Sinatra::Base

  set :root, File.dirname(__FILE__)

  root_dir = File.dirname(__FILE__)

  CONFIG = YAML.load(File.read(File.join(root_dir, 'application.yml')))
  CONFIG.symbolize_keys!

  set :static, true

  disable :show_exceptions

  not_found do
    erb '404'.to_sym
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

  # Extract EXIF metadata from a photo on the server
  get '/tutorial_22_demo_1' do

    # this file contains methods that are related to this tutorial
    require 'lib/tutorial_22.rb'

    # Extract the metadata from an image file on the server
    @photo = MiniExiftool.new(File.join(root_dir, "/public/assets/photo_metadata_1_400.jpg"))

    # Get the Latitude and Longitude values and convert to decimal format
    @latitude_0  = dms_to_decimal(@photo['GPSLatitude'])
    @longitude_0 = dms_to_decimal(@photo['GPSLongitude'])

    # Compute a second Lat/Lon pair along the direction the image was taken - used to draw a line on the map
    bearing = @photo['GPSImgDirection'].to_f
    @latitude_1, @longitude_1 = latlong_offset(@latitude_0, @longitude_0, bearing, 0.5)

    erb :tutorial_22_demo_1
  end

end






