class Node
  attr_reader :children, :char, :selections
  attr_accessor :is_word

  def initialize(char)
    @char = char.to_sym
    @is_word = false
    @children = {}
    @selections = Hash.new(0)
  end

  def insert(child)
    if @children[child.to_sym].nil?
      @children[child.to_sym] = Node.new(child)
    else
      @children[child.to_sym].insert(child)
    end
  end

  def select(word)
    @selections[word] += 1
  end
end
