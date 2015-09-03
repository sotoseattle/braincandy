require 'graphics'
require 'graphics/trail'

class TapDancing < Graphics::Simulation
  SCREEN_LENGTH = 700
  N_BALLS = 4*1
  N_COLORS = 50

  def initialize
    super SCREEN_LENGTH, SCREEN_LENGTH, 16
    make_rainbowies
    @balls = Array.new(N_BALLS) { Ball.new(self, "#{rand(N_COLORS)}") }
  end

  def draw n
    clear
    @balls.each_slice(4) do |a, b, c, d|
      bezier a.x, a.y, b.x, b.y+300, c.x, c.y+500, d.x, d.y, :red, l = 7
    end
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
      self.velocity -= G*3
      self.a = 90 + rand(45) - 45/2
      # %x[say "ha" ]
    else
      self.velocity += G
    end

    move && bounce
    trail << self
  end

  def draw
    trail.draw
  end
end

TapDancing .new.run if $0 == __FILE__
