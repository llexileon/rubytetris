#!/usr/bin/env ruby -w

require 'gosu'

class GameWindow < Gosu::Window

	WIDTH = 640 
	HEIGHT = 480

	def initialize
		super(WIDTH, HEIGHT, false)
		self.caption = "Ruby Tetris"

		# @lines = 0
		# @level = 1

		# @menu = Menu.new
		# @player = Player.new
		# @grid = Grid.new
		# @high_scores = HighScores.new
	end

end

window = GameWindow.new
window.show