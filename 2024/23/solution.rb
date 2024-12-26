require '../../grid.rb'
ARGV[0] ||= "input"
lines = IO.readlines(ARGV[0]).map(&:chomp)

computers = {}

lines.each do |line|
  comp1, comp2 = line.chomp.split("-")
  computers[comp1] ||= []
  computers[comp2] ||= []
  computers[comp1] << comp2
  computers[comp2] << comp1
end

total = {}

winners = []
computers.keys.each do |a|
  a_connections = computers[a]
  a_connections.each do |b|
    b_connections = computers[b]
    matches = a_connections & b_connections
    matches.each do |match|
      winners << [a,b,match].sort
      total[[a,b,match].sort] = true
    end
  end
end

total = 0
winners.uniq!.each { |w| total += 1 if w.any?{|wi| wi[0] == 't' }}

puts total

groups = []
party = []
computers.keys.each_with_index do |a_match, i|
  a_connections = computers[a_match]
  catch :found_group do
    a_connections.each do |b_match|
      b_connections = computers[b_match]
      b_matches = a_connections & b_connections
      b_matches.each do |c_match|
        c_connections = computers[c_match]
        c_matches = c_connections & a_connections & b_connections
        c_matches.each do |d_match|
          d_connections = computers[d_match]
          d_matches = d_connections & a_connections & b_connections & c_connections
          d_matches.each do |e_match|
            e_connections = computers[e_match]
            e_matches = e_connections & a_connections & b_connections & c_connections & d_connections
            e_matches.each do |f_match|
              f_connections = computers[f_match]
              f_matches = f_connections & a_connections & b_connections & c_connections & d_connections & e_connections
              f_matches.each do |g_match|
                g_connections = computers[g_match]
                g_matches = g_connections & a_connections & b_connections & c_connections & d_connections & e_connections & f_connections
                g_matches.each do |h_match|
                  h_connections = computers[h_match]
                  h_matches = h_connections & a_connections & b_connections & c_connections & d_connections & e_connections & f_connections & g_connections
                  h_matches.each do |i_match|
                    i_connections = computers[i_match]
                    i_matches = i_connections & a_connections & b_connections & c_connections & d_connections & e_connections & f_connections & g_connections & h_connections
                    i_matches.each do |j_match|
                      j_connections = computers[j_match]
                      j_matches = j_connections & a_connections & b_connections & c_connections & d_connections & e_connections & f_connections & g_connections & h_connections & i_connections
                      j_matches.each do |k_match|
                        k_connections = computers[k_match]
                        k_matches = k_connections & a_connections & b_connections & c_connections & d_connections & e_connections & f_connections & g_connections & h_connections & i_connections & j_connections
                        k_matches.each do |l_match|
                          l_connections = computers[l_match]
                          l_matches = l_connections & a_connections & b_connections & c_connections & d_connections & e_connections & f_connections & g_connections & h_connections & i_connections & j_connections & k_connections
                          if l_matches.any?
                            groups << [a_match,b_match,c_match,d_match,e_match,f_match,g_match,h_match,i_match,j_match,k_match,l_matches[0]].sort
                          else
                            groups << [a_match,b_match,c_match,d_match,e_match,f_match,g_match,h_match,i_match,j_match,k_match].sort
                          end
                          throw :found_group
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

puts groups.sort_by(&:length).last.sort.join(',')
