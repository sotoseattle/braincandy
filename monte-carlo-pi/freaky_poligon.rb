require 'graphics'

srand 42

class Polygnome < Array
  attr_reader :origin, :r, :s

  def initialize center_x, center_y, w
    @s = w
    @r = w.r
    @origin = V[center_x, center_y]
  end

  def draw
    if size > 2
      points = self << first
      points.each_cons(2) { |a, b| @s.line a.x, a.y, b.x, b.y, :yellow }
    end
  end

  def add vertex
    self << vertex

    if size > 2
      sort_radar
      SDL::WM.set_caption compute_pi, ''
    end
  end

  ##
  # Sort vertex like a radar, by angle to center
  def sort_radar
    sort_by! do |v|
      (360 + Math.atan2((v.y - origin.y), (v.x - origin.x))) % 360
    end
  end

  ##
  # Algorithm to compute area of polygon, needs vertex sorted in radar mode
  def compute_area
    sol = 0.0
    j = size - 1
    each_with_index do |v, i|
      sol += (self[j].x + v.x) * (self[j].y - v.y)
      j = i
    end
    (sol / 2.0).abs
  end

  def compute_pi
    "Pi: " + "%1.5f" % [compute_area / @r**2]
  end
end

class Bouncer < Graphics::Body
  M = 100

  attr_reader :x, :y, :a, :m, :r, :s
  attr_accessor :last

  def initialize w
    super
    @s = w
    @r = w.r
    @x = rand(w.screen.w/4) + w.r
    @y = rand(w.screen.h/4) + w.r
    @a = random_angle
    @m = M
    @last = V[@x, @y]
  end

  def target_point
    rad = @a * D2R
    V[@x + Math.cos(rad) * @m, @y + Math.sin(rad) * @m]
  end

  def outside_circle? v
    (v.x - @r)**2 + (v.y - @r)**2 > @r**2
  end

  ##
  # Slope and offset of line given 2 points
  def line_to p
    slope  = (p.y - @y) / (p.x - @x)
    offset = @y - (slope * @x)
    [slope, offset]
  end

  ##
  # Intersection of enclosing circle and line y = ax + b. Algebraic solution
  def intersection_circle_and l
    a, b = l
    beta = Math.sqrt((2 * a * @r**2) - (2 * a * b * @r) - b**2 + (2 * b * @r))
    alfa = @r - (a * (b - @r))
    gama = (1 + a**2)

    x0 = [(alfa + beta)/gama, (alfa - beta)/gama].min_by {|e| (e - @x).abs}
    y0 = a*x0 + b
    V[x0, y0]
  end

  def draw
    @s.line last.x, last.y, x, y, :red
  end

  def update
    self.last = position
    t = target_point
    if outside_circle? t
      t = intersection_circle_and line_to(t)
      turn (160 + rand(15) - 15)
      self.position = t
      @s.poly.add t
    else
      move
    end
  end
end

class FreakyPi < Graphics::Simulation
  RADIO = 400

  attr_reader :r, :ball, :poly

  def initialize
    @r = RADIO
    super @r * 2, @r * 2
    @poly = Polygnome.new @r, @r, self
    @ball = Bouncer.new self
  end

  def draw n
    clear if @poly.size > 2
    circle @r, @r, @r, :green
    @ball.draw
    @poly.draw
  end

  def update n
    @ball.update
  end
end

FreakyPi.new.run if $0 == __FILE__
