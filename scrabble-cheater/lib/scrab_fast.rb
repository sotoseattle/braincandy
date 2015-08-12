class ScrabFast
  def initialize
    @words = File.readlines("/usr/share/dict/words")
                 .map(&:chomp).map(&:downcase)
                 .select { |w| w.size < 8 }
  end

  def fetch(tiles)
    tiles.size.downto(2).each do |i|
      sol = @words & tiles.permutation(i).map(&:join)
      return sol if sol.size > 0
    end
  end
end

