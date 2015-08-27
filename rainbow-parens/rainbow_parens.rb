class ColorWheel < Array
  OFFSET_COLOR = 31 # for red

  def initialize
    @size = %w(red green yellow blue pink cyan).size
    @indx = -1
  end

  def next
    @indx += 1
    @indx = 0 if @indx == @size
    return @indx + OFFSET_COLOR
  end
end

class BracketTracker < Array
  def initialize
    @rainbow = ColorWheel.new
  end

  def current_bracket
    self.last[:brack]
  end

  def open_bracket c
    self << {brack: c, color_idx: @rainbow.next}
  end

  def live_color
    self.last[:color_idx]
  end

  alias_method :all_brackets_closed?, :empty?
  alias_method :close_bracket,        :pop
end

class Flag
  attr_reader :mode

  def initialize
    @mode = false
  end

  def flip
    @mode = (@mode ? false : true)
  end

  def reset
    @mode = false
  end
end

class String
  def colorize(color)
    "\e[#{color}m#{self}\e[0m"
  end
end

class UnmatchedParensException < ArgumentError; end

class Rainbowizer
  attr_accessor :we_are_in_text

  BRACKS = { ")" => "(", "}" => "{", "]" => "[" }
  OPENER = /\(|\{|\[/
  CLOSER = /\)|\}|\]/
  QUOTES = /"|'/

  def initialize
    @tracker = BracketTracker.new
    @we_are_in_text= Flag.new
  end

  def rainbowfy char
    case char
    when OPENER
      @tracker.open_bracket(char)
      char = char.colorize(@tracker.live_color)
    when CLOSER
      if @tracker.current_bracket == BRACKS[char]
        char = char.colorize(@tracker.live_color)
        @tracker.close_bracket
      else
        fail UnmatchedParensException
      end
    end
    char
  end

  def analyze_quoted_text char
    if @we_are_in_text.mode == false
      @tracker.open_bracket(char)
      @we_are_in_text.flip
    else
      if @tracker.current_bracket == char
        @tracker.close_bracket
        @we_are_in_text.flip
      end
    end
  end

  def colorize input_string
    @we_are_in_text.reset
    output = input_string.chars

    output.map! do |char|
      analyze_quoted_text(char) if char =~ QUOTES
      we_are_in_text.mode ? char : rainbowfy(char)
    end

    fail UnmatchedParensException unless @tracker.all_brackets_closed?

    output.join
  end
end

s1 = "(define square (lambda (x) (* x x)))"
s2 = "(define square (lambda (x) (* x x))"
s3 = "(define smile \"(:\")"
puts Rainbowizer.new.colorize(s1)

