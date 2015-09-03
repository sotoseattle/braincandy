require 'graphics'
require 'graphics/trail'

##
# Balls are pop corn kernels.
# At start they are drop from a distance and fall by gravity,
# they rebound in the red hot pan with renewed energy!

class PopCorn < Graphics::Simulation
  SCREEN_LENGTH = 700
  N_BALLS = 20
  N_COLORS = 30

  def initialize
    super SCREEN_LENGTH, SCREEN_LENGTH, 16
    make_rainbowies
    @balls = Array.new(N_BALLS) { Ball.new(self, "#{rand(N_COLORS)}") }
  end

  def draw n
    clear
    (1..5).each {|y| line 0, y, w, y, :red }
    @balls.each &:draw
  end

  def update n
    @balls.each &:update
  end

  private

  def make_rainbowies
    fq = 2.4
    ph1, ph2, ph3 = 0, 2, 4
    (0..N_COLORS).each do |i|
      r = Math.sin(fq*i + ph1) * 255;
      g = Math.sin(fq*i + ph2) * 255;
      b = Math.sin(fq*i + ph3) * 255;
      (0..99).each { |n| register_color("#{i}#{n}".to_sym, r, g, b) }
    end
  end

end

class Ball < Graphics::Body
  M = 30
  G = V[0, -1]

  attr_accessor :trail, :c

  def initialize w, c
    super w
    self.y = w.h * 0.80
    self.a = self.m = 0
    self.trail = Graphics::Trail.new(w, 6, c)
  end

  def update
    if y == 0
      oomph = a.between?(80, 110) ? 5 : 3
      self.velocity -= G * oomph
      self.a = 90 + rand(45) - 45/2
    else
      self.velocity += G
    end

    move && bounce
    trail << self
  end

  def draw
    w.circle x, y+15, 15, trail.c[0].to_sym, fill = true
    trail.draw
  end
end

PopCorn.new.run if $0 == __FILE__
