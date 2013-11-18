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

    @latitude  = dms_to_decimal(@photo['GPSLatitude'])
    @longitude = dms_to_decimal(@photo['GPSLongitude'])

    bearing = @photo['GPSImgDirection'].to_f
    @latitude_1, @longitude_1 = latlong_offset(@latitude, @longitude, bearing, 0.200)

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

def degrees_to_radians(angle)
  angle * Math::PI / 180.0
end

def radians_to_degrees(angle)
  angle * 180.0 / Math::PI
end

# This will work for short distances and not right at the poles
def latlong_offset(lat0, lng0, bearing, distance)
  rlat0 = degrees_to_radians(lat0)
  rlng0 = degrees_to_radians(lng0)

  rbearing = degrees_to_radians(bearing)

  radius_of_earth = 6371.0  # km

  ang_distance = distance / radius_of_earth

  rlat1 = Math.asin( Math.sin(rlat0) * Math.cos(ang_distance) +
                     Math.cos(rlat0) * Math.sin(ang_distance) * Math.cos(rbearing) )

  rlng1 = rlng0 + Math.atan2(Math.sin(rbearing) * Math.sin(ang_distance) * Math.cos(rlat0),
                             Math.cos(ang_distance) - Math.sin(rlat0) * Math.sin(rlat1))

  # normalise to -180..+180º
  rlng1 = (rlng1 + 3*Math::PI) % (2*Math::PI) - Math::PI

  lat1 = radians_to_degrees(rlat1)
  lng1 = radians_to_degrees(rlng1)

  [ lat1, lng1 ]
end

