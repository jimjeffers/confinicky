require 'commander/import'
require 'terminal-table'
require 'confinicky'

HighLine.track_eof = false # Fix for built-in Ruby
Signal.trap("INT") {} # Suppress backtrace when exiting command

program :version, "0.1.3"
program :description, 'A command-line interface for managing your shell environment variables.'

program :help, 'Author', 'Jim Jeffers <jim@sumocreations.com>'
program :help, 'Website', 'https://github.com/jimjeffers'
program :help_formatter, :compact

default_command :help

require 'confinicky/commands'