require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require './lib/node'
require 'pry'

class DictTest < Minitest::Test
  def setup
    @completion = CompleteMe.new
    @dictionary = File.readlines("/usr/share/dict/words")
    @completion.populate(@dictionary)
  end

  def test_populate
    results = ["pizzle", "pizzicato", "pizzeria", "pizza", "pize"]

    assert_equal 235886, @completion.count
    assert_equal results, @completion.suggest("piz")
  end

  def test_select
    assert_equal 0, @completion.find_word("piz").selections["pizzeria"]

    @completion.select("piz", "pizzeria")

    assert_equal 1, @completion.find_word("piz").selections["pizzeria"]

    @completion.select("pi", "pizza")
    @completion.select("pi", "pizza")
    @completion.select("pi", "pizzicato")

    expected = ["pizzeria", "pize", "pizza", "pizzicato", "pizzle"]
    assert_equal expected, @completion.suggest("piz")
    expected = ["pizza", "pizzicato"]
    assert_equal expected, @completion.suggest("pi")[0..1]
  end

  def test_delete_node
    @completion.select("pi", "pizza")
    @completion.select("pi", "pizza")
    @completion.select("pi", "pizzicato")
    @completion.delete("pizza")

    assert_equal 235885, @completion.count
    assert_equal "pizzicato", @completion.suggest("pi")[0]
    assert_equal false, @completion.include?("pizza")
    assert_nil @completion.find_word("pizza")
    assert_nil @completion.find_word("pizz").children[:a]
  end
end
