# encoding: UTF-8

require 'optparse'
require 'ostruct'

module ScrabbleRouser

  # This class encapsulates the functionality related to
  # the command-line mode of operation provided by the gem.
  # This includes option-parsing, input, output, logging,
  # colorization, and any other CLI-related features.

  class CLI
    class << self

      # Begins execution of the ScrabbleRouser CLI
      def run(args)
        begin
          parse args
        rescue OptionParser::ParseError => pe
          raise InvalidOption, pe.message
        end
      end

      private
        # Parses the command-line arguments, returning a
        # struct upon success
        def parse(args)
          options = OpenStruct.new

          # defaults
          options.strategy        = :appel_jacobson
          options.tiles_remaining = Float::INFINITY
          options.verbose         = false

          parser = OptionParser.new do |parser|
            parser.banner = 'Usage: scrabble_rouser [OPTIONS] RACK BOARDFILE'

            parser.separator 'Generate moves for BOARDFILE using letters in RACK.'
            parser.separator 'Example: scrabble_rouser -d words.txt ALNBOTE board.txt'

            parser.separator ''
            parser.separator 'Solver options:'

            parser.on('-d', '--dictionary FILENAME',
            'Use the dictionary in FILENAME') do |filename|
              options.dictionary = filename
            end

            parser.on('-s', '--strategy NAME', [:appel_jacobson],
                      'Use the strategy specified by NAME',
                      "(default #{options.strategy})") do |name|
              options.strategy = name
            end

            parser.on('-t', '--tiles-remaining NUM', Integer,
                      'Specify the number of tiles remaining',
                      "(default #{options.tiles_remaining})") do |num|
              options.tiles_remaining = num
            end

            parser.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
              options.verbose = v
            end

            parser.separator ''
            parser.separator 'Miscellaneous:'

            parser.on_tail('-h', '--help', 'Show this message') do
              puts parser
              exit
            end

            parser.on_tail('--version', 'Show version') do
              puts "scrabble_rouser #{ScrabbleRouser::VERSION}"
              exit
            end
          end

          parser.parse! args
        end
    end
  end
end
