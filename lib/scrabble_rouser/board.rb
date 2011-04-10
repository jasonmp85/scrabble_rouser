# encoding: UTF-8

module ScrabbleRouser

  # This class represents the starting state of a Scrabble
  # board and provides methods for manipulating this state
  # as well as methods for walking along the positions on
  # the board where a new move can be made.

  class Board
    attr_reader :width, :height

    # Initialize a new board using the provided lines.
    # Expects an Enumerator which will yield Strings.
    def initialize(lines)
      raise ArgumentError, 'Enumerator required' unless lines.respond_to? :each_with_index

      line_matcher = //
      last_char = '([A-Za-z23@# \*])'
      char_matcher = last_char

      @board = []

      lines.each_with_index do |line, index|
        raise ArgumentError unless String === line

        case index
        when 0
          @double, @width = parse_terminal_line(line, index + 1)
          char_matcher += ' ' if @double

          line_matcher = "#{char_matcher}" * (@width - 1) + "#{last_char}"
          line_matcher = /\A\|#{line_matcher}\|/
        else
          case line
          when line_matcher
            @board << Regexp.last_match[1,@width].map do |str|
              case str
              when ' '
                nil
              else
                str.bytes.first
              end
            end
          else
            unless [@double, @width] == parse_terminal_line(line, index + 1)
              raise ArgumentError, 'Expected footer line to match header'
            end

            break
          end
        end
      end

      raise ArgumentError, 'Blank board' unless (@height = @board.length).nonzero?
    end

    # Returns a 2-d array of the rows in this board.
    def rows
      @board
    end

    # Returns a 2-d array of the columns in this board.
    def cols
      @board.transpose
    end

    # Pretty-print the board.
    def to_s
      "\u250C" + "\u2500" * @width * 3 + "\u2510\n" +
      rows.map{|row| "\u2502" + row.map{|c| map_char c}.join + "\u2502"}.join("\n") +
      "\n\u2514" + "\u2500" * @width * 3 + "\u2518\n"
    end

    private
      # Used by the pretty printer.
      def map_char(c)
        if c
          " #{c.chr}\u20E3"
        else
          " \u25FC "
        end
      end

      # Parses the first and last lines of the file. If
      # they are not in the right format or if they do not
      # match each other, an Error will be raised.
      def parse_terminal_line(line, index)
        if /\A(?<mode>[D\+])(?<spacers>-+)\k<mode>/ =~ line
          double = mode == 'D'
          width = spacers.length
          width = (width + 1) / 2 if double
          [double, width]
        else
          raise ArgumentError, "Terminal line malformed; line: #{index}"
        end
      end
  end
end
