require_relative 'solution'

describe Solution do
  describe "#right_order" do
    verbose = true
    
    it "returns 1 for the following" do
      expect(Solution.right_order("[[],[0],[[]]]","[[0],[[4]]]", verbose)).to eq 1
      expect(Solution.right_order("[[],1]", "[[],2]", verbose)).to eq 1
      expect(Solution.right_order("[[1],[2,3,4]]", "[[1],4]", verbose)).to eq 1
      expect(Solution.right_order("[7,7,7]", "[7,7,7,7]", verbose)).to eq 1
      expect(Solution.right_order("[1,1,3,1,1]", "[1,1,5,1,1]", verbose)).to eq 1
      expect(Solution.right_order("[[4,4],4,4]", "[[4,4],4,4,4]", verbose)).to eq 1
      expect(Solution.right_order("[]", "[3]", verbose)).to eq 1
      expect(Solution.right_order("[2,3,0,2]","[2,3,0,2,5]", verbose)).to eq 1
      expect(Solution.right_order("[[[],[[3,4,6,8,5],[6,10],[5,1,10,6]],[[10,1,5],3,0]],[2,[[10,0,3,6],[1,1,9,9,10],[6,2,2,4],3],[[2,6,3,4,8],2,[10,7,4,0]],[3,[9],[1,6,8],7,[]]],[[[10,2,9],[4,10,7,4],[4,8,0,2]],8,0],[3,[7,[0,8,7,10],[9,5,6,0],[7,8,6,5]]],[[[7,5,2],1,[7,2,5],[3,5,4]],[[2],7,10],9,[[],[10],[1,9]],[5,[8,0]]]]","[[0,[],2],[[[2,5,1],4,[3]],[6,[1,2],[6,2],[1,3,8,5,10],[5,3]]],[0,4,9,[[7,10,1,10,5],3,6,1],[3,[4,4]]],[0],[]]", verbose)).to eq 1
      expect(Solution.right_order("[[],[10,0,6,6],[],[]]","[[8,3,7],[[[7,10]]],[]]", verbose)).to eq 1
      expect(Solution.right_order("[[],[2,3,6,[]],[]]","[[7,9,7],[1]]", verbose)).to eq 1
      expect(Solution.right_order("[[4,[6,[9,0,1,10],[6,9],[0,5,9,8],[6,6]],9,[[8],[7,1,8,10,2],9,[9,0,5,1,9]]],[],[[1,7,7,[6]],10],[4,[5,4],9,[]]]","[[7],[[7,[1,8,3,9,0],[4,4,9,10,0],6,[2,3,7,8,6]],1]]", verbose)).to eq 1
      expect(Solution.right_order("[[7,3,[[6,9,2,9],9,[9,10]],3],[9,[],2,[8]],[]]","[[9,[[2],5,[9],0]],[],[[[10,2,0,5],[8],0,[]]],[[8,0,6,[0,5],[]],[9,1,[6],1],[[9],[3,10,10],[5,6,4],2],8]]", verbose)).to eq 1
    end
    
    it "returns -1 for the following" do
      expect(Solution.right_order("[[[],[],9,[7,9,0,[0,2],1],5],[],[[9,10,6],[0]]]","[]", verbose)).to eq -1
      expect(Solution.right_order("[[],2]", "[[],1]", verbose)).to eq -1
      expect(Solution.right_order("[7,7,7,7]", "[7,7,7]", verbose)).to eq -1
      expect(Solution.right_order("[9]", "[[8,7,6]]", verbose)).to eq -1
      expect(Solution.right_order("[[[]]]", "[[]]", verbose)).to eq -1
      expect(Solution.right_order("[1,[2,[3,[4,[5,6,7]]]],8,9]", "[1,[2,[3,[4,[5,6,0]]]],8,9]", verbose)).to eq -1
      expect(Solution.right_order("[[9,[[1,4,4,1],1],3,10,10],[[[],3,4,1]],[6,[[6,6],4,[3,6,5,5],1,[10]],8,[],[8,[],[],[],[5,4]]],[]]","[[[],[],[1,5,6,[9,2,10,6],4],[9,[0],[8,0,8,3],6,[9,3,8]]]]", verbose)).to eq -1
      expect(Solution.right_order("[[9]]","[[7,10,[[5,3,8,8,9]],[7,[3,1,2]]],[3],[[0],7]]", verbose)).to eq -1
      expect(Solution.right_order("[[2,7,[[0,9,3,5],0,2],10]]","[[0],[[[9,3,6,0,1],[10,9],5,[]],[[2,9],5],[[],[9,5,4,8,0],[9,1,7,3,5],[],8]],[[[9],[6,4,2,6,0],3,[0,1,7,6,4]],[],[[2,2,8,1],10,3]]]", verbose)).to eq -1
    end
  end
end