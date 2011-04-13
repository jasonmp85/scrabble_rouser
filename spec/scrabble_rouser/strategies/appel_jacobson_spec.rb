# encoding: UTF-8

require 'spec_helper'

module ScrabbleRouser::Strategies
  describe AppelJacobson do
    context 'with a valid board' do
      board = ScrabbleRouser::Board.new(
        [
          '+-----+',
          '|GaM  |',
          '| RAM |',
          '|  NOD|',
          '|ID PO|',
          '|    G|',
          '+-----+'
        ]
      )


      it 'should be able to calculate cross-checks' do
        trie = double()
        trie.should_receive(:valid_letters).with(['GaM', ''])  { [] }
        trie.should_receive(:valid_letters).with(['', 'RAM'])  { [] }
        trie.should_receive(:valid_letters).with(['RAM', ''])  { [] }
        trie.should_receive(:valid_letters).with(['', 'NOD'])  { [] }
        trie.should_receive(:valid_letters).with(['ID', 'PO']) { [] }
        trie.should_receive(:valid_letters).with(['', 'G'])    { [] }

        trie.should_receive(:valid_letters).with(['G', ''])    { [] }
        trie.should_receive(:valid_letters).with(['', 'I'])    { [] }
        trie.should_receive(:valid_letters).with(['I', ''])    { [] }
        trie.should_receive(:valid_letters).with(['aR', 'D'])  { [] }
        trie.should_receive(:valid_letters).with(['D', ''])    { [] }
        trie.should_receive(:valid_letters).with(['MAN', ''])  { [] }
        trie.should_receive(:valid_letters).with(['', 'MOP'])  { [] }
        trie.should_receive(:valid_letters).with(['MOP', ''])  { [] }
        trie.should_receive(:valid_letters).with(['', 'DOG'])  { [] }

        strategy = AppelJacobson.new(board, trie)
        strategy.calculate_cross_checks
      end
    end
  end
end
