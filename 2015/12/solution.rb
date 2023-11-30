p File.read("input").scan(/[0-9]+|-[0-9]+/).sum(&:to_i)

p File.read("clean_input").scan(/[0-9]+|-[0-9]+/).sum(&:to_i)

# first_phase = File.read("input").gsub(/(\[[^\{\}]+\])/){|arr| arr.scan(/[0-9]+|-[0-9]+/).sum(&:to_i).to_s}
# first_phase = first_phase.gsub(/\{[^\{\[]*red[^\}\]]*\}/, ".").scan(/[0-9]+|-[0-9]+/).sum(&:to_i)

# puts first_phase

# 54661 : too low

# 69112 : close
# 78257 : close

# 96260 : too high