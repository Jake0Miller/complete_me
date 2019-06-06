require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require 'pry'

class NodeTest < Minitest::Test
  def setup
    @root_node = Node.new(:c)
    @root_node.insert("a")
  end

  def test_it_exists
    assert_instance_of Node, @root_node
    assert_equal Hash, @root_node.children.class
  end

  def test_insert
    assert_equal :a, @root_node.children[:a].char
  end

  def test_select
    assert_equal 0, @root_node.children[:a].selections["apple"]

    @root_node.children[:a].select("apple")

    assert_equal 1, @root_node.children[:a].selections["apple"]
  end
end
