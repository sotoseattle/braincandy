class InfBatShit
  FLEET = { 'Aircraft'  => 5, 'Battleship' => 4, 'Submarine' => 3,
            'Destroyer' => 3, 'PatrolBoat' => 2 }

  attr_accessor :grid, :side

  def initialize(side = 10)
    @side = side
    @grid = {}
  end

  def start!
    drop_anchor
    while afloat.size > 0 do
      puts "Enter target: "
      case get_input
      when 'exit' then return 'adios'
      when /(\d+)\,\s*(\d+)/ then puts fire([$1, $2])
      end
    end
    'GAME OVER'
  end

  def get_input
    gets.chomp
  end

  def afloat
    @grid.values.flatten(1)
  end

  def add_to_grid(boat)
    coords = boat.random_placement_at(rand(@side), rand(@side))
    valid?(coords) ? @grid[boat.name] = coords : false
  end

  def drop_anchor(fleet = InfBatShit::FLEET)
    fleet.map do |s, z|
      boat = Ship.new(s, z)
      redo unless add_to_grid(boat)
    end
  end

  def fire(coord)
    coord.map! &:to_i
    ship, set = @grid.select { |ship, set| set.include? coord }.first
    if ship
      @grid[ship] = (set -= [coord])
      (set.empty? ? "Sunk" : "Hit") + " my #{ship}\n"
    else
      "Splash"
    end
  end

  def valid?(coords)
    a, b = coords.transpose
    a.max < @side && b.max < @side && (afloat & coords).empty?
  end
end

Ship = Struct.new(:name, :size) do
  def random_placement_at(x, y)
    send([:horizontally, :vertically].sample, x, y)
  end

  def horizontally(x, y)
    (0...size).map {|i| [x+i, y] }
  end

  def vertically(x, y)
    (0...size).map {|i| [x, y+i] }
  end
end
