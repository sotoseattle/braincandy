require 'graphics'

class Shot < Graphics::Body
  def d p
    (self.x - p.x)**2 + (self.y - p.y)**2
  end
end

class Piripi < Graphics::Simulation
  attr_reader :origin
  MULTIPLIER = 100

  def initialize
    @r = 801
    super @r, @r

    @origin = Shot.new(self)
    @origin.position = V::ZERO
    @count_inside = 0
  end

  def draw n
    # clear :black
    circle 0, 0, @r, :white
    text pi(n+1), 0, 700, :white
  end

  def update n
    MULTIPLIER.times do
      shot = Shot.new(self)
      color = if @origin.d(shot) <= @r**2
                @count_inside += 1
                :green
              else
                :red
              end
      point shot.x, shot.y, color
    end
  end

  def pi n
    "%1.5f" % [4.0 * @count_inside / n / MULTIPLIER]
  end
end

Piripi.new.run if $0 == __FILE__
