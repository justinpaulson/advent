lines = IO.readlines("input")

# folders = {}
# current = "/"
# folders[current] = {}
# lines.each do |line|
#   if line[0] == '$'
#     if line[2..3] == 'cd'
#       if line[5..6] == '..'
#         current = current.split("/")[0..-2].join("/") + "/"
#       else
#         current += "#{line.chomp[5..-1]}/"
#       end
#     end
#   else
#     info, file_dir = line.split(' ')
#     if info=='dir'
#       folders["#{current}#{file_dir}/"] ||= {}
#     else
#       folders[current]["#{current}#{file_dir}"] = info.to_i
#       add_marker = current
#       while add_marker.split("/").length > 1
#         add_marker = add_marker.split("/")[0..-2].join("/") + "/"
#         folders[add_marker]["#{add_marker}#{file_dir}"] = info.to_i
#       end
#       # puts folders["/"].to_s
#     end
#   end
# end

# puts folders.select{|k,v| v.values.sum < 100000}.map{|k,v| v.values.sum}.sum

# files = {}
# current = "/"
# total_file_size = 0
# lines.each do |line|
#   # puts line + " | " + current
#   if line[0] == '$'
#     if line[2..3] == 'cd'
#       if line[5..6] == '..'
#         current = current.split("/")[0..-2].join("/") + "/"
#       else
#         current += "#{line.chomp[5..-1]}/"
#       end
#     end
#   else
#     info, file_dir = line.split(' ')
#     if info!='dir'
#       files["#{current}#{file_dir}"] = info.to_i
#       total_file_size += info.to_i
#     end
#   end
# end
# puts files.values.sum
# puts total_file_size
# space_needed = total_file_size - 40000000
# puts space_needed

# puts folders.select{|k, v| v.values.sum >= (space_needed - 1000000)}.map{|k,v| {k => v.values.sum}}

# lines.each do |line|
#   if line.split(" ")[0].to_i == line.split(" ")[0]
#     files[lines.split(" ")[1]+rand(100).to_s+rand(200).to_s]
# end

# 70000000

# 30000000

class MyFile
  attr_accessor :name, :size, :folder

  def initialize
    # @name = options[:name]
    # @size = options[:size]
    # @folder = options[:folder]
  end
end


files = []
current = "/"
lines.each do |line|
  if line[0] == '$'
    if line[2..3] == 'cd'
      if line[5..6] == '..'
        current = current.split("/")[0..-2].join("/") + "/"
      else
        current += "#{line.chomp[5..-1]}/"
      end
    end
  else
    info, filename = line.split(' ')
    unless info=='dir'
      file = MyFile.new()
      file.name = filename
      file.size = info.to_i
      file.folder = "#{current}"
      files << file
    end
  end
end


puts files.map{|f| f.size}.sum

# 4274331

folders = {}
files.each do |file|
  folders[file.folder] ||= 0
  folders[file.folder] += file.size
  add_marker = file.folder
  while add_marker.split("/").length > 1
    add_marker = add_marker.split("/")[0..-2].join("/") + "/"
    puts add_marker
    folders[add_marker] ||= 0
    folders[add_marker] += file.size
  end
end

puts folders.select{|f, v| v >= 4274331}