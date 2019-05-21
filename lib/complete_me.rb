class CompleteMe
  attr_reader :count, :root

  def initialize
    @count = 0
    @root = Node.new(:*)
  end

  def insert(word)
    @count += 1 if !include?(word)
    word = word.chars.map { |char| char.to_sym }
    cur_node = @root
    word.each do |char|
      cur_node = add_char(char, cur_node.children)
    end
    cur_node.is_word = true
  end

  def add_char(char, nodes)
    nodes[char] || nodes[char] = Node.new(char)
  end

  def include?(word)
    word = word.chars.map { |char| char.to_sym }
    cur_node = @root
    word_found = word.all? do |char|
      cur_node = cur_node.children[char]
    end
    word_found && cur_node.is_word
  end

  def find_word(word)
    word = word.chars.map { |char| char.to_sym }
    cur_node = @root
    word_found = word.all? do |char|
      cur_node = cur_node.children[char]
    end
    cur_node
  end

  def suggest(prefix)
    stack = [find_word(prefix)]
    prefix_stack = [prefix.chars[0..-2]]
    words = []

    return [] if stack.empty?

    until stack.empty?
      cur_node = stack.pop
      if cur_node == :blocker
        prefix_stack.pop
      else
        prefix_stack << cur_node.char
        stack << :blocker
        words << prefix_stack.join if cur_node.is_word

        cur_node.children.values.each { |n| stack << n }
      end
    end
    # selections = find_word(prefix).selections
    # words.sort do |a, b|
    #
    # end.reverse
  end

  def populate(dict)
    dict.each{ |line| insert(line.chop) }
  end

  def select(prefix, word)
    find_word(prefix).select(word)
  end
end
