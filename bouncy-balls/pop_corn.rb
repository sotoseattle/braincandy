require 'graphics'
require 'graphics/trail'

##
# Balls are pop corn kernels.
# At start they are drop from a distance and fall by gravity,
# they rebound in the red hot pan with renewed energy!

class PopCorn < Graphics::Simulation
  SCREEN_LENGTH = 700
  N_BALLS = 5
  N_COLORS = 30

  attr_reader :pop, :marquee_colors

  def initialize
    super SCREEN_LENGTH, SCREEN_LENGTH, 16
    open_mixer N_BALLS

    make_rainbowies
    @balls = Array.new(N_BALLS) { Ball.new(self, "#{rand(N_COLORS)}") }
    @flame = image "./atrezzo/mcol-flames.png"
    @pop   = audio "./atrezzo/pop.wav"
  end

  def draw n
    clear
    (10..w).step(10+rand(2)*10).each{|x| blit(@flame, x, 10, 0) }
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
  R = 15
  G = V[0, -1.0]

  attr_accessor :trail, :c

  def initialize w, c
    super w
    self.y = w.h - R
    self.a = self.m = 0
    self.trail = Graphics::Trail.new(w, 6, c)
  end

  def update
    move
    trail << self
    w.pop.play if y <= 0

    bounce
    if y == 0
      self.a += random_turn(45)
      self.velocity -= G * 5
    else
      self.velocity += G
    end
  end

  def draw
    w.circle x, y+R, R, trail.c[0].to_sym, fill = true
    trail.draw
  end
end

PopCorn.new.run if $0 == __FILE__
