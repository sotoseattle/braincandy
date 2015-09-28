require 'minitest/autorun'
require './battleship.rb'

class InfBatShitTest < Minitest::Test
  def setup
    @game =  InfBatShit.new
  end

  def test_create_new_game_resets_canvas_for_2_players
    assert_empty @game.skynet.grid.fill
    assert_empty @game.skynet.grid.fill
    assert_empty @game.player.fleet
    assert_empty @game.player.fleet
  end

  def test_start_new_game_populates_all_AI_ships
    1_000.times do
      game =  InfBatShit.new(10).start!
      assert_equal Ship::FLEET.values.reduce(&:+), game.skynet.grid.fill.count
      # puts game.skynet.grid
      # puts "-------\n"
    end
  end


end
