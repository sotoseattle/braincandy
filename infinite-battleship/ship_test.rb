require 'minitest/autorun'
require './battleship.rb'

class ShipTest < Minitest::Test
  def setup
    @ac, @bt, @sm, @ds, @pb = InfBatShit::FLEET.map {|s, z| Ship.new(s, z)}
  end

  def test_shipwright
    assert_equal [5, 4, 3, 3, 2], [@ac, @bt, @sm, @ds, @pb].map(&:size)
    assert_equal InfBatShit::FLEET.keys, [@ac, @bt, @sm, @ds, @pb].map(&:name)
  end

  def test_positioning_horizontally
    assert_equal [[100, 77], [101, 77]], @pb.horizontally(100, 77)
  end

  def test_positioning_vertically
    assert_equal [[100, 77], [100, 78] ], @pb.vertically(100, 77)
  end
end
