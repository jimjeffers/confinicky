module Confinicky

  ##
  # A simple class that parses a line of shell code to
  # into a classified and attributed string.
  class CommandParser

    EXPORT_COMMAND = 'export'
    ALIAS_COMMAND = 'alias'

    ##
    # The name of the command.
    attr_reader :name

    ##
    # The assigned value of the command.
    attr_reader :value

    ##
    # Takes a line of code as a parameter and performs
    # classification.
    def initialize(line: nil)
      @line = line
      @current_command_type = EXPORT_COMMAND if export?
      @current_command_type = ALIAS_COMMAND if alias?
      process_attributes! unless line?
    end

    ##
    # The command should be regarded as a general line of code that
    # is of no interest if it doesn't match one of the supported
    # command types.
    def line?
      !export? && !alias?
    end

    ##
    # Returns true if the line of code matches an export command.
    def export?
      matches_command_type?(EXPORT_COMMAND) && has_expression?
    end

    ##
    # Returns true if the line of code matches an alias command.
    def alias?
      matches_command_type?(ALIAS_COMMAND) && has_expression?
    end

    ##
    # Returns an array containing the name / value pair for the command.
    def values_array
      [@name, @value]
    end

    private

      ##
      # Returns true if the command matches the specified type.
      def matches_command_type?(command_type)
        raise "No command type was specified." if command_type.nil?
        return !(@line =~ /\A#{command_type} /).nil?
      end

      ##
      # Returns true if the command actually has an expression.
      def has_expression?
        return Confinicky::Parsers::Expression.new(statement: @line).valid?
      end

      ##
      # Parses the commands name and assigned values into attributes.
      def process_attributes!
        if !@current_command_type.nil?
          expression = Confinicky::Parsers::Expression.new(statement: @line.gsub(/\A#{@current_command_type} /,""))
          @name = expression.name
          @value = expression.value
        end
      end

  end
end