LEVEL = 7_000

def pascual_iterative(n_levels)
  arr = [1]
  n_levels.times { arr = regurgitate(arr) }
  arr
end

def pascual_recursive(n_levels, starting_level = [1])
  return starting_level if n_levels == 0
  pascual_recursive(n_levels - 1, regurgitate(starting_level))
end

def regurgitate arr
  prev = 0
  arr.map! { |x|
    y = prev + x
    prev = x
    y
  } << prev
end

## Comparing speeds

t0 = Time.now
pascual_iterative LEVEL
puts "iterative: #{Time.now - t0} seconds"

t0 = Time.now
pascual_recursive LEVEL
puts "recursive speed: #{Time.now - t0} seconds"

RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

t0 = Time.now
pascual_recursive LEVEL
puts "opti-tail: #{Time.now - t0} seconds"

