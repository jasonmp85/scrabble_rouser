# encoding: UTF-8

require 'spec_helper'

module ScrabbleRouser
  describe WordTrie do
    describe '#initialize' do
      context 'passed a non-Enumerator' do
        it 'should raise an error' do
          expect {WordTrie.new 123 }.
            to raise_error ArgumentError
        end
      end

      context 'passed an empty Enumerator' do
        it 'should succeed and have zero size' do
          trie = WordTrie.new []
          trie.size.should be_zero
        end
      end

      context 'passed an Enumerator with the wrong type of objects' do
        it 'should raise an error' do
          expect {WordTrie.new [1, 2, 3]}.
            to raise_error ArgumentError
        end
      end
    end

    context 'with a list of words containing whitespaces' do
      words = "hello\r\n", "\r\ngoodbye"
      trie = WordTrie.new words

      describe '#include?' do
        it "should match words with trailing whitespace" do
          trie.should include 'hello'
        end

        it "should match words with leading whitespace" do
          trie.should include 'hello'
        end
      end
    end

    context 'with a list of words' do
      words = %w[today is the time for all good men to come to the aid of their country]
      trie = WordTrie.new words

      describe '#size' do
        it 'should have a size equal to the number of unique words added' do
          trie.should have(14).items
        end
      end

      describe '#include?' do
        it 'should include all words in the list' do
          trie.should include(*words)
        end

        it 'should not include words not in the list' do
          trie.should_not include 'cow'
        end

        it 'should match case insensitively' do
          trie.should include 'cOuNtrY'
        end

        it 'should not include non-strings' do
          trie.should_not include 5
        end
      end

      describe '#each?' do
        it 'should be able to enumerate its values' do
          check_enumeration trie, words
        end

        it 'should return an Enumerator if not passed a block' do
          check_enumeration trie.each, words
        end

        # Checks that enumerator has all items in words.
        def check_enumeration(enumerator, words)
          yielded_words = []
          enumerator.each {|word| yielded_words << word}

          yielded_words.should_not be_empty
          yielded_words.should have(14).items

          words.should include(*yielded_words)
        end
      end
    end

    context 'using a wordlist with many common prefixes and suffixes' do
      words = %w[cab cad caddy cane cob cod computer nab nib nob norb pad pod]
      trie = WordTrie.new words

      describe '#valid_letters' do
        it 'should calculate valid letters after a prefix' do
          letters = trie.valid_letters(['ca', ''])
          letters.should have(2).items
          letters.should include('b', 'd')
        end

        it 'should calculate valid letters before a suffix' do
          letters = trie.valid_letters(['', 'od'])
          letters.should have(2).items
          letters.should include('c', 'p')
        end

        it 'should calculate valid letters using both a prefix and suffix' do
          letters = trie.valid_letters(['n', 'b'])
          letters.should have(3).items
          letters.should include('a', 'i', 'o')
        end

        it 'should work with longer words' do
          trie.valid_letters(['com', 'uter']).should eq ['p']
        end

        it 'should return an empty set if nothing matches' do
          trie.valid_letters(['co', 'e']).should be_empty
        end
      end
    end

    context 'using the Enhanced North American Benchmark LExicon (ENABLE)' do
      words = []

      before :all do
        expect do
          Zlib::GzipReader.open('examples/dictionaries/enable.gz') do |gz|
            @trie = WordTrie.new(SamplingEnumerator.new gz, words, 0.1)
          end
        end.to take_less_than(4).seconds
      end

      describe '#include?' do
        it 'should run in under one second' do
          expect { @trie.should include(*words) }.to take_less_than(0.3).seconds
        end
      end

      # delegates to provided enumerator, sampling values to an array
      class SamplingEnumerator
        def initialize(delegate, array, rate=1.0)
          @r = Random.new(0)
          @array, @delegate, @rate = array, delegate, rate
        end

        def each
          @delegate.each {|val| @array << val if @r.rand < @rate; yield val }
        end
      end
    end
  end
end
