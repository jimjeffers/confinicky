module Confinicky

  module Parsers

    ##
    # A simple class that parses a basic assignment expression
    class Expression

      SINGLE_QUOTE_MATCHER = /'([^']+)'/
      DOUBLE_QUOTE_MATCHER = /"([^"]+)"/

      ##
      # The name of the variable being assigned. (LHS)
      attr_reader :name

      ##
      # Takes a line of code as a parameter and performs
      # classification.
      def initialize(statement: nil)
        @statement = statement.split("=")
        if valid?
          @name = @statement[0]
          @value = @statement[1]
          @value.gsub!("\n","") unless open?
        end
      end

      ##
      # Ensures that the expression has an assigned value.
      def valid?
        @statement.length == 2 && !@statement[1].nil?
      end

      ##
      # Determines whether or not both types of quotes are present.
      def uses_both_quotes?
        !(@value =~ /'/).nil? && !(@value =~ /"/).nil?
      end

      ##
      # Determines if the expression is wrapped in double quotes.
      def uses_double_quotes?
        uses_both_quotes? && (@value =~ /'/) > (@value =~ /"/) || (@value =~ /"/) && (@value =~ /'/).nil?
      end

      ##
      # Determines if the expression is wrapped in single quotes.
      def uses_single_quotes?
        !uses_double_quotes? && !(@value =~ /'/).nil?
      end

      ##
      # Appends additional string content to the value stored in the
      # parser.
      def append_value(value)
        @value += value
      end

      ##
      # Determines if our statement is open ended. Meaning no closing quote
      # for a provided opening quote.
      def open?
        !@value.nil? && (uses_double_quotes? || uses_single_quotes?) && extracted_value.nil?
      end

      ##
      # The value which is being assigned to the variable in the expression (RHS)
      def value
        quote = uses_double_quotes? ? "\"" : "\'"
        value = extracted_value
        value =  "#{quote}#{value}#{quote}" if !value.nil? && value =~ /\s/ && value != "\n"
      end

      protected

        ##
        # Extracts the value from quotes if necessary. If the expression is
        # has an opening quote without a corresponding closing quote the
        # method will return nil.
        def extracted_value
          if uses_single_quotes? || uses_double_quotes?
            matcher = uses_double_quotes? ? DOUBLE_QUOTE_MATCHER : SINGLE_QUOTE_MATCHER
            matches = @value.scan(matcher)
            return nil if matches.length < 1
            return matches[0][0]
          end
          @value
        end

    end
  end
end