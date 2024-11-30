require 'prime'

h = 0
b = 65
c = b
b *= 100
b += 100000
c = b
c += 17000
while b != c
  h += 1 if !Prime.prime?(b)
  b += 17
end

h += 1 if !Prime.prime?(b)

puts h
