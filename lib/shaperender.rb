module Tetris
  module ShapeRender
    Colors = {
      :I => :cyan1,
      :J => :blue1,
      :L => :orange1,
      :O => :yellow1,
      :S => :green1,
      :T => :purple1,
      :Z => :red1
    }
    
    def each_block
      0.upto(3) do |x|
        0.upto(3) do |y|
          c = Shapes[@shape][@rotation & 3][y][x]
          yield x, y, c if c == 1
        end
      end
    end
    
    def draw_at(x, y)
      each_block do |bx, by, bc|
        wx = bx * Grid::CellSize + x
        wy = by * Grid::CellSize + y
        c = Gosu::Color.const_get Colors[@shape].to_s.upcase
        @window.draw_square wx, wy, c, Grid::CellSize - 1
      end
    end
  end
end