require 'minitest/autorun'
require './battleship.rb'

class InfBatShitTest < Minitest::Test

  def test_game_quits_when_prompted
    game =  InfBatShit.new(10)
    game.stub(:get_input, "exit") do
      assert_equal 'adios', game.start!
    end
  end

  def test_is_over_when_nothing_floats
    game =  InfBatShit.new(10)
    game.skynet.stub(:drop_anchor, nil) do
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

end
