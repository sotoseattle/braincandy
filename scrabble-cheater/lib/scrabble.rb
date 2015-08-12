require_relative 'thrie'

class Scrabble
  attr_reader :dic

  def initialize
    @dic = Thrie.new
    File.readlines("/usr/share/dict/words")
        .map(&:chomp).map(&:downcase)
        .each { |w| @dic.add(w) if w.size < 8 }
  end

  def longest_word(tiles)
    (2..(tiles.size)).to_a.reverse.each do |i|
      tiles.permutation(i).each do |scramble|
        utterance = scramble.join
        return utterance if @dic.valid?(utterance)
      end
    end
  end
end

