require 'graphics'

srand 42

class Polygnome < Array
  attr_accessor :origin, :radius

  def initialize center_x, center_y, radius
    self.origin = V[center_x, center_y]
    self.radius = radius
  end

  def add vertex
    self << vertex

    if size > 2
      self.sort_radar
      SDL::WM.set_caption self.compute_pi, ''
    end
  end

  ##
  # Sort vertex like a radar, by angle to center
  def sort_radar
    self.sort_by! do |v|
      (360 + Math.atan2((v.y - origin.y), (v.x - origin.x))) % 360
    end
  end

  ##
  # Algorithm to compute area of polygon, needs vertex sorted in radar mode
  def compute_area
    sol = 0.0
    j = size - 1
    self.each_with_index do |v, i|
      sol += (self[j].x + v.x) * (self[j].y - v.y)
      j = i
    end
    (sol / 2.0).abs
  end

  def compute_pi
    "Pi: " + "%1.5f" % [compute_area / self.radius**2]
  end
end

class Bouncer < Graphics::Body
  M = 50

  def initialize w
    super
    self.w = w
    self.x = rand(w.screen.w/4) + w.r
    self.y = rand(w.screen.h/4) + w.r
    self.a = random_angle
    self.m = M
  end

  def target_point
    rad = self.a * D2R
    V[self.x + Math.cos(rad) * self.m, self.y + Math.sin(rad) * self.m]
  end

  def outside_circle? v
    (v.x - w.r)**2 + (v.y - w.r)**2 > w.r**2
  end

  ##
  # Slope and offset of line given 2 points
  def line_to p
    slope  = (p.y - self.y) / (p.x - self.x)
    offset = self.y - (slope * self.x)
    [slope, offset]
  end

  ##
  # Intersection of enclosing circle and line y = ax + b. Algebraic solution
  def intersection_circle_and l
    a, b = l
    beta = Math.sqrt((2 * a * w.r**2) - (2 * a * b * w.r) - b**2 + (2 * b * w.r))
    alfa = w.r - (a * (b - w.r))
    gama = (1 + a**2)

    x0 = [(alfa + beta)/gama, (alfa - beta)/gama].min_by {|e| (e - self.x).abs}
    y0 = a*x0 + b
    V[x0, y0]
  end

  def go
    linea = [] << x << y

    t = target_point
    if outside_circle? t
      t = intersection_circle_and line_to(t)
      self.w.add_to_polygon t
      self.position = t
      self.turn (160 + rand(15) - 15)
    else
      move
    end

    linea << x << y
  end
end

class FreakyPi < Graphics::Simulation
  RADIO = 400

  attr_accessor :r, :ball, :poly

  def initialize
    self.r = RADIO
    super r * 2, r * 2
    self.ball = Bouncer.new(self)
    self.poly = Polygnome.new r, r, r
  end

  def draw n
    circle self.r, self.r, self.r, :white
  end

  def update n
    if self.poly.size > 2
      self.clear

      points = self.poly << self.poly.first
      points.each_cons(2) do |a, b|
        line a.x, a.y, b.x, b.y, :yellow
      end
    end

    line *self.ball.go, :red
  end

  def add_to_polygon p
    self.poly.add p
  end
end

FreakyPi.new.run if $0 == __FILE__
