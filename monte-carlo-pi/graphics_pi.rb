require 'graphics'
require 'pry'

class Dot < Graphics::Body
  def distance_to_origin
    self.x**2 + self.y**2
  end
end

class Piripi < Graphics::Simulation
  MULTIPLIER = 500

  def initialize
    @radius = 800
    @count_inside = 0
    super @radius, @radius
  end

  def draw n
    SDL::WM.set_caption pi_text(n+1), ''
  end

  def update n
    MULTIPLIER.times do
      shot = Dot.new(self)
      color = if shot.distance_to_origin <= @radius**2
                @count_inside += 1
                :green
              else
                :red
              end
      point shot.x, shot.y, color
    end
  end

  def pi_text n
    "Shotgun Pi: " + "%1.5f" % [4.0 * @count_inside / n / MULTIPLIER]
  end
end

Piripi.new.run if $0 == __FILE__
