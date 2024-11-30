ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)
parts = IO.readlines("#{ARGV[0]}parts").map(&:chomp)

@workflows = {}
lines.each do |line|
  name = line.split("{")[0]
  puts line
  steps = line.split("{")[1].split("}")[0]
  steps = steps.split(",")
  steps = steps.map do |step|
    out_value = step unless step.include?(":")
    condition, location = step.split(":")
    if condition.include?("<")
      condition = [condition.split("<")[0].to_sym, "<", condition.split("<")[1].to_i]
    elsif condition.include?(">")
      condition = [condition.split(">")[0].to_sym, ">", condition.split(">")[1].to_i]
    end
    out_value ? out_value : [condition, location]
  end

  @workflows[name] = steps
end

paths = [[{x:[1,4000], m:[1,4000], a:[1,4000], s:[1,4000]}, ["in"], 0]]


def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

while paths.sum{|p| p[1][-1] == "A" || p[1][-1] == "R" ? 0 : 1} > 0
  paths.each do |path|
    next if path[1][-1] == "A" || path[1][-1] == "R"
    workflow = @workflows[path[1][-1]]
    step = workflow[path[2]]
    if step.is_a?(Array)
      condition, location = step

      if condition[1] == "<"
        if condition[2] > path[0][condition[0]][0]
          new_path = [deep_copy(path[0]), path[1].clone, path[2] + 1]
          new_path[0][condition[0]][0] = condition[2]
          paths << new_path
        end
        path[0][condition[0]][1] = condition[2] - 1
      elsif condition[1] == ">"
        if condition[2] < path[0][condition[0]][1]
          new_path = [deep_copy(path[0]), path[1].clone, path[2] + 1]
          new_path[0][condition[0]][1] = condition[2]
          paths << new_path
        end
        path[0][condition[0]][0] = condition[2] + 1
      end

      path[1] << location
      path[2] = 0
    else

      path[1] << step
      path[2] = 0
    end
  end
end

puts paths.sum{|path| path[1][-1] == "A" ? path[0].keys.inject(1){|sum, key| sum * (path[0][key][1] - path[0][key][0] + 1)} : 0}
