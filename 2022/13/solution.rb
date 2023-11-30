lines = IO.readlines("input")

class Solution
  def self.right_order left, right, verbose = false
    puts "#{left} vs #{right}" if verbose
    left = eval(left)
    right = eval(right)
    
    if right.class != Array && left.class == Array
      return right_order left.to_s, ([right]).to_s, verbose
    end

    if right.class == Array && left.class != Array
      return right_order ([left]).to_s, right.to_s, verbose
    end
    
    if left == right
      return 0
    end

    if right.class == Integer && left.class == Integer && left != right
      return (left < right ? -1 : 1)
    end

    left.each_with_index do |left_comp, i|
      return -1 unless right[i]
      
      right_comp = right[i]
      
      if right_comp.class == Array || left_comp.class == Array
        next_order = right_order(left_comp.to_s, right_comp.to_s, verbose)
        return next_order if next_order != 0
      else
        puts "#{left_comp} vs #{right_comp}" if verbose
        if right_comp != left_comp
          return left_comp < right_comp ? 1 : (left_comp > right_comp ? -1 : 0)
        end
      end    
    end
    return left.length < right.length ?  1 : -1
  end
end

# puts Solution.right_order("[[[7,2,7],[7,[6,8],4],8,0],[[[4],[7,4,1,7,4],2,[9]],[3],2,5]]","[[0,2],[[5,[6,3,3],5,4,2],[[9,2,4,1,10],8,2,[5,9,5],[8,1,6,9,6]]],[[[],6,7,[4,9,5,3,4],2],[4,[5,2,8,5,7],[8,9,1,1,9]]],[]]", true)

# puts Solution.right_order("[[0,[10,[3,6]],[7,[1,7,7,7,2],3,[9,7,0,2],0],4],[[[10],[5,8,5,4,7],4],0],[]]","[[0],[[[3,9,5],6,[1,6]],[[3,2,1,10],1]],[[2,2],[[]],2,0,[]]]", true)

# puts Solution.right_order("[[2,9,[[5]]],[4,[[9,8,0],8]],[[4,6,[10,2,8,4,3],[9,1,4,7,0]],4,8,[[9,5,1]],[[3,6,4],2,6,1,[]]],[10,7,5,2],[[],[10,[10,10,4],5,7],2]]","[[2,7,[5,1,[6,9,2,6,4]],3]]", true)

# puts Solution.right_order("[[],[4,9],[[8,[2],4,6,[5,7,1,5]],[[],6,0,10],7],[0,[[3,8,6,6],[],7],7,[1,5,9,0,8]]]","[[[4,[2,7,10,2]],3,[[3,8,3],[],3]],[],[4,4,2,0,7]]", true)

# puts Solution.right_order("[[4,[0,4],7,0],[[[8,9],[10],3],1,7,5],[[4]]]", "[[4,8,[7,7,[]]]]", true)

# puts Solution.right_order("[[4,[6,[9,0,1,10],[6,9],[0,5,9,8],[6,6]],9,[[8],[7,1,8,10,2],9,[9,0,5,1,9]]],[],[[1,7,7,[6]],10],[4,[5,4],9,[]]]","[[7],[[7,[1,8,3,9,0],[4,4,9,10,0],6,[2,3,7,8,6]],1]]", true)

# verbose = false
# total = 0
# correct = 0
# indexes = []
# pairs.each_with_index do |pair, i|
#   left, right = pair.split("\n")
#   if Solution.right_order(left, right, verbose) == 1
#     total += i + 1
#     indexes << i
#     correct += 1
#   end
# end
# puts total
# puts correct
# puts pairs.length
# puts indexes.to_s

lines = lines.map{|l| l.chomp}
lines << "[[2]]"
lines << "[[6]]"
lines = lines.sort{|a, b| Solution.right_order(a, b)}.reverse
p (lines.find_index("[[2]]") + 1) * (lines.find_index("[[6]]") + 1)


#20670 too low