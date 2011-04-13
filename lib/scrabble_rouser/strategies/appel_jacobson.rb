# encoding: UTF-8

module ScrabbleRouser

  # This module contains all strategies available for
  # playing Scrabble.

  module Strategies

    # This class implements <em>The World's Fastest Scrabble
    # Program</em> (well, as of 1988 anyways), from the
    # paper bearing the same name by Andrew W. Appel and
    # Guy J. Jacobson.
    #
    # The algorithm has some places where statefulness can
    # allow optimizations; instances of this class
    # encapsulate that state.

    class AppelJacobson
      # The board to be solved.
      attr_reader :board

      # Initialize a new solver using the specified board
      # and word set.
      def initialize(board, word_set)
        @board = board
        @words = word_set
        @anchors = []
      end

      # Generates and stores the _cross-checks_ for the
      # board being solved. See §3.1.1 in the paper.
      def calculate_cross_checks
        checks = {}

        [:rows, :cols].each do |sym|
          checks[sym] = []

          @board.send(sym).each_with_index do |line, num|
            line_checks = Array.new(line.size, [])

            prev_word, curr_word = nil, ''
            prev_type = nil
            prev_before_anchor = prev_after_anchor = nil

            (line + [0]).each_with_index do |c, idx|
              char_type = type c

              case char_type
              when :blank
                if prev_type == :filled # just finished finding a word
                  if prev_before_anchor
                    prefix = (prev_before_anchor == prev_after_anchor)? prev_word : ''

                    line_checks[prev_before_anchor] = @words.valid_letters [prefix, curr_word]
                    prev_before_anchor = nil
                  end

                  prev_word = curr_word
                  curr_word = ''

                  prev_after_anchor = idx
                elsif prev_after_anchor # need to process last after anchor
                  line_checks[prev_after_anchor] =
                    @words.valid_letters [prev_word, '']
                  prev_after_anchor = nil
                end
              when :filled
                if prev_type == :blank

                  prev_before_anchor = idx - 1
                end
                curr_word += c.chr
              else
                raise 'WTF'
              end

              prev_type = char_type
            end
          end
        end
      end

      # Returns the classification of the specified
      # character, currently one of:
      # [+:blank+]  the character represents a completely
      #             blank square, open for play but with
      #             no associated multipliers
      # [+:filled+] the character represents a filled
      #             square, no longer eligible for future
      #             plays
      def type(c)
        case c
        when 65..90, 97..122 then :filled
        else :blank
        end
      end
    end
  end
end
