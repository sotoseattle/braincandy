require 'graphics'

class Sierpinski < Graphics::Simulation
  SCREEN_LENGTH = 700

  def initialize
    super SCREEN_LENGTH, SCREEN_LENGTH, 16
    @level = [1]
  end

  def draw n
    if n < SCREEN_LENGTH
      @level.each_with_index do |p, i|
        col = wtf p
        point(SCREEN_LENGTH/2 - n/2 + i, n, col) if col
      end
    end
  end

  def update n
    @level = regurgitate(@level)
  end

  private

  def wtf p
    if p == 1
      :black
    elsif p % 14 == 0
      :blue
    elsif p % 10 == 0
      :red
    elsif p % 6 == 0
      :yellow
    elsif p % 2 == 0
      :black
    else
      false
    end
  end

  def regurgitate arr
    prev = 0
    arr.map! { |x|
      y = prev + x
      prev = x
      y
    } << prev
  end

end

Sierpinski.new.run if $0 == __FILE__
