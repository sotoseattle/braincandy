require 'minitest/autorun'
require 'minitest/reporters'
require 'pry'


reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

require_relative './../lib/grader_array.rb'
require_relative './../lib/grader_hashy.rb'


