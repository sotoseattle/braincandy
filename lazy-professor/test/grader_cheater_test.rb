require 'test_helper'
require 'tempfile'

class GraderBasicTest < Minitest::Test
  include GraderBasic
  def test_small_file
    assert_equal 'ABDCAACB', GraderBasic.cheat('test/input_1.txt')
  end

  def test_long_file
    assert_equal 'BACBCAAACBCAAABDABBBBDBCBDAABDADDACBAACADDBAABABCB',
                 GraderBasic.cheat('test/input_2.txt')
  end
end

class GraderHashyTest < Minitest::Test
  include GraderHashy
  def test_it_works
    assert_equal 'ABDCAACB',  GraderHashy.cheat('test/input_1.txt')
  end

  def test_long_file
    assert_equal 'BACBCAAACBCAAABDABBBBDBCBDAABDADDACBAACADDBAABABCB',
                 GraderHashy.cheat('test/input_2.txt')
  end
end

