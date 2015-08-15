module GraderHemingway
  def self.generate_exam_key filename
    data_batched_by_student = load_all_exams_from filename

    data_batched_by_answer  = data_batched_by_student.transpose

    data_batched_by_answer.map {|answers| most_frequent_letter_in answers}.join
  end

  def self.load_all_exams_from filename
    File.read(filename).split("\n").map(&:chars)
  end

  def self.most_frequent_letter_in answers
    answers.group_by(&:to_s).values.max_by(&:size).first
  end
end

