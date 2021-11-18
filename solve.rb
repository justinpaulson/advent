require 'httparty'
require 'fileutils'

#  usage
#
#> ruby advent.rb {answer} {puzzle} {day} {year}
#
session_cookie = ENV['ADVENT_SESSION'] || 'here'

answer = ARGV[0]
puzzle = ARGV[1] || 1
day = ARGV[2] || (Time.now+2*60*60).day.to_s
year = ARGV[3] || Time.now.year.to_s

url="https://adventofcode.com/#{year}/day/#{day}/answer"

cookie_hash = HTTParty::CookieHash.new
cookie_hash.add_cookies("session" => session_cookie)
response = HTTParty.post(url, headers: {'Cookie' => cookie_hash.to_cookie_string }, body: {level: puzzle, answer: answer})

puts response.body