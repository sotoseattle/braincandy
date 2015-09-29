require 'minitest/autorun'
require './battleship.rb'

class InfBatShitTest < Minitest::Test
  def setup
    @player = Player.new(10)
  end

  def test_create_new_game_resets_canvas_for_2_players
    assert_empty @player.grid
    assert_equal 10, @player.side
  end

  def test_populates_all_AI_ships
    n_filled = InfBatShit::FLEET.values.reduce(&:+)
    1_000.times do
      skynet =  Player.new(10)
      skynet.drop_anchor
      assert_equal n_filled, skynet.afloat.count
    end
  end

  def test_splash
    @player.grid = {Something: [[0,0]] }
    target = [rand(9)+1, rand(9)+1]
    assert_equal "Splash", @player.fire(target)
  end

  def test_hit_and_sunk
    @player.drop_anchor
    target_1, target_2 = @player.grid["PatrolBoat"]
    assert_equal "Hit my PatrolBoat\n", @player.fire(target_1)
    assert_equal "Sunk my PatrolBoat\n", @player.fire(target_2)
  end


end
