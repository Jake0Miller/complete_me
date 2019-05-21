require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'

class NodeTest < Minitest::Test
  def setup
    @root_node = Node.new(:c)
    @a = Node.new(:a)
    @r = Node.new(:r)
    @t = Node.new(:t)
  end

  def test_it_exists
    assert_instance_of Node, @root_node
    assert_equal Hash.new, @root_node.children
  end

  def test_insert
    @root_node.insert(@a)

    expected = {:a => @a}
    assert_equal expected, @root_node.children
  end

  def test_select
    assert_equal 0, @a.selections["apple"]

    @a.select("apple")

    assert_equal 1, @a.selections["apple"]
  end
end
