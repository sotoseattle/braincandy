module GraderHashy
  def self.cheat filename
    exam_data = File.read(filename).split("\n").map(&:chars).transpose

    exam_data.map do |answers|
      freq = answers.inject(Hash.new(0)) { |h, letter| h[letter] += 1; h }
      answers.max_by { |letter| freq[letter] }
    end.join
  end
end

