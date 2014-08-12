module Confinicky

  module Parsers

    ##
    # A simple class that parses a basic assignment expression
    class Expression

      ##
      # Takes a line of code as a parameter and performs
      # classification.
      def initialize(statement: nil)
        @statement = statement.split("=")
      end

      ##
      # Ensures that the expression has an assigned value.
      def valid?
        @statement.length == 2 && !@statement[1].nil?
      end

      ##
      # The name of the variable being assigned. (LHS)
      def name
        @statement[0]
      end

      ##
      # The value which is being assigned to the variable in the expression (RHS)
      def value
        return "\'#{@statement[1]}\'" if @statement[1] =~ /\s/
        @statement[1]
      end

    end
  end
end