require 'minitest/autorun'

YAHTZEE         = 50
LARGE_STRAIGHT  = 40
SMALL_STRAIGHT  = 30
FULL_HOUSE      = 25
LARGE_REGEX     = /12345|23456/
SMALL_REGEX     = /1234|2345|3456/

def yahtzee roll
  numbers, groups = roll.group_by{|x|x}.sort.transpose

  special_score   = case numbers.count
                    when 5, 4
                      case numbers.join
                      when LARGE_REGEX then LARGE_STRAIGHT
                      when SMALL_REGEX then SMALL_STRAIGHT
                      end
                    when 2
                      FULL_HOUSE if groups.map(&:size).max == 3
                    when 1
                      YAHTZEE
                    end.to_i
  chance_score = roll.reduce(&:+)

  [special_score, chance_score].max
end

5.times do
  roll = Array.new(5) { rand(6) + 1 }
  puts "#{roll} => #{yahtzee(roll)}"
end

class Yahtzee < Minitest::Test
  def test_yahtzee
    assert_equal 50, yahtzee([2,2,2,2,2])
    assert_equal 50, yahtzee([3,3,3,3,3])
  end

  def test_large_straight
    assert_equal 40, yahtzee([2,3,4,5,6])
    assert_equal 40, yahtzee([1,2,3,4,5])
    refute_equal 40, yahtzee([1,2,3,4,4])
  end

  def test_small_straight
    assert_equal 30, yahtzee([1,2,3,3,4])
    assert_equal 30, yahtzee([1,2,3,4,6])
    assert_equal 30, yahtzee([2,3,4,5,5])
    assert_equal 30, yahtzee([1,3,4,5,6])
    refute_equal 30, yahtzee([1,2,3,5,6])
  end

  def test_full_house
    assert_equal 25, yahtzee([2,2,2,5,5])
    assert_equal 25, yahtzee([2,2,5,5,5])
  end

  def test_4_of_the_same
    assert_equal 13, yahtzee([2,2,2,2,5])
    assert_equal 22, yahtzee([2,5,5,5,5])
  end

  def test_3_of_the_same
    assert_equal 15, yahtzee([2,2,2,4,5])
    assert_equal 23, yahtzee([2,5,5,5,6])
  end

  def test_pairs
    assert_equal 16, yahtzee([1,1,2,6,6])
    assert_equal 14, yahtzee([1,2,2,4,5])
    assert_equal 21, yahtzee([2,3,5,5,6])
  end
end

