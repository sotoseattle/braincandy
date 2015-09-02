require 'graphics'
require 'graphics/trail'
require 'pry'

class BasicBouncer < Graphics::Simulation
  SCREEN_LENGTH = 800

  attr_reader :ball

  def initialize
    super SCREEN_LENGTH, SCREEN_LENGTH
    @ball = Ball.new(self)
  end

  def draw n
    clear
    @ball.draw
  end

  def update n
    @ball.update
  end
end

class Ball < Graphics::Body
  attr_reader :x, :y, :a, :m
  attr_accessor :trail

  def initialize w
    super w

    self.a = rand(360)   # <===========================
    self.m = rand(9) + 1 # <===========================
    self.trail = Graphics::Trail.new(w, 6, color = :red)
  end

  def update
    move
    bounce
    trail << self
  end

  def draw
    trail.draw
  end
end

BasicBouncer.new.run if $0 == __FILE__
