# Lazy Professor

## The Quizz

=======
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

## Musings

IMHO the interesting bit of the exercise is that as we process a stream of answers we need to collect the information into something that, kind of a storage box, an object or data structure such, that will allow us to retrieve the information later on. There are two aspects to this: The container and the algorithm.

As developers we tend to use familiar constructs like hashes and arrays, and simple operations like counting. Hashes (see solution 3) where we store the count of each processed answer, or Arrays (see solution 2) that work the exact same way but where we avoid the use of keys because we already know the natural order of the keys (A..D) and how they map to the array.

But the fun lies in thinking of other ways to design that storing box: What kind of object can we use to store information in it to later retrieve it?

One cool way to go about it would be using colors. Imagine that we start with a bucket of transparent water, as we process the first answer (letter A) we add a drop of the color associated to A to the bucket, in effect tinting it, now the water's color is A. The second answer is B, and we add a drop of color B to it, mixing the colors. As we go on, we add new drops of colors. At the end we would have some brackish water, from which we could (??) extract the dominant elementary color (A, B, C, or D). I have no idea if this is viable or how to go about it.

The same goes for the way of processing the information. The natural thing is to count, which in essence is computing the frequency and therefore the probability (unnormalized). But, what about instead of using the frequentist approach to computing this frequencies we were to compute the degree of belief on the answer using Bayes Rule? I am still mired trying to understand how to make this approach work.

These are the solutions I came up with:

### Solution 1. Hemingway

This was my final solution. A refactoring from scratch (the best ones), focused on making it understandable and brief. (Trying to Hemingway the s#^t out of it to make it expressive).

I used both group_by and max_by, because it seemed the most readable way to understand what is going on during processing.

```ruby
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
```

### Solution 2. Arrays & Streamy

Thought for large files. We start reading the file and we count/compute the answers as we go.

In terms of space memory, it only uses an array of integers equal in size to 4 times the number of answers of an exam. Besides using arrays, I leverage the fact that A,B,C,D => 65, 66, 67, 68 to assign the correct counts to the array.

```ruby
File.open(filename).each_line do |exam|
  exam = exam.chomp.chars
  answers_tally ||= exam.size.times.map { [0, 0, 0, 0] }
  exam.each_with_index { |e, i| answers_tally [i][e.ord - 65] += 1 }
end

answers_tally.map { |answer| (answer.index(answer.max) + 65).chr }.join
```

### Solution 3. Hashes and Loading it All

It uses hashes to count and choose the most frequent solutions.

```ruby
exam_data = File.open(filename).read.split("\n").map(&:chars).transpose

exam_data.map do |answers|
  freq = answers.inject(Hash.new(0)) { |h, letter| h[letter] += 1; h }
  answers.max_by { |letter| freq[letter] }
end.join
```

=======
[test.txt](https://github.com/SeaRbSg/braincandy/blob/master/lazy-professor/test.txt)
