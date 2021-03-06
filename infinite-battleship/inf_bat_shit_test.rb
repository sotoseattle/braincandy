require 'minitest/autorun'
require './battleship.rb'

class InfBatShitTest < Minitest::Test
  def setup
    @game = InfBatShit.new(10)
  end

  def test_game_quits_when_prompted
    game =  InfBatShit.new(10)
    game.stub(:get_input, "exit") do
      assert_equal 'adios', game.start!
    end
  end

  def test_is_over_when_nothing_floats
    game =  InfBatShit.new(10)
    game.stub(:drop_anchor, nil) do
      assert_equal 'GAME OVER', game.start!
    end
  end

  def test_a_whole_game
    @@chucho = ([*0...10].permutation(2).to_a +
                [*0...10].zip([*0...10])).map!{|a| a.join(', ')}
    game =  InfBatShit.new(10)
    def game.get_input; @@chucho.shift.to_s; end
    assert_equal 'GAME OVER', game.start!
  end

  def test_create_new_game_resets_canvas_for_2_players
    assert_empty @game.grid
    assert_equal 10, @game.side
  end

  def test_populates_all_AI_ships
    n_filled = InfBatShit::FLEET.values.reduce(&:+)
    1_000.times do
      skynet =  InfBatShit.new(10)
      skynet.drop_anchor
      assert_equal n_filled, skynet.afloat.count
    end
  end

  def test_splash
    @game.grid = {Something: [[0,0]] }
    target = [rand(9)+1, rand(9)+1]
    assert_equal "Splash", @game.fire(target)
  end

  def test_hit_and_sunk
    @game.drop_anchor
    target_1, target_2 = @game.grid["PatrolBoat"]
    assert_equal "Hit my PatrolBoat\n", @game.fire(target_1)
    assert_equal "Sunk my PatrolBoat\n", @game.fire(target_2)
  end

end
