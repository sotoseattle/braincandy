def distance x, y
  Math.sqrt x**2 + y**2
end

def pi iterations = 30_000
  inside = 0.0
  iterations.times { inside += 1 if distance(rand, rand) < 1.0 }
  4 * inside / iterations
end

puts pi
