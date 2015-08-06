require_relative 'thrie'

class Scrabble
  attr_reader :dic

  def initialize
    @dic = Thrie.new
    File.readlines("/usr/share/dict/words")
        .map(&:chomp).map(&:downcase).uniq
        .each { |w| @dic.add(w) if w =~ /[a-z]+/ }
  end

  def longest_word(tiles)
    (2..(tiles.size)).to_a.reverse.each do |i|
      tiles.permutation(i).each do |sub_a|
        return sub_a.join if @dic.exist?(sub_a.dup)
      end
    end
  end

end

sc = Scrabble.new
p sc.longest_word 'ptteoao'.chars

