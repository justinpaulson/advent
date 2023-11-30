# Player 1 starting position: 7
# Player 2 starting position: 1


# pos = [7,1]
# scores = [0,0]
# dice = 1
# rolls = 0
# current = 0
# player = 0
# while scores.max < 1000
#   if rolls % 3 == 0 && rolls > 0
#     move = current
#     current = 0
#     pos[player] += move
#     pos[player] = (pos[player] - 1) % 10 + 1
#     scores[player] += pos[player]
#     player = player == 0 ? 1 : 0
#     break if scores[player] > 1000
#     puts "positions: #{pos.to_s}"
#     puts "scores: #{scores.to_s}"
#     # sleep 0.1
#   end
#   rolls +=1
#   current += dice
#   dice = dice % 100 + 1
# end
# puts scores.min * (rolls-1)

# 3 in 1 branches * 1
# 4 in 3 branches * 3
# 5 in 6 branches * 6
# 6 in 7 branches * 7
# 7 in 6 branches * 6
# 8 in 3 branches * 3
# 9 in 1 branches * 1

# pos = [4,8]
# scores = {[pos,[0,0]]=>1}
# player = 0
# round = 0
# while scores.any?{|k,v| k[1].max < 21 && v != 0}
#   new_scores = {}
#   scores.select{|k,v| v != 0}.each do |k,v|
#     if k[1].max < 21
#       new_scores[k] = 0
#       if player == 0
#         position = k[0][0] + 3
#         position = (position - 1) % 10 + 1
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] ||= 0
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] += v
#         position = k[0][0] + 4
#         position = (position - 1) % 10 + 1
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] ||= 0
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] += 3*v
#         position = k[0][0] + 5
#         position = (position - 1) % 10 + 1
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] ||= 0
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] += 6*v
#         position = k[0][0] + 6
#         position = (position - 1) % 10 + 1
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] ||= 0
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] += 7*v
#         position = k[0][0] + 7
#         position = (position - 1) % 10 + 1
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] ||= 0
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] += 6*v
#         position = k[0][0] + 8
#         position = (position - 1) % 10 + 1
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] ||= 0
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] += 3*v
#         position = k[0][0] + 9
#         position = (position - 1) % 10 + 1
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] ||= 0
#         new_scores[[[position,k[0][1]],[k[1][0] + position,k[1][1]]]] += v
#       else
#         position = k[0][1] + 3
#         position = (position - 1) % 10 + 1
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] ||= 0
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] += v
#         position = k[0][1] + 4
#         position = (position - 1) % 10 + 1
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] ||= 0
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] += 3*v
#         position = k[0][1] + 5
#         position = (position - 1) % 10 + 1
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] ||= 0
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] += 6*v
#         position = k[0][1] + 6
#         position = (position - 1) % 10 + 1
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] ||= 0
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] += 7*v
#         position = k[0][1] + 7
#         position = (position - 1) % 10 + 1
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] ||= 0
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] += 6*v
#         position = k[0][1] + 8
#         position = (position - 1) % 10 + 1
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] ||= 0
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] += 3*v
#         position = k[0][1] + 9
#         position = (position - 1) % 10 + 1
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] ||= 0
#         new_scores[[[k[0][0], position],[k[1][0],k[1][1] + position]]] += v
#       end
#     else
#       new_scores[k] ||= 0
#       new_scores[k] += v
#     end
#   end
#   scores = new_scores
#   player = player == 0 ? 1 : 0
#   round += 1
# end

# puts scores.to_s

# puts scores.sum{|k,v| k[1][0] > k[1][1] ? v : 0}
# puts scores.sum{|k,v| k[1][1] > k[1][0] ? v : 0}


scores = {[7, 1, 0, 0]=>1}
player = 0
while scores.any?{|k,v| k[2..-1].max < 21}
  new_scores = {}
  scores.each do |(p1,p2,s1,s2),times|
    if [s1,s2].max < 21
      if player == 0
        np1 = (p1 + 2) % 10 + 1
        new_scores[[np1,p2,s1+np1,s2]] ||= 0
        new_scores[[np1,p2,s1+np1,s2]] += times
        np1 = (p1 + 3) % 10 + 1
        new_scores[[np1,p2,s1+np1,s2]] ||= 0
        new_scores[[np1,p2,s1+np1,s2]] += times*3
        np1 = (p1 + 4) % 10 + 1
        new_scores[[np1,p2,s1+np1,s2]] ||= 0
        new_scores[[np1,p2,s1+np1,s2]] += times*6
        np1 = (p1 + 5) % 10 + 1
        new_scores[[np1,p2,s1+np1,s2]] ||= 0
        new_scores[[np1,p2,s1+np1,s2]] += times*7
        np1 = (p1 + 6) % 10 + 1
        new_scores[[np1,p2,s1+np1,s2]] ||= 0
        new_scores[[np1,p2,s1+np1,s2]] += times*6
        np1 = (p1 + 7) % 10 + 1
        new_scores[[np1,p2,s1+np1,s2]] ||= 0
        new_scores[[np1,p2,s1+np1,s2]] += times*3
        np1 = (p1 + 8) % 10 + 1
        new_scores[[np1,p2,s1+np1,s2]] ||= 0
        new_scores[[np1,p2,s1+np1,s2]] += times
      else
        np2 = (p2 + 2) % 10 + 1
        new_scores[[p1,np2,s1,s2+np2]] ||= 0
        new_scores[[p1,np2,s1,s2+np2]] += times
        np2 = (p2 + 3) % 10 + 1
        new_scores[[p1,np2,s1,s2+np2]] ||= 0
        new_scores[[p1,np2,s1,s2+np2]] += times*3
        np2 = (p2 + 4) % 10 + 1
        new_scores[[p1,np2,s1,s2+np2]] ||= 0
        new_scores[[p1,np2,s1,s2+np2]] += times*6
        np2 = (p2 + 5) % 10 + 1
        new_scores[[p1,np2,s1,s2+np2]] ||= 0
        new_scores[[p1,np2,s1,s2+np2]] += times*7
        np2 = (p2 + 6) % 10 + 1
        new_scores[[p1,np2,s1,s2+np2]] ||= 0
        new_scores[[p1,np2,s1,s2+np2]] += times*6
        np2 = (p2 + 7) % 10 + 1
        new_scores[[p1,np2,s1,s2+np2]] ||= 0
        new_scores[[p1,np2,s1,s2+np2]] += times*3
        np2 = (p2 + 8) % 10 + 1
        new_scores[[p1,np2,s1,s2+np2]] ||= 0
        new_scores[[p1,np2,s1,s2+np2]] += times
      end
    else
      new_scores[[p1,p2,s1,s2]] ||= 0
      new_scores[[p1,p2,s1,s2]] += times
    end
  end
  scores = new_scores
  player = player == 0 ? 1 : 0
end

puts [scores.sum{|k,v| k[2] > k[3] ? v : 0},scores.sum{|k,v| k[2] < k[3] ? v : 0}].max
