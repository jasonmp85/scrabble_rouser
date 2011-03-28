# encoding: UTF-8

# This module contains all the relevant classes in the
# scrabble_rouser gem.

require 'scrabble_rouser/version'

module ScrabbleRouser

  # Base class for errors raised by ScrabbleRouser code

  class RouserError < StandardError

    # Defines a class method named +status_code+ when
    # called. To be used by subclasses to define the code
    # to be returned in the event that an error makes it up
    # the stack completely uncaught.
    def self.status_code(code = nil)
      define_method(:status_code) { code }
    end
  end

  # Thrown when command-line options are invalid
  class InvalidOption < RouserError; status_code(2) ; end
end
