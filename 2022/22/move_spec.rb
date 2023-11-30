require_relative 'solution'
describe Move do
  before do
    lines = IO.readlines("input").map(&:chomp)

    @grid = new_grid lines.length, lines[0].length

    lines.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        @grid[y][x] = char
      end
    end
  end

  # xdescribe "#move" do
  #   it "works for on top right segment" do
  #     current = [1,100]
  #     direction = "^"
  #     expect(Move.move(@grid, current, direction, 4)).to eq([[197,0], "^"])

  #     current = [1,130]
  #     direction = "^"
  #     expect(Move.move(@grid, current, direction, 10)).to eq([[191,30], "^"])
  #   end

  #   it "works for up on middle top segment" do
  #     # hits rock
  #     current = [0,65]
  #     direction = "^"
  #     expect(Move.move(@grid, current, direction, 3)).to eq([[0,65], "^"])

  #     current = [1,99]
  #     direction = "^"
  #     expect(Move.move(@grid, current, direction, 5)).to eq([[199,3], ">"])

  #     #hits rock @grid[175][2]
  #     current = [0,75]
  #     direction = "^"
  #     expect(Move.move(@grid, current, direction, 6)).to eq([[175,1], ">"])
  #   end

  #   it "works for up on the left segments" do
  #     # hits rock
  #     current = [100,2]
  #     direction = "^"
  #     expect(Move.move(@grid, current, direction, 3)).to eq([[52,52], ">"])

  #     current = [101,30]
  #     direction = "^"
  #     expect(Move.move(@grid, current, direction, 5)).to eq([[80,53], ">"])

  #     #hits rock @grid[175][2]
  #     current = [100,49]
  #     direction = "^"
  #     expect(Move.move(@grid, current, direction, 6)).to eq([[99,55], ">"])
  #   end

  #   describe "works for right" do
  #     it "works for the top right segment" do
  #       current = [1,149]
  #       direction = ">"

  #       # rock at @grid[148][98]
  #       expect(Move.move(@grid, current, direction, 4)).to eq([[148,99], "<"])

  #       current = [30,149]
  #       direction = ">"

  #       expect(Move.move(@grid, current, direction, 4)).to eq([[119,96], "<"])

  #       current = [49,149]
  #       direction = ">"

  #       # rock at @grid[100][97]
  #       expect(Move.move(@grid, current, direction, 7)).to eq([[100,98], "<"])
  #     end

  #     it "works for the second segment down" do
  #       current = [51,99]
  #       direction = ">"

  #       expect(Move.move(@grid, current, direction, 4)).to eq([[46,101], "^"])

  #       current = [70,99]
  #       direction = ">"

  #       # rock at @grid[48][120]
  #       expect(Move.move(@grid, current, direction, 4)).to eq([[49,120], "^"])

  #       current = [98,97]
  #       direction = ">"

  #       # rock at @grid[45][148]
  #       expect(Move.move(@grid, current, direction, 8)).to eq([[46,148], "^"])
  #     end

  #     it "works for third segment down" do
  #       current = [101,99]
  #       direction = ">"

  #       expect(Move.move(@grid, current, direction, 4)).to eq([[48,146], "<"])

  #       current = [120,99]
  #       direction = ">"

  #       expect(Move.move(@grid, current, direction, 4)).to eq([[29,146], "<"])

  #       current = [148,98]
  #       direction = ">"

  #       expect(Move.move(@grid, current, direction, 8)).to eq([[1,143], "<"])
  #     end

  #     it "works for the bottom segment" do
  #       current = [151,49]
  #       direction = ">"

  #       expect(Move.move(@grid, current, direction, 4)).to eq([[146,51], "^"])

  #       current = [170,49]
  #       direction = ">"

  #       expect(Move.move(@grid, current, direction, 4)).to eq([[147,70], "^"])

  #       current = [198,48]
  #       direction = ">"

  #       expect(Move.move(@grid, current, direction, 8)).to eq([[143,98], "^"])
  #     end
  #   end
  # end

    describe "works for down" do
      it "works for the top right sement" do
        # current = [49,120]
        # direction = "v"

        # expect(Move.move(@grid, current, direction, 4)).to eq([[70,96], "<"])

        current = [49,101]
        direction = "v"

        expect(Move.move(@grid, current, direction, 4)).to eq([[51,96], "<"])

        current = [49,149]
        direction = "v"

        expect(Move.move(@grid, current, direction, 8)).to eq([[1,143], "<"])
      end
    end

    # xit "works for left" do
    #   # current = [1,100]
    #   # direction = "^"

    #   # puts @grid.to_s

    #   # expect(Move.move(@grid, current, direction, 4)).to eq([[197,0], "^"])
    # end
end