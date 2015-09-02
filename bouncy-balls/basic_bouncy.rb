require 'graphics'
require 'graphics/trail'

class BasicBouncer < Graphics::Simulation
  SCREEN_LENGTH = 800
  N_BALLS = 10

  def initialize
    super SCREEN_LENGTH, SCREEN_LENGTH
    @balls = Array.new(N_BALLS) { Ball.new(self) }
  end

  def draw n
    clear
    @balls.each &:draw
  end

  def update n
    @balls.each &:update
  end
end

class Ball < Graphics::Body
  M = 10
  G = V.new(0, -1)

  attr_reader :x, :y, :a, :m, :g
  attr_accessor :trail

  def initialize w
    super w
    self.a = 45.0
    self.m = M
    self.trail = Graphics::Trail.new(w, 6, :red)
  end

  def update
    self.velocity += G
    move
    bounce
    trail << self
  end

  def draw
    trail.draw
  end
end

BasicBouncer.new.run if $0 == __FILE__
