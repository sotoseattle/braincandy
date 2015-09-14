require 'graphics'

class Sierpinski < Graphics::Simulation
  SCREEN_LENGTH = 700
  N_COLORS = 30

  def initialize
    super SCREEN_LENGTH, SCREEN_LENGTH, 16
    @level = [1]
    make_rainbowies
  end

  def draw n
    if n < SCREEN_LENGTH
      col = "#{rand(N_COLORS)}99".to_sym
      @level.each_with_index do |p, i|
        point(SCREEN_LENGTH/2 - n/2 + i, n, col) if p.even?
      end
    end
  end

  def update n
    @level = regurgitate(@level)
  end

  private

  def regurgitate arr
    prev = 0
    arr.map! { |x|
      y = prev + x
      prev = x
      y
    } << prev
  end

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

Sierpinski.new.run if $0 == __FILE__
