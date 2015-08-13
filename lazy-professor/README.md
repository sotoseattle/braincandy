# Lazy Professor

I am the laziest professor ever. I've given a multiple choice test (A-D are valid answers) but I lost my test key. I'll assume that whatever answer was most popular for a question is the correct answer.

I've included a file that contains the students quiz answers. Each row represents one student. Write code that figures out the most popular answer to each question and then prints out the key.

Example:

Given:

```
ABCCADCB
DDDCAACB
ABDDABCB
AADCAACC
BBDDAACB
ABDCCABB
ABDDCACB
```

Output:

`ABDCAACB`

[test.txt](https://github.com/SeaRbSg/braincandy/blob/master/lazy-professor/test.txt)

## Solution 1. With Arrays and Lazy

For enormously large files (tons of exams), we start reading the file and we count/compute the answers as we go.

In terms of space memory, I only use an array of integers equal in size to 4 times the number of answers of an exam.

Besides using arrays, I leverage the fact that A,B,C,D => 65, 66, 67, 68 to assign the correct counts to the array.

```ruby
def self.cheat filename
  answers = nil

  File.open(filename).each_line do |line|
    letters = line.chomp.chars
    answers ||= letters.size.times.collect{|e| Array.new(4,0)}
    letters.each_with_index { |c, i| answers[i][c.ord - 65] += 1 }
  end

  answers.map{|e| (e.index(e.max) + 65).chr }.join
end
```

## Solution 2. Hashes and Loading it All

We load the whole file and transpose it to group by answer.

We use hashes to count and choose the most frequent solutions.

```ruby
def self.cheat filename
  data_matrix = File.open(filename).read.split("\n").map(&:chars)

  transpose(data_matrix).map do |a|
    freq = a.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    a.max_by { |v| freq[v] }
  end.join
end

def transpose matrix
  ...
end
```

## Solution 3. In Color!

I am thinking of updating a color with RGB? as dimensions. Then we pick dominant color as answer? (developing)

## Solution 4. Bayesian Beliefs?

Would be cool to pull this one off as an intellectual exercise. (developing)

# Pitfalls

What happens when, for a specific answer we have equal number of values? (i.e. AABBCD). Are both A and B valid answers? I am choosing the first one in alphabetical order.


