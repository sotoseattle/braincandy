module GraderArray
  def self.cheat filename
    answers_tally = nil

    File.open(filename).each_line do |exam|
      exam = exam.chomp.chars
      answers_tally ||= exam.size.times.map { [0, 0, 0, 0] }
      exam.each_with_index { |e, i| answers_tally [i][e.ord - 65] += 1 }
    end

    generate_key_from answers_tally
  end

  def self.generate_key_from answers_array
    answers_array.map { |answer| (answer.index(answer.max) + 65).chr }.join
  end
end

