require 'graphics'
require 'graphics/trail'

class ScrabbleTrainer < Graphics::Simulation
  DISPLAY = 700
  TIMEOUT = 30
  N_CHARS = 8      # more than 8 is too slow
  COLORES = 30

  attr_accessor :clock

  def initialize
    super DISPLAY, DISPLAY, 16
    make_rainbowies
    @clock = Clock.new self, TIMEOUT
    @tiles = populate Tile, N_CHARS
    @answr = longest_word
  end

  def draw n
    clear
    @clock.draw
    @tiles.each &:draw
    text(@answr.map(&:letter).join, 200, h*0.9, :white) unless @clock.visible
  end

  def update n
    @clock.update
    @tiles.each &:update
  end

  private

  def longest_word
    word_letters = ScrabbFast.new(N_CHARS).fetch(@tiles.map(&:letter)).first
    word_tiles = []
    word_letters.chars.each do |c|
      word_tiles << @tiles.find {|t| t.letter == c and !word_tiles .include?(t) }
    end
    word_tiles.each &:char_is_solution
  end

  def make_rainbowies
    fq = 2.4
    ph1, ph2, ph3 = 0, 2, 4
    (0..COLORES).each do |i|
      r = Math.sin(fq*i + ph1) * 230 + 25;
      g = Math.sin(fq*i + ph2) * 230 + 25;
      b = Math.sin(fq*i + ph3) * 230 + 25;
      (0..99).each { |n| register_color("#{i}#{n}".to_sym, r, g, b) }
    end
  end
end

class Tile < Graphics::Body
  GRVTY = V[0, -0.02]
  BOOST = 30

  attr_accessor :i, :solution
  attr_reader :letter, :lw, :lh

  def initialize w
    super w
    self.w = w
    @letter = random_letter
    @lw, @lh = 10, 20
    self.y = w.h - lw

    self.a = self.m = 0
    self.i = w.render_text letter, "#{rand(ScrabbleTrainer::COLORES)}99".to_sym
    self.solution = false
  end

  def update
    if solution and !w.clock.visible
      # move to the top and order the solution
    else
      move
      bounce
    end

    if y == 0
      self.a += random_turn(45)
      self.velocity -= GRVTY * BOOST
    else
      self.velocity += GRVTY
    end
  end

  def draw
    w.put self.i, x-lw/2, y-lh/2
  end

  def char_is_solution
    self.solution = true
  end

  private

  ## Pick a random letter where vowels are more probable than consonants

  def random_letter
    vowels = %w(a e i o u)
    conson = ('a'..'z').to_a - vowels
    l = (rand(8) + 1) > 5 ? vowels.sample : conson.sample
  end
end

## From BrainCandy Scrabble_Cheater problem

class ScrabbFast
  def initialize max_tiles
    @words = File.readlines("/usr/share/dict/words")
                 .map(&:chomp).map(&:downcase)
                 .select { |w| w.size < max_tiles }
  end

  def fetch(tiles)
    tiles.size.downto(2).each do |i|
      sol = @words & tiles.permutation(i).map(&:join)
      return sol if sol.size > 0
    end
    ""
  end
end

class Clock
  attr_accessor :w, :count_down, :tick, :visible

  def initialize w, count_down
    @w = w
    @tick = Time.now
    @count_down = count_down
    @visible = true
  end

  def update
    t0 = Time.now
    delta = t0 - tick
    @count_down -= delta
    if count_down < 0
      @visible = false
    end
    @tick = t0
  end

  def draw
    w.text(("%2.1f" % count_down), 200, w.h*0.9, :white) if @visible
  end
end

ScrabbleTrainer.new.run if $0 == __FILE__
