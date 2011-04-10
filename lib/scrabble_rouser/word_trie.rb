# encoding: UTF-8

module ScrabbleRouser

  # This class is used for fast dictionary lookups. It
  # implements a {trie}[http://en.wikipedia.org/wiki/Trie],
  # an m-ary tree where each path to a leaf node represents
  # a valid word in the dictionary. Some inner nodes may of
  # course be words, too.

  class WordTrie

    include Enumerable

    # The number of unique words in the WordTrie.
    attr_reader :size

    # Expects an Enumerator which will yield all words to
    # be added to this WordTrie. The words themselves must
    # be Strings.
    def initialize(words)
      raise ArgumentError, 'Enumerator required' unless words.respond_to? :each
      @size = 0
      @root = Node.new

      words.each do |word|
        word_was_new = add word

        @size += 1 if word_was_new
      end
    end

    # Iterates over every word in this WordTrie.
    def each(&block)
      if block_given?
        walk_and_call @root, '', block
      else
        Enumerator.new self
      end
    end

    # Returns true if this WordTrie contains word, false
    # otherwise.
    def include?(word)
      return false unless word.is_a? String

      lowest, suffix = find_lowest_node_for word
      suffix.empty? && lowest.valid
    end

    # Returns all valid letters which produce words when
    # inserted between the provided prefix and suffix (the
    # first and last letters of constraints, respectively).
    def valid_letters(constraints)
      prefix, suffix = *constraints

      start, rest = find_lowest_node_for prefix

      if rest.empty?
        start.children.select do |char, child|
          leaf, rest = find_lowest_node_for suffix, child
          rest.empty? && leaf.valid
        end.keys.map(&:chr)
      else
        []
      end
    end

    private

      # Adds a word to this WordTrie. Returns true if the
      # word was entirely new, false otherwise.
      def add(word)
        raise ArgumentError, 'String required' unless word.is_a? String

        lowest, suffix = find_lowest_node_for word
        # old words should exhaust the input and already be
        # marked valid
        was_new_word = !(lowest.valid && suffix.empty?)

        lowest.add_suffix suffix

        was_new_word
      end

      # Finds the lowest existing node matching a prefix of
      # word, returning that node along with the unmatched
      # suffix. If the word is valid, the node will say so
      # and the suffix will be empty. Starts at the root
      # node unless otherwise specified.
      def find_lowest_node_for(word, start=@root)
        word = word.downcase.strip

        curr = start
        missing = word.bytes.find_index {|c| (curr = curr[c] if curr[c]).nil? } || word.length

        [curr, word[missing, word.length]]
      end

      # Helper method for iteration through recursion.
      def walk_and_call(node, prefix, block)
        block.call prefix if node.valid

        node.children.each do |char, child|
          walk_and_call(child, prefix + char.chr, block)
        end
      end

      # Interior class for building our WordTrie. Exposes
      # methods for reading children, the character
      # represented by the node, and whether the node is
      # terminal (the path to this node is a valid word).
      class Node

        # The character stored at this node.
        attr_reader :char

        # A hash from characters to children.
        attr_reader :children

        # Whether this node marks a valid word.
        attr_reader :valid

        # Initialize a new node with character char.
        def initialize(char = 0)
          @char = char
          @children = Hash.new
          @valid = false
        end

        # Returns the child at char, or nil if no such
        # child exists.
        def [](char)
          self.children[char]
        end

        # Adds a child at char and returns it. Does not
        # overwrite existing children.
        def add_child(char)
          @children[char] ||= Node.new(char)
        end

        # Adds an entire suffix starting at this node.
        # This entails creating descendants of this node
        # until the suffix is exhausted. Marks the final
        # node as valid by default.
        def add_suffix(suffix, is_valid=true)
          curr = self
          suffix.each_byte {|char| curr = curr.add_child(char)}
          curr.valid = is_valid
        end

        protected
          # Assigns the valid status of a node.
          def valid=(valid)
            @valid = valid
          end
      end
  end
end
