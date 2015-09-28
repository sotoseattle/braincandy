class InfBatShit
  attr_reader :skynet, :player
  def initialize side = 100
    @skynet = Player.new side
    @player = Player.new side
  end

  def start!
    @skynet.hide_the_fleet
    # go_on = true
    # while go_on do
    #   instruction = get_input
    #   go_on = false if instruction == 'exit'
    # end
    self
  end

  def get_input
    gets.chomp
  end

end

class Player
  attr_reader :grid, :fleet
  def initialize side
    @grid = Grid.new side
    @fleet = []
  end

  def random_placement
    [[:horizontally_from, :vertically_from].sample, rand(@grid.side), rand(@grid.side)]
  end

  def hide_the_fleet formation = %w(Aircraft Battleship Submarine Destroyer PatrolBoat)
    @fleet = formation.map { |name| Ship.new(name.to_sym, @grid) }
    @fleet.each do |boat|
      until boat.send(*random_placement) do
      end
    end
  end
end

class Grid
  attr_reader :side, :fill
  def initialize side
    @side = side
    @fill = []
  end

  def add coords
    @fill += coords
  end

  def inside? coords
    a, b = coords.transpose
    a.max < @side && b.max < @side
  end

  def to_s
    (0...side).map do |y|
      (0...side).map do |x|
        @fill.include?([x,y]) ? "X|" : " |"
      end.join << "\n"
    end.reverse.join
  end
end

class Ship
  FLEET = { Aircraft:   5,
            Battleship: 4,
            Submarine:  3,
            Destroyer:  3,
            PatrolBoat: 2 }

  attr_reader :name, :size, :grid

  def initialize type, grid
    @name = type.to_s
    @size = FLEET[type]
    @grid = grid
  end

  def add(coordinates)
    if @grid.inside?(coordinates) && (@grid.fill & coordinates).empty?
      @grid.add(coordinates)
    else
      false
    end
  end

  def horizontally_from(x, y)
    add (0...@size).map {|i| [x+i, y] }
  end

  def vertically_from(x, y)
    add (0...@size).map {|i| [x, y+i] }
  end
end

# InfBatShit.new.start!
