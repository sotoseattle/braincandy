module GraderHashy
  def self.cheat filename
    data_matrix = File.open(filename).read.split("\n").map(&:chars)

    transpose(data_matrix).map do |a|
      freq = a.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
      a.max_by { |v| freq[v] }
    end.join
  end

  def self.transpose matrix
    neo = []
    matrix.first.size.times { neo << [] }
    matrix.each { |row| row.each_with_index { |x, i| neo[i] << x } }
    neo
  end
end

