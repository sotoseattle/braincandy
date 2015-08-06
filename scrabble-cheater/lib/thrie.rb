class Thrie < Hash
  def initialize
    super
  end

  def add word
    hashify word.chars
  end

  def valid? word
    hashusure? word.chars
  end

  protected

  def end_of_word
    m = Thrie.new
    m["*"] = nil
    m
  end

  def hashify arr
    return end_of_word if arr.empty?
    car, cdr = [arr.shift, arr]
    self[car] ||= Thrie.new
    self[car] = self[car].hashify cdr
    self
  end

  def hashusure? arr
    car, cdr = [arr.shift, arr]
    return false unless self[car]
    if self[car].keys.include?("*") && cdr==[]
      true
    else
      self[car].hashusure? cdr
    end
  end
end

