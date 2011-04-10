# encoding: UTF-8

require 'spec_helper'

module ScrabbleRouser
  describe CLI do

    describe '#run' do
      context 'with a switch to print the version' do
        it 'should print the version to stdout and exit' do
          $stdout.should_receive(:puts).with(include VERSION)
          expect { CLI.run %w[--version] }.
            to raise_error SystemExit
        end
      end

      context 'with a switch to print the help screen' do
        it 'should print the help screen to stdout and exit' do
          $stdout.should_receive(:puts)
          expect { CLI.run %w[--help] }.
            to raise_error SystemExit
        end
      end

      context 'with valid long switches' do
        before :all do
          @args = %w[--dictionary /path/to/words.txt --strategy appel_jacobson
                     --tiles-remaining 10 --verbose VRMNRDE board.txt]
        end

        it 'run and destructively modify args' do
          CLI.run @args
          @args.should == %w[VRMNRDE board.txt]
        end
      end

      context 'with valid short switches' do
        it 'should run and destructively modify args' do
          args = %w[-d /path/to/words.txt -s appel_jacobson
                    -t 10 -v VRMNRDE board.txt]
          CLI.run args
          args.should == %w[VRMNRDE board.txt]
        end
      end

      context 'missing a required argument' do
        it 'should raise an InvalidOption error' do
          expect {CLI.run %w[-d]}.
            to raise_error InvalidOption
        end
      end

      context 'with an invalid argument' do
        it 'should raise an InvalidOption error' do
          expect { CLI.run %w[-t bad] }.
            to raise_error InvalidOption
        end
      end

      context 'with an invalid switch' do
        it 'should raise an InvalidOption error' do
          expect { CLI.run %w[--invalid] }.
            to raise_error InvalidOption
        end
      end
    end
  end
end
