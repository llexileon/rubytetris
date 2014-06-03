#!/usr/bin/env ruby -w

$: << "."
require 'gosu'
require 'lib/player'
require 'lib/grid'
require 'lib/shaperender'
require 'lib/shapelogic'
require 'lib/nextshape'
require 'lib/scoring'
require 'lib/randomizer'
require 'lib/audioengine'

class Gosu::Color
  PURPLE = Gosu::Color.new(0xffff00ff)
  ORANGE = Gosu::Color.new(0xffff9900)
end

class GameWindow < Gosu::Window

  def initialize
    super(240, 680, false)
    self.caption = "Tetris"
    @audio_engine = Tetris::AudioEngine.new(self)
    @game_over = false
    @frame = 0
    @scoring = Tetris::Scoring.new(self)
    @randomizer = Tetris::Randomizer.new
    @grid = Tetris::Grid.new(self, @scoring)
    @shapelogic = Tetris::ShapeLogic.new(self, @grid, @randomizer)
    @next_shape = Tetris::NextShape.new(self, @randomizer)
    @player = PlayerInput.new(self, @shapelogic)
    @font = Gosu::Font.new(self, "assets/victor-pixel.ttf", 30)
    @audio_engine.soundtrack
  end
  
  def update
    return if game_over?
    @frame += 1
    @grid.update

    unless @grid.clearing_lines?
      # Movement is jerky if a move under gravity happens while soft dropping.
      # Not sure if gravity is supposed to be applied while soft dropping.
      @shapelogic.move_down if @frame % gravity == 0
      @player.update
    end
  end

  def draw
    translate 0, 90 do
      @grid.draw
      @shapelogic.draw
    end
    translate 72, 10 do
      @next_shape.draw
    end
    @font.draw "Score:    %05i" % @scoring.score, 10, 620, 0
    @font.draw "Lvl:          %02i" % @scoring.level, 10, 100, 0
    @font.draw "Game Over", 10, 200, 0, 2, 2, Gosu::Color::BLACK if game_over?
  end

  def gravity
    # Based on the NES version of the game.
    # http://tetris.wikia.com/wiki/Tetris_(NES,_Nintendo)
    case @scoring.level
    when 0..7
      48 - (@scoring.level * 5)
    when 8
      8
    when 9
      6
    when 10..12
      5
    when 13..15
      4
    when 16..18
      4
    when 19..28
      2
    else
      1
    end
  end

  def game_over!
    @game_over = true
    @endgamesample.play
  end

  def game_over?
    @game_over
  end

  def draw_square(x, y, c, size)
    draw_quad x, y, c, x+size, y, c, x+size, y+size, c, x, y+size, c
  end

  def play_sample(name)
    @audio_engine.play(name)
  end

  def button_down(id)
    @player.button_down(id) unless @grid.clearing_lines?
    close if id == Gosu::Button::KbEscape
  end
end

window = GameWindow.new
window.show