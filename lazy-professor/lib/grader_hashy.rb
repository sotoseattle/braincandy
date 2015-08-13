module GraderHashy
  def self.cheat filename
    data_matrix = File.open(filename).read.split("\n").map(&:chars)

    data_matrix.transpose.map do |a|
      freq = a.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
      a.max_by { |v| freq[v] }
    end.join
  end
end

