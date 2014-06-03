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
  PURPLE1 = Gosu::Color.new (0xff8030f2)
  ORANGE1 = Gosu::Color.new (0xfff1751e)
  CYAN1 = Gosu::Color.new (0xff30f2e1)
  BLUE1 = Gosu::Color.new (0xff30a2f2)
  YELLOW1 = Gosu::Color.new (0xfff2e130)
  GREEN1 = Gosu::Color.new (0xffa2f230)
  RED1 = Gosu::Color.new (0xfff23041)
  GREY1 = Gosu::Color.new (0xffb5b8ba)
  GREY2 = Gosu::Color.new (0xff2d2f31)
end

class GameWindow < Gosu::Window

  def initialize
    super(336, 728, false)
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
    @font = Gosu::Font.new(self, "assets/victor-pixel.ttf", 32)
    @audio_engine.soundtrack
  end
  
  def update
    return if game_over?
    @frame += 1
    @grid.update

    unless @grid.clearing_lines?
      @shapelogic.move_down if @frame % gravity == 0
      @player.update
    end
  end

  def draw
    translate 28, 84 do
      @grid.draw
      @shapelogic.draw
    end
    translate 196, 28 do
      @next_shape.draw
    end
    @font.draw "%05i" % @scoring.score, 25, 43, 0
    @font.draw "Lvl:%2i" % @scoring.level, 25, 15, 0
    @font.draw "Game Over", 38, 205, 0, 1.7, 1.7, Gosu::Color::RED1 if game_over?
  end

  def gravity
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
  	play_sample :boom
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
    close if id == Gosu::Button::KbQ
  end
end

window = GameWindow.new
window.show