inp = File.read("input").chomp

while inp.match?(/aA|Aa|bB|Bb|cC|Cc|dD|Dd|eE|Ee|fF|Ff|gG|Gg|hH|Hh|iI|Ii|jJ|Jj|kK|Kk|lL|Ll|mM|Mm|nN|Nn|oO|Oo|Pp|pP|qQ|Qq|rR|Rr|sS|Ss|tT|Tt|uU|Uu|vV|Vv|Ww|wW|xX|Xx|yY|Yy|zZ|Zz/)
  inp = inp.gsub(/aA|Aa|bB|Bb|cC|Cc|dD|Dd|eE|Ee|fF|Ff|gG|Gg|hH|Hh|iI|Ii|jJ|Jj|kK|Kk|lL|Ll|mM|Mm|nN|Nn|oO|Oo|Pp|pP|qQ|Qq|rR|Rr|sS|Ss|tT|Tt|uU|Uu|vV|Vv|Ww|wW|xX|Xx|yY|Yy|zZ|Zz/,"")
end

puts inp.length


min = 99999999

0.upto(25) do |i|
  inp = File.read("input").chomp
  lower = ("a".ord + i).chr
  upper = lower.upcase
  inp = inp.gsub(/#{lower}|#{upper}/,"")
  while inp.match?(/aA|Aa|bB|Bb|cC|Cc|dD|Dd|eE|Ee|fF|Ff|gG|Gg|hH|Hh|iI|Ii|jJ|Jj|kK|Kk|lL|Ll|mM|Mm|nN|Nn|oO|Oo|Pp|pP|qQ|Qq|rR|Rr|sS|Ss|tT|Tt|uU|Uu|vV|Vv|Ww|wW|xX|Xx|yY|Yy|zZ|Zz/)
    inp = inp.gsub(/aA|Aa|bB|Bb|cC|Cc|dD|Dd|eE|Ee|fF|Ff|gG|Gg|hH|Hh|iI|Ii|jJ|Jj|kK|Kk|lL|Ll|mM|Mm|nN|Nn|oO|Oo|Pp|pP|qQ|Qq|rR|Rr|sS|Ss|tT|Tt|uU|Uu|vV|Vv|Ww|wW|xX|Xx|yY|Yy|zZ|Zz/,"")
  end
  min_for_letter = inp.length
  puts "#{lower}#{upper}"
  puts min_for_letter
  min = min_for_letter if min_for_letter < min
end

puts min


#48806 , too high
