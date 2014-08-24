module Confinicky
  module Controllers

    ##
    # A subclass of the command group controller specifically
    # for managing export statements.
    class Exports < Commands

      def initialize
        super(file_type_key: :env)
        @commands = @shell_file.exports
        @table_title = "Environment Variables"
      end

      ##
      # Updates the actual shell file on disk.
      def save!
        @shell_file.exports = @commands
        @shell_file.write!
      end

    end

  end
end