lines = File.readlines("input")

columns = [{},{},{},{},{},{},{},{}]

lines.each do |line|
  columns[0][line[0]] ||= 0
  columns[0][line[0]] += 1
  columns[1][line[1]] ||= 0
  columns[1][line[1]] += 1
  columns[2][line[2]] ||= 0
  columns[2][line[2]] += 1
  columns[3][line[3]] ||= 0
  columns[3][line[3]] += 1
  columns[4][line[4]] ||= 0
  columns[4][line[4]] += 1
  columns[5][line[5]] ||= 0
  columns[5][line[5]] += 1
  columns[6][line[6]] ||= 0
  columns[6][line[6]] += 1
  columns[7][line[7]] ||= 0
  columns[7][line[7]] += 1
end

ans=columns.map{|col| col.max_by{|k,v| v}[0] }.join

puts ans

ans2=columns.map{|col| col.max_by{|k,v| -v}[0] }.join

puts ans2