require 'test_helper'

class ThrieTest < Minitest::Test
  def setup
    @ht = Thrie.new
  end

  def test_inserts_car_as_key
    @ht.feed('casa'.chars)
    assert @ht.keys.include? 'c'
  end

  def test_inserts_car_as_key_recurringly
    @ht.feed('casa'.chars)
    assert @ht['c'].keys.include? 'a'
  end

  def test_inserts_car_as_key_recurringly
    @ht.feed('casa'.chars)
    assert_equal '{"c"=>{"a"=>{"s"=>{"a"=>"*"}}}}', @ht.to_s
  end

  def test_inserts_words_in_paralell
    @ht.feed('casa'.chars)
    @ht.feed('nasa'.chars)
    assert @ht.keys.include? 'n'
    assert_equal '{"c"=>{"a"=>{"s"=>{"a"=>"*"}}}, "n"=>{"a"=>{"s"=>{"a"=>"*"}}}}', @ht.to_s
  end

  def test_inserts_words_in_tree_form_I
    @ht.feed('casa'.chars)
    @ht.feed('cama'.chars)
    assert_equal '{"c"=>{"a"=>{"s"=>{"a"=>"*"}, "m"=>{"a"=>"*"}}}}', @ht.to_s
  end

  def test_inserts_words_in_tree_form_II
    @ht.feed('casa'.chars)
    @ht.feed('caso'.chars)
    assert_equal '{"c"=>{"a"=>{"s"=>{"a"=>"*", "o"=>"*"}}}}', @ht.to_s
  end



end
