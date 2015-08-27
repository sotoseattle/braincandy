class ColorWheel < Array
  OFFSET_COLOR = 31 # for red

  def initialize
    @size = %w(red green yellow blue pink cyan).size
    @indx = -1
  end

  def next
    @indx += 1
    @indx = 0 if @indx == @size
    @indx + OFFSET_COLOR
  end
end

class BracketTracker < Array
  def initialize
    @color = ColorWheel.new
  end

  def current_bracket
    self.last[:brack]
  end

  def current_color
    self.last[:color_idx]
  end

  def open_bracket c
    col = @color.next
    self << {brack: c, color_idx: col}
    col
  end

  def close_bracket
    col = self.last[:color_idx]
    self.pop
    col
  end

  alias_method :all_brackets_closed?, :empty?
end

class UnmatchedParensException < ArgumentError; end

class Rainbowizer
  attr_accessor :text_mode

  BRACKS = { ")" => "(", "}" => "{", "]" => "[" }
  OPENER = /\(|\{|\[|"|'/
  CLOSER = /\)|\}|\]/
  QUOTES = /"|'/

  def initialize
    @tracker = BracketTracker.new
  end

  def paint char, color_code
    color_code ? "\e[#{color_code}m#{char}\e[0m" : char
  end

  def stringify char
    text_color = @tracker.current_color
    if char == @tracker.current_bracket
      self.text_mode = false
      @tracker.close_bracket
    end
    paint char, text_color
  end

  def rainbowfy char
    new_color = case char
                when OPENER
                  self.text_mode = true if char =~ QUOTES
                  @tracker.open_bracket(char)
                when CLOSER
                  fail UnmatchedParensException unless @tracker.current_bracket == BRACKS[char]
                  @tracker.close_bracket
                end

    paint char, new_color
  end

  def colorize input_string
    self.text_mode = false

    output = input_string.chars.map do |char|
      if text_mode
        stringify char
      else
        rainbowfy char
      end
    end

    fail UnmatchedParensException unless @tracker.all_brackets_closed?

    output.join
  end
end

s1 = "(define square (lambda (x) (* x x)))"
s2 = "(define square (lambda (x) (* x x))"
s3 = "(define smile \"(:\")"
puts Rainbowizer.new.colorize(s1)

