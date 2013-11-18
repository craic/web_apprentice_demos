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

    # this would normally go at the start of your Ruby file
    require 'mini_exiftool'

    @photo = MiniExiftool.new(File.join(root_dir, "/public/assets/photo_metadata_1_400.jpg"))

    # Get the Latitude and Longitude values and convert to decimal format


# e.g 48 deg 20' 54.60" N
    # def dms_to_decimal(coordinate)
    #   decimal = 0.0
    #   if coordinate =~ /^(\d)\s+deg\s+(\d+)\'\s+(\d+)"\s(\S)\s*$/
    #     deg = $1.to_f
    #     min = $2.to_f
    #     sec = $3.to_f
    #     direction = $4
    #     decimal = deg + (min*60.0 + sec)/3600.0
    #     if direction == 'S' or direction == 'W'
    #       decimal = -decimal
    #     end
    #   end
    #   decimal
    # end

    @latitude  = dms_to_decimal(@photo['GPSLatitude'])
    @longitude = dms_to_decimal(@photo['GPSLongitude'])
    # @latitude  = @photo['GPSLatitude']
    # @longitude = @photo['GPSLongitude']

    erb :tutorial_22_demo_1
  end


end

# examples
# 48 deg 20' 54.60" N
# 122 deg 25' 25.20" W

    def dms_to_decimal(coordinate)
      decimal = 0.0
      if coordinate =~ /^(\d+)\s+deg\s+(\d+)\'\s+([\d\.]+)\"\s+(\S)\s*$/
        deg = $1.to_f
        min = $2.to_f
        sec = $3.to_f
        direction = $4
        decimal = deg + (min*60.0 + sec)/3600.0
        if direction == 'S' or direction == 'W'
          decimal = -decimal
        end
      end
      decimal
    end

