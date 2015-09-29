require 'minitest/autorun'
require './battleship.rb'

class ShipTest < Minitest::Test
  def setup
    @p = Player.new 1000
    @ac, @bt, @sm, @ds, @pb = InfBatShit::FLEET.map {|s, z| Ship.new(s.to_sym, z, @p)}
  end

  def test_shipwright
    assert_equal [5, 4, 3, 3, 2], [@ac, @bt, @sm, @ds, @pb].map(&:size)
    assert_equal InfBatShit::FLEET.keys.map(&:to_s), [@ac, @bt, @sm, @ds, @pb].map(&:name)
  end

  def test_positioning_horizontally
    @pb.horizontally_from(100, 77)
    assert_equal [[100, 77], [101, 77]], @p.afloat
  end

  def test_positioning_vertically
    @pb.vertically_from(100, 77)
    assert_equal [[100, 77], [100, 78] ], @p.afloat
  end

  def test_dont_anchor_if_already_occupying_space
    @ac.horizontally_from(100, 100)
    @sm.vertically_from(100, 100)
    assert_equal 5, @p.afloat.count
  end

  def test_dont_anchor_if_collision
    @ac.horizontally_from(100, 100)
    @sm.vertically_from(103, 98)
    assert_equal 5, @p.afloat.count
  end

  def test_anchor_circling_the_wagons_is_ok
    @ac.horizontally_from(0, 0)
    @bt.vertically_from(0, 1)
    @sm.horizontally_from(1, 2)
    @ds.vertically_from(4, 1)
    @pb.horizontally_from(1, 1)
    assert_equal 5+4+3+3+2, [@ac, @bt, @sm, @ds, @pb].map(&:size).reduce(&:+)
  end

  def test_volumetrically_for_collisions
    100.times do
      [@ac, @bt, @sm, @ds, @pb].sample(2).each do |boat|
        boat.horizontally_from(rand(10), rand(10)) ||
          boat.vertically_from(rand(10), rand(10))
      end
    end
    assert @p.afloat.count == @p.afloat.uniq.count
  end
end

