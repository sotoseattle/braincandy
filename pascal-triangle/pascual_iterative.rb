require 'minitest/autorun'

## Gimme back the nth_level of a Pascual Triangle (laundromat style)
#
def pascual(n_levels)
  arr = [1]
  n_levels.times { arr = regurgitate(arr) }
  arr
end

## Given a level of the Pascual Triangle, return the one below
#
def regurgitate arr
  [arr.first,
   *arr.each_cons(2).map {|x, y| x + y},
   arr.last]
end


class TestPascualino < Minitest::Test
  def test_regurgitations
    assert_equal [1,2,1], regurgitate([1,1])
    assert_equal [1,3,3,1], regurgitate([1,2,1])
    assert_equal [1,4,6,4,1], regurgitate([1,3,3,1])
  end

  def test_pascualino_cero
    assert_equal [1], pascual(0)
  end

  def test_pascualino_uno
    assert_equal [1,1], pascual(1)
  end

  def test_pascualino_plus_one
    assert_equal [1,4,6,4,1], pascual(4)
  end
end
