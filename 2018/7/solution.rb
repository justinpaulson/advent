worker_count = 5
file = "input"

lines = File.readlines(file)

class Requirement
  attr_accessor :name, :requirements, :req_time, :active

  def initialize(name, requirement = nil)
    @name = name
    @req_time = name.ord - "A".ord + 60
    @requirements = []
    @active = false
    puts "My name is #{@name} and I am #{@req_time} years old."
    @requirements << requirement if requirement
  end

  def add_req requirement
    @requirements << requirement
  end

  def remove_req requirement
    @requirements = @requirements.select{|req| req.name != requirement.name}
  end

  def to_s
    "#{name} is blocked by #{requirements.map(&:name).join(", ")}"
  end
end

def blockers requirements
  requirements.each{|req| return true if req.requirements.any?}
  false
end

def find_requirement requirements, name
  requirements.find do |requirement|
    requirement.name == name
  end
end

requirements = []

lines.each do |line|
  dep, name = line.split(" must be finished before step ").each_with_index.map{|part, i| i == 0 ? part.split.last : part.split.first}
  req = find_requirement(requirements, name) || (requirements << Requirement.new(name)).last
  req.add_req(find_requirement(requirements, dep) || (requirements << Requirement.new(dep)).last)
end

requirements = requirements.sort_by(&:name)

output = []

while blockers(requirements)
  catch :found_req do
    requirements.each do |req|
      next if output.include? req.name
      if req.requirements.empty?
        output << req.name
        requirements.each do |sub_req|
          if sub_req.requirements.include?(req)
            sub_req.remove_req(req)
          end
        end
        throw :found_req
      end
    end
  end
end

requirements.each do |req|
  output << req.name if !output.include?(req.name)
end

puts output.join

requirements = []

lines.each do |line|
  dep, name = line.split(" must be finished before step ").each_with_index.map{|part, i| i == 0 ? part.split.last : part.split.first}
  req = find_requirement(requirements, name) || (requirements << Requirement.new(name)).last
  req.add_req(find_requirement(requirements, dep) || (requirements << Requirement.new(dep)).last)
end

requirements = requirements.sort_by(&:name)

output = []

# None of the below is really finished / started yet

workers = Array.new(worker_count) { nil }

s = 0

while blockers(requirements)
  print s.to_s+"   "
  workers = workers.map do |worker_req|
    if !worker_req
      print ".   "
      nil
    elsif worker_req.req_time == 0
      requirements.each do |sub_req|
        if sub_req.requirements.include?(worker_req)
          sub_req.remove_req(worker_req)
        end
      end
      print worker_req.name+"   "
      output << worker_req.name unless output.include? worker_req.name
      nil
    else
      print worker_req.name+"   "
      worker_req.req_time -= 1
      worker_req
    end
  end
  puts output.join
  s+=1
  next if workers.compact.count == worker_count

  requirements.each do |req|
    next if output.include? req.name
    next if req.active
    next if workers.compact.count == worker_count
    if req.requirements.empty?
      workers[workers.index(nil)] = req
      req.active = true
    end
  end
end

requirements.each do |req|
  if !output.include?(req.name)
    s += req.req_time
    output << req.name
  end
end

puts s

puts output.join

# 955 wrong
#1031 wrong