require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require './lib/node'
require 'pry'

class CompleteMeTest < Minitest::Test
  def setup
    @completion = CompleteMe.new
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

  def test_find_word
    @completion.insert("pizza")

    assert_equal :a, @completion.find_word("pizza").char
    assert_empty @completion.find_word("pizza").children
  end

  def test_suggest
    @completion.insert("pizza")

    assert_equal ["pizza"], @completion.suggest("piz")
  end

  def test_delete_node
    @completion.insert("pizza")
    @completion.insert("pie")
    @completion.delete("pizza")

    assert_equal ["pie"], @completion.suggest("pi")
    assert_equal 1, @completion.count
    assert_equal 1, @completion.find_word("pi").children.length
  end
end
