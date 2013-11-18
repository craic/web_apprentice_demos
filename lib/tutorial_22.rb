# lib/tutorial_22.rb  - methods related to tutorial_22

require 'mini_exiftool_vendored'

# Convert Lat Lon in Deg, Min, Sec to Decimal format
# e.g 122 deg 25' 25.20" W -> 122.42366666
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

  # normalize to -180..+180º
  rlng1 = (rlng1 + 3*Math::PI) % (2*Math::PI) - Math::PI

  lat1 = radians_to_degrees(rlat1)
  lng1 = radians_to_degrees(rlng1)

  [ lat1, lng1 ]
end
