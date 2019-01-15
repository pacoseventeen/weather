#!/usr/local/opt/ruby/bin/ruby
#Changelog:
#
#v1.3
#Fixed security issue by removing plaintext API key from script
#v1.2
#Added the following options and functionality:
# -h: There's now a help screen to show you how to use the command
# -n: View current weather, a.k.a. the old output.
# -t: View the forecast for tomorrow.
#v1.1
#We remove the unnecessary "stats" variable and merge it into one query.
#We also do the formatting at the beginning at on the same line making for shorter,
#easier to read code.

require 'open-uri'
require 'json'
apikey = IO.read(ENV['HOME'] + "/scripts/.keys/wunderground.api").chomp

if ARGV.empty? || ARGV[0] == "-h"
  puts "
  Simple tool that gathers either the current conditions or tomorrow's weather from Weather Underground.
  Only the first argument is recognized, anything additional will be ignored.

  Usage:

  -h: Prints this help dialog.
  -n: See the current weather conditions.
  -t: See tomorrow's forecast.

"
elsif ARGV[0] == "-t"
  open("http://api.wunderground.com/api/#{apikey}/forecast/bestfct:1/q/NY/east_glenville.json") do |website|
    forecast = JSON.parse(website.read)["forecast"]["txt_forecast"]["forecastday"]
    puts "Tomorrow's forecast: %s" % forecast[2]['fcttext']
  end
elsif ARGV[0] == "-n"
  open("http://api.wunderground.com/api/#{apikey}/conditions/bestfct:1/q/NY/east_glenville.json") do |website|
    now = JSON.parse(website.read)["current_observation"]
	  current = now.values_at(*%w(weather temp_f relative_humidity wind_mph feelslike_f)).map! {
      |element| element.is_a?(String) ? element.downcase : element
    }
    puts "It's currently %s and %1.1f degrees with %s humidity.
Winds are currently %1.1f mph and it feels like %1.1f degrees." % current
  end
else
  puts "
  Invalid Argument: %s
  Usage: weather.rb [-hnt]
  " % ARGV[0]
end
