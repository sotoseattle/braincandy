require 'minitest/autorun'

class Grid
  attr_accessor :locations
  def initialize
    @locations = []
  end

  def push coord
    @locations << coord
  end
end

class Ship
  FLEET = { Aircraft:   5,
            Battleship: 4,
            Submarine:  3,
            Destroyer:  3,
            PatrolBoat: 2 }

  attr_accessor :size

  def initialize type, grid
    @name = type.to_s
    @size = FLEET[type]
    @grid = grid
  end

  def fix_position(x, y)
    coord = [x, y]
    @grid.push(coord) unless @grid.locations.include?(coord)
  end

  def anchor_horizontally_starting_at(x, y)
    (0...@size).all? {|i| fix_position(x+i, y) }
  end

  def anchor_vertically_starting_at(x, y)
    (0...@size).all? {|i| fix_position(x, y+i) }
  end

  def position
    @grid.locations
  end
end

class CanvasTest < Minitest::Test
  def setup
    @g = Grid.new
    @ac = Ship.new(:Aircraft, @g)
    @bt = Ship.new(:Battleship, @g)
    @sm = Ship.new(:Submarine, @g)
    @ds = Ship.new(:Destroyer, @g)
    @pb = Ship.new(:PatrolBoat, @g)
  end

  def test_shipwright
    assert_equal [5, 4, 3, 3, 2], [@ac, @bt, @sm, @ds, @pb].map(&:size)
  end

  def test_positioning_horizontally
    assert @pb.anchor_horizontally_starting_at(100, 77)
    assert_equal [[100, 77], [101, 77]], @pb.position
  end

  def test_positioning_vertically
    assert @pb.anchor_vertically_starting_at(100, 77)
    assert_equal [[100, 77], [100, 78] ], @pb.position
  end

  def test_dont_anchor_if_already_occupying_space
    @ac.anchor_horizontally_starting_at(100, 100)
    refute @pb.anchor_vertically_starting_at(100, 100)
  end

  def test_dont_anchor_if_collision
    @ac.anchor_horizontally_starting_at(100, 100)
    refute @sm.anchor_vertically_starting_at(103, 98)
  end

  def test_anchor_circling_the_wagons_is_ok
    assert @ac.anchor_horizontally_starting_at(0, 0)
    assert @bt.anchor_vertically_starting_at(0, 1)
    assert @sm.anchor_horizontally_starting_at(1, 2)
    assert @ds.anchor_vertically_starting_at(4, 1)
    assert @pb.anchor_horizontally_starting_at(1, 1)
  end

  def test_volumetrically_for_collisions
    100.times do
      [@ac, @bt, @sm, @ds, @pb].sample(2).each do |boat|
        boat.anchor_horizontally_starting_at(rand(10), rand(10)) ||
        boat.anchor_vertically_starting_at(rand(10), rand(10))
      end
    end
    assert @g.locations.size == @g.locations.uniq.size
  end

  def test_automatic_positioning_AI
    # [@ac, @bt, @sm, @ds, @pb]

  end



end

