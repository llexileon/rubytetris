require "./lib/shapes"
require "./lib/shaperender"

module Tetris
  class ShapeLogic
    include ShapeRender
    
    def initialize(window, grid, randomizer)
      @window = window
      @grid = grid
      @randomizer = randomizer
      spawn
    end
    
    def rotate_clockwise
      attempt_move(0, 0, 1)
    end
    
    def rotate_counter_clockwise
      attempt_move(0, 0, -1)
    end
    
    def move_down
      unless attempt_move(0, 1, 0)
        lock
        spawn
      end
    end
    
    def move_left
      attempt_move(-1, 0, 0)
    end
    
    def move_right
      attempt_move(1, 0, 0)
    end
    
    def attempt_move(x, y, rotation)
      @x += x
      @y += y
      @rotation += rotation
      
      if fits_grid?
        true
      else
        @x -= x
        @y -= y
        @rotation -= rotation
        false
      end
    end
    
    def lock
      each_block do |bx, by, bc|
        col, row = @x + bx, @y + by
        @grid.cells[row][col] = 1
      end
      @window.play_sample :ping
    end
    
    def spawn
      @shape = @randomizer.next_shape
      @x = 3
      @y = @rotation = 0
      @window.game_over! unless fits_grid?
    end
    
    def fits_grid?
      each_block do |bx, by, bc|
        col, row = @x + bx, @y + by
        return false if outside_walls?(col) || through_floor?(row) || overlapping?(row, col)
      end
      true
    end
    
    def outside_walls?(column)
      column < 0 || column >= Grid::Columns
    end
    
    def through_floor?(row)
      row >= Grid::Rows
    end
    
    def overlapping?(row, column)
      @grid.cells[row][column]
    end
    
    def draw
      draw_at @x * Grid::CellSize, @y * Grid::CellSize
    end
  end
end
