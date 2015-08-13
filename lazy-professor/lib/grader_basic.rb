module GraderBasic

  def self.cheat filename
    answers = nil

    # read exams and tally choices
    File.open(filename).each_line do |line|
      letters = line.chomp.chars

      answers ||= letters.size.times.collect{|e| Array.new(4,0)}

      letters.each_with_index { |c, i| answers[i][c.ord - 65] += 1 }
    end

    # pick most chosen letters for each question
    answers.map{|e| (e.index(e.max) + 65).chr }.join
  end

end

