require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require './lib/node'
require 'pry'

class CompleteMeTest < Minitest::Test
  def setup
    @completion = CompleteMe.new
    @dictionary = File.readlines("/usr/share/dict/words")
  end

  def test_it_exists
    assert_instance_of CompleteMe, @completion
    assert_equal 0, @completion.count
  end

  def test_insert
    @completion.insert("pizza")

    assert_equal 1, @completion.count

    @completion.insert("pizza")

    assert_equal 1, @completion.count

    @completion.insert("pizzas")

    assert_equal 2, @completion.count
  end

  def test_include?
    @completion.insert("pizza")

    assert @completion.include?("pizza")
    refute @completion.include?("pizzazz")
    refute @completion.include?("pi")
  end

  def test_suggest
    @completion.insert("pizza")

    assert_equal ["pizza"], @completion.suggest("piz")
  end

  def test_populate
    @completion.populate(@dictionary)
    results = ["pizzle", "pizzicato", "pizzeria", "pizza", "pize"]

    assert_equal 235886, @completion.count
    assert_equal results, @completion.suggest("piz")
  end

  def test_select
    @completion.populate(@dictionary)

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
end
