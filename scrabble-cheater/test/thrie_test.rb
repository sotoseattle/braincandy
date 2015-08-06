require 'test_helper'

class ThrieTest < Minitest::Test
  def setup
    @ht = Thrie.new
    @hh = Thrie.new.add('camiseta')
                   .add('camioneta')
                   .add('camisa')
  end

  def test_inserts_car_as_key
    @ht.add('casa')
    assert @ht.keys.include? 'c'
  end

  def test_inserts_car_as_key_recurringly
    @ht.add('casa')
    assert @ht['c'].keys.include? 'a'
  end

  def test_inserts_car_as_key_recurringly
    @ht.add('casa')
    assert_equal '{"c"=>{"a"=>{"s"=>{"a"=>{"*"=>nil}}}}}', @ht.to_s
  end

  def test_inserts_words_in_paralell
    @ht.add('casa')
    @ht.add('nasa')
    assert @ht.keys.include? 'n'
    assert_equal '{"c"=>{"a"=>{"s"=>{"a"=>{"*"=>nil}}}}, "n"=>{"a"=>{"s"=>{"a"=>{"*"=>nil}}}}}', @ht.to_s
  end

  def test_inserts_words_in_tree_form_I
    @ht.add('casa')
    @ht.add('cama')
    assert_equal '{"c"=>{"a"=>{"s"=>{"a"=>{"*"=>nil}}, "m"=>{"a"=>{"*"=>nil}}}}}', @ht.to_s
  end

  def test_inserts_words_in_tree_form_II
    @ht.add('casa')
    @ht.add('caso')
    assert_equal '{"c"=>{"a"=>{"s"=>{"a"=>{"*"=>nil}, "o"=>{"*"=>nil}}}}}', @ht.to_s
  end

  def test_find_bs_word
    refute @hh.exist? 'camioneto'.chars
  end

  def test_find_bs_word
    refute @hh.exist? 'amioneta'.chars
    refute @hh.exist? 'cami'.chars
    refute @hh.exist? 'mi'.chars
  end

  def test_find_existing_word
    assert @hh.exist? 'camioneta'.chars
  end

  def test_find_existing_word
    assert @hh.exist? 'camisa'.chars
    assert @hh.exist? 'camiseta'.chars
  end
end

