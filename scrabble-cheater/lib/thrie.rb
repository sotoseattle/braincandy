class Thrie < Hash
  def initialize
    super
  end

  def add word
    feed word.chars
  end

  def end_of_word
    m = Thrie.new
    m["*"] = nil
    m
  end

  def feed arr
    return end_of_word if arr.empty?
    car, cdr = [arr.shift, arr]
    self[car] ||= Thrie.new
    self[car] = self[car].feed cdr
    self
  end

  def exist? arr
    car, cdr = [arr.shift, arr]
    return false unless self[car]

    if self[car].keys.include?("*") && cdr==[]
      true
    else
      self[car].exist? cdr
    end
  end
end

