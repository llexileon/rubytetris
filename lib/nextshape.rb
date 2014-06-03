require "./lib/shapes"
require "./lib/shaperender"

module Tetris
  class NextShape
    include ShapeRender
    
    def initialize(window, random_generator)
      @window = window
      @random_generator = random_generator
      @rotation = 0
    end
    
    def draw
      @shape = @random_generator.peek
      draw_at(0, 0)
    end
  end
end
