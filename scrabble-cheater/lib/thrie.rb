class Thrie < Hash
  def initialize
    super
  end

  def feed(arr)
    car = arr.shift

    if self[car]
      self[car].feed(arr)
    else
      self[car] = arr.empty? ? "*" : Thrie.new.feed(arr)
    end
    self
  end
end

