module Confinicky
  module Controllers

    ##
    # A subclass of the command group controller specifically
    # for managing alias statements.
    class Aliases < Commands
      def initialize
        super(file_type_key: :aliases)
        @commands = @shell_file.aliases
        @table_title = "Aliases"
      end

      ##
      # Updates the actual shell file on disk.
      def save!
        @shell_file.aliases = @commands
        @shell_file.write!
      end
    end

  end
end