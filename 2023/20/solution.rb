require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

@modules = {}
lines.each_with_index do |line, y|
  name, destinations = line.split(" -> ")
  type = ""
  destinations = destinations.split(", ")
  type = "b" if name == "broadcaster"
  type = "f" if name[0] == "%"
  type = "c" if name[0] == "&"
  name = name[1..-1] if type != "b"
  @modules[name] = { destinations: destinations, type: type, value: 0 }
end

@modules.each do |name, mo|
  mo[:destinations].each do |dest|
    next unless @modules[dest]
    if @modules[dest][:type] == "c"
      @modules[dest][:inputs] ||= {}
      @modules[dest][:inputs][name] = 0
    end
  end
end



# flip-flop = %
# conjunction = &
# they initially default to remembering a low pulse for each input. When a pulse is received, the conjunction module first updates its memory for that input. Then, if it remembers high pulses for all inputs, it sends a low pulse; otherwise, it sends a high pulse.

# button sends low puls (0) to the broadcaster module
# broadcaster sends to all connected modules

@sent_pulses_high = 0
@sent_pulses_low = 0

@button_total_clicks = 0

@pulses = {}
@cycles = []
def push_button
  @sent_pulses_low += 1
  @button_total_clicks += 1
  current_module = @modules["broadcaster"]
  pulses = []

  current_module[:destinations].each{|d| pulses << ["broadcaster", d, 0]}
  while pulses.length > 0
    pulse = pulses.shift
    @pulses[pulse] ||= 0
    @pulses[pulse] += 1
    if pulse[2] == 1
      @sent_pulses_high += 1
    else
      @sent_pulses_low += 1
    end
    current_module = @modules[pulse[1]]

    if pulse[1] == "hb" && pulse[2] == 1
      puts "Sent to HB: #{pulse}"
      puts "Button push: #{@button_total_clicks}"
      @cycles << @button_total_clicks
      if @cycles.length == 4
        puts @cycles.reduce(1, :lcm)
        exit
      end
    end

    if pulse[1] == "rx" && pulse[2] == 0
      puts @button_total_clicks
      exit
    end

    # puts "Current pulses sent: #{@sent_pulses_high} high, #{@sent_pulses_low} low"

    next unless current_module

    case current_module[:type]
    when "b"
      current_module[:destinations].each{|d| pulses << [pulse[1], d, pulse[2]]}
    when "f"
      if pulse[2] == 0
        current_module[:value] = current_module[:value] == 0 ? 1 : 0
        current_module[:destinations].each{|d| pulses << [pulse[1], d, current_module[:value]]}
      end
    when "c"
      current_module[:inputs][pulse[0]] = pulse[2]
      if current_module[:inputs].all?{|k, v| v == 1}
        current_module[:destinations].map{|d| pulses << [pulse[1], d, 0]}
      else
        current_module[:destinations].map{|d| pulses << [pulse[1], d, 1]}
      end
    end
  end
end

# part 1
# 1000.times do
#   push_button
# end

# puts @sent_pulses_high * @sent_pulses_low

while true
  push_button
  # puts @button_total_clicks #if @button_total_clicks % 1000000 == 0
  # puts @pulses.to_s
  # key_wait
end
