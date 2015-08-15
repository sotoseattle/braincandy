require 'test_helper'
require 'tempfile'

class GraderArrayTest < Minitest::Test
  include GraderArray
  def test_small_file
    assert_equal 'ABDCAACB', GraderArray.cheat('test/input_1.txt')
  end

  def test_long_file
    assert_equal 'BACBCAAACBCAAABDABBBBDBCBDAABDADDACBAACADDBAABABCB',
                 GraderArray.cheat('test/input_2.txt')
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

class GraderHemingwayTest < Minitest::Test
  include GraderHemingway
  def test_it_works
    assert_equal 'ABDCAACB',  GraderHemingway.generate_exam_key('test/input_1.txt')
  end

  def test_long_file
    assert_equal 'BACBCAAACBCAAABDABBBBDBCBDAABDADDACBAACADDBAABABCB',
                 GraderHemingway.generate_exam_key('test/input_2.txt')
  end
end

