# encoding: UTF-8

require 'spec_helper'

module ScrabbleRouser
  describe Board do
    describe '#initialize' do
      context 'passed a non-Enumerator' do
        it 'should raise an error' do
          expect {Board.new 123 }.
            to raise_error ArgumentError
        end
      end

      context 'passed an empty Enumerator' do
        it 'should raise an error' do
          expect {Board.new []}.
            to raise_error ArgumentError
        end
      end

      context 'passed an Enumerator with the wrong type of objects' do
        it 'should raise an error' do
          expect {Board.new [1, 2, 3]}.
            to raise_error ArgumentError
        end
      end

      context 'with a simple empty single-spaced board' do
        input = [
          '+-----+',
          '|     |',
          '|     |',
          '|  *  |',
          '|     |',
          '|     |',
          '+-----+'
        ]

        it 'should have the right width and height' do
          board = Board.new input
          board.width.should eq 5
          board.height.should eq 5
        end
      end

      context 'with a simple empty double-spaced board' do
        input = [
          'D---------D',
          '|         |',
          '|         |',
          '|    *    |',
          '|         |',
          '|         |',
          'D---------D'
        ]

        it 'should have the right width and height' do
          board = Board.new input
          board.width.should eq 5
          board.height.should eq 5
        end
      end
    end

    context 'a simple board' do
      input = [
        '+---+',
        '|DOG|',
        '|@bE|',
        '|HIM|',
        '+---+'
      ]
      board = Board.new input

      it 'should return the correct rows' do
        rows = board.rows
        rows.should have(3).items
        rows.should include %w[D O G].map {|c| c.to_b}
        rows.should include %w[@ b E].map {|c| c.to_b}
        rows.should include %w[H I M].map {|c| c.to_b}
      end

      it 'should return the correct columns' do
        cols = board.cols
        cols.should have(3).items
        cols.should include %w[D @ H].map {|c| c.to_b}
        cols.should include %w[O b I].map {|c| c.to_b}
        cols.should include %w[G E M].map {|c| c.to_b}
      end
    end

    context 'a complex board' do
      input = [
        'D-----------------------------D',
        '|      #     3   3     #      |',
        '|    2     @       @     2    |',
        '|  2     2           2     2  |',
        '|#     3       G       3     #|',
        '|    2       P U T       2 S  |',
        '|  @       F   I   N       H  |',
        '|3       2 O   D   A 2     R 3|',
        '|      @   C H E A T   E W E  |',
        '|3       2 I     G A Y   O D 3|',
        '|  @       3       L E E R S  |',
        '|    2       2   2       K    |',
        '|#     3       @       3     #|',
        '|  2     2           2     2  |',
        '|    2     @       @     2    |',
        '|      #     3   3     #      |',
        'D-----------------------------D'
      ]
      board = Board.new input

      it 'should display correctly' do
        puts board
      end
    end
  end
end
