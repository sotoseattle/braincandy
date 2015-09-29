class InfBatShit
  FLEET = { Aircraft: 5, Battleship: 4, Submarine: 3, Destroyer: 3, PatrolBoat: 2 }

  attr_accessor :skynet, :player

  def initialize side = 100
    @skynet = Player.new side
    @player = Player.new side
  end

  def start!
    @skynet.drop_anchor
    while @skynet.afloat.size > 0 do
      puts "Enter target: "
      command = get_input
      return 'adios' if command == 'exit'
      puts @skynet.fire(command.match(/(\d+)\,\s*(\d+)/).captures)
    end
    'GAME OVER'
  end

  def get_input
    gets.chomp
  end
end

class Player
  attr_accessor :grid, :side

  def initialize side = 100
    @side = side
    @grid = {}
  end

  def afloat
    @grid.values.flatten(1)
  end

  def add_to_grid(coords, ship_type)
    if inside_bounds?(coords) && no_collisions?(coords)
      @grid[ship_type] = coords
    else
      false
    end
  end

  def drop_anchor fleet = InfBatShit::FLEET
    fleet.map { |s, z| Ship.new(s.to_sym, z, self) }.each do |boat|
      until boat.send(*random_placement) do
      end
    end
  end

  def fire coord
    coord.map! &:to_i
    ship, set = @grid.select { |ship, set| set.include? coord }.first
    if ship
      @grid[ship] = (set -= [coord])
      (set.empty? ? "Sunk" : "Hit") + " my #{ship}\n"
    else
      "Splash"
    end
  end

  private

  def inside_bounds? coords
    a, b = coords.transpose
    a.max < @side && b.max < @side
  end

  def no_collisions? coords
    (afloat & coords).empty?
  end

  def random_placement
    [[:horizontally_from, :vertically_from].sample, rand(@side), rand(@side)]
  end
end

class Ship
  attr_reader :name, :size, :grid

  def initialize type, size, player
    @name = type.to_s
    @size = size
    @player = player
  end

  def horizontally_from(x, y)
    @player.add_to_grid((0...@size).map {|i| [x+i, y] }, @name)
  end

  def vertically_from(x, y)
    @player.add_to_grid((0...@size).map {|i| [x, y+i] }, @name)
  end
end

# InfBatShit.new(10).start!
