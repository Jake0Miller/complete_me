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
    word.each do |char|
      cur_node = cur_node.children[char]
    end
    cur_node
  end

  def suggest(prefix)
    stack = [find_word(prefix)]
    prefix_stack = [prefix.chars[0..-2]]
    words = []

    return [] if stack.empty?
    words = find_all_words(stack, prefix_stack, words)

    if find_word(prefix).selections.values.all? { |value| value == 0 }
      return words
    end
    sort_words(prefix, words)
  end

  def sort_words(prefix, words)
    selections = find_word(prefix).selections
    words.sort do |a, b|
      selections[a] <=> selections[b]
    end.reverse
  end

  def find_all_words(stack, prefix_stack, words)
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
    words
  end

  def populate(dict)
    dict.each{ |line| insert(line.chop) }
  end

  def select(prefix, word)
    find_word(prefix).select(word)
  end

  def delete(word)
    chars = word.chars.map { |char| char.to_sym }
    cur_node = @root
    node_stack = []
    target = find_word(word)

    chars.each do |char|
      cur_node.selections.delete(word)
      if cur_node.children[char] == target
        cur_node.children.delete(char.to_sym)
        @count -= 1
        break
      else
        cur_node = cur_node.children[char]
      end
      node_stack.push(cur_node)
    end

    cur_node = node_stack.pop
    until node_stack.empty?
      if cur_node.children.length == 0 && !cur_node.is_word
        next_node = node_stack.pop
        next_node.children.delete(cur_node.char)
        cur_node = next_node
      else
        cur_node = node_stack.pop
      end
    end
  end
end
