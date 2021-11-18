require 'httparty'
require 'fileutils'

#  usage
#
#> ruby advent.rb {day} {year} {file}
#
session_cookie = ENV['ADVENT_SESSION'] || 'here'

day = ARGV[0] || (Time.now+2*60*60).day.to_s
year = ARGV[1] || Time.now.year.to_s
file = ARGV[2] || "input"

url="https://adventofcode.com/#{year}/day/#{day}/input"
puts url

cookie_hash = HTTParty::CookieHash.new
cookie_hash.add_cookies("session" => session_cookie)
File.open("./#{year}/#{day}/#{file}", 'w') { |file| file.write(HTTParty.get(url, headers: {'Cookie' => cookie_hash.to_cookie_string }).chomp)}
puts "Input Copied to: #{year}/#{day}/#{file}"
FileUtils.cd("#{year}")