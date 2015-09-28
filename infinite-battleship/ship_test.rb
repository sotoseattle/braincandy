require 'minitest/autorun'
require './battleship.rb'

class ShipTest < Minitest::Test
  def setup
    @g = Grid.new
    @fleet = %w(Aircraft Battleship Submarine Destroyer PatrolBoat)
    @ac, @bt, @sm, @ds, @pb = @fleet.map {|name| Ship.new(name.to_sym, @g)}
  end

  def test_shipwright
    assert_equal [5, 4, 3, 3, 2],
      [@ac, @bt, @sm, @ds, @pb].map(&:size)
    assert_equal %w(Aircraft Battleship Submarine Destroyer PatrolBoat),
      [@ac, @bt, @sm, @ds, @pb].map(&:name)
  end

  def test_positioning_horizontally
    @pb.anchor_horizontally_starting_at(100, 77)
    assert_equal [[100, 77], [101, 77]], @g.fill
  end

  def test_positioning_vertically
    @pb.anchor_vertically_starting_at(100, 77)
    assert_equal [[100, 77], [100, 78] ], @g.fill
  end

  def test_dont_anchor_if_already_occupying_space
    @ac.anchor_horizontally_starting_at(100, 100)
    @sm.anchor_vertically_starting_at(100, 100)
    assert_equal 5, @g.fill.count
  end

  def test_dont_anchor_if_collision
    @ac.anchor_horizontally_starting_at(100, 100)
    @sm.anchor_vertically_starting_at(103, 98)
    assert_equal 5, @g.fill.count
  end

  def test_anchor_circling_the_wagons_is_ok
    @ac.anchor_horizontally_starting_at(0, 0)
    @bt.anchor_vertically_starting_at(0, 1)
    @sm.anchor_horizontally_starting_at(1, 2)
    @ds.anchor_vertically_starting_at(4, 1)
    @pb.anchor_horizontally_starting_at(1, 1)
    assert_equal 5+4+3+3+2, [@ac, @bt, @sm, @ds, @pb].map(&:size).reduce(&:+)
  end

  def test_volumetrically_for_collisions
    100.times do
      [@ac, @bt, @sm, @ds, @pb].sample(2).each do |boat|
        boat.anchor_horizontally_starting_at(rand(10), rand(10)) ||
          boat.anchor_vertically_starting_at(rand(10), rand(10))
      end
    end
    assert @g.fill.count == @g.fill.uniq.count
  end
end

