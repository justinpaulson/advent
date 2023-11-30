lines = IO.readlines("input")

strength = Array.new(300) { 0 }

cycle = 1
x = 1

crt = Array.new(241) { " " }

lines.each do |line|
  func, arg = line.split(" ")
  if func == "noop"
    strength[cycle] = x * cycle
    puts "Cycle: #{(cycle).to_s}, X: #{x}, Cycle % 40: #{(cycle - 1) % 40}"
    if x == ((cycle - 1) % 40) || (x-1) == ((cycle - 1) % 40) || (x+1) == ((cycle - 1) % 40)
      crt[cycle-1] = "#"
    else
      crt[cycle-1] = "."
    end
    crt.each_slice(40) do |crts|
      puts crts.join("")
    end
    cycle += 1
  else
    arg = arg.to_i
    strength[cycle] = x * cycle
    puts "Cycle: #{(cycle).to_s}, X: #{x}, Cycle % 40: #{(cycle - 1) % 40}"
    if x == ((cycle - 1) % 40) || (x-1) == ((cycle - 1) % 40) || (x+1) == ((cycle - 1) % 40)
      crt[cycle-1] = "#"
    else
      crt[cycle-1] = "."
    end
    crt.each_slice(40) do |crts|
      puts crts.join("")
    end
    cycle+=1
    strength[cycle] = x * cycle
    puts "Cycle: #{(cycle).to_s}, X: #{x}, Cycle % 40: #{(cycle - 1) % 40}"
    if x == ((cycle - 1) % 40) || (x-1) == ((cycle - 1) % 40) || (x+1) == ((cycle - 1) % 40)
      crt[cycle-1] = "#"
    else
      crt[cycle-1] = "."
    end
    crt.each_slice(40) do |crts|
      puts crts.join("")
    end
    cycle += 1
    x += arg
  end
end


p  strength[20]+strength[60]+strength[100]+strength[140]+strength[180]+strength[220]

crt.each_slice(40) do |crts|
  puts crts.join("")
end


