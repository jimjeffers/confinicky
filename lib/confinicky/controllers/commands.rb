module Confinicky

  module Controllers

    ##
    # The command group controller allows you to manipulate the
    # contents of a specific grouping of commands in a nice OO
    # way.
    class Commands

      ##
      # The path to the file on disk representing the model.
      attr_reader :path

      def initialize(file_type_key: :env)
        @path = Confinicky::ConfigurationFile.path_for_key(key: file_type_key)
        @shell_file = Confinicky::ShellFile.new(file_path: path)
        @commands = []
        @table_tite = "Commands"
      end

      ##
      # Matches a given string against the names of the group's contents.
      #
      # ==== Attributes
      #
      # * +query+ - The string used to match a given command name.
      #
      # ==== Examples
      #
      #   # Find the PATH environment variable.
      #   Exports.new.find("PATH")
      #   # => {name: "PATH", value: "/Users/name/bin/"}
      def find(query: nil)
        match = @commands.find{|command| command[0] =~ /^#{query}/ }
        {name: match[0], value: match[1]} unless match.nil?
      end

      ##
      # Detects duplicate definitions.
      def duplicates
        duplicates = {}
        @commands.each do |command|
          duplicates[command[0]] = (duplicates[command[0]].nil?) ? 1 : duplicates[command[0]]+1
        end
        duplicates.delete_if { |key,value| value==1}.sort_by{|key,value| value}.reverse
      end

      ##
      # Finds duplicate export statements and reduces them to the
      # most recent statement.
      def clean!
        for duplicate in duplicates.map{|duplicate| duplicate[0]}
          last_value = @commands.find_all{|c| c[0] =~ /^#{duplicate}/ }.last
          @commands.delete_if{ |c| c[0] == duplicate}
          @commands << [duplicate, last_value]
        end
      end

      ##
      # Parses an assignment such as "MY_VAR=1234" and injects it into
      # the exports or updates an existing variable if possible.
      #
      # ==== Attributes
      #
      # * +assignment+ - The value which will be assigned to the command.
      #
      # ==== Examples
      #
      #   # Create or update an environment variable called MY_VAR.
      #   Exports.new.set("MY_VAR=A short phrase.")
      #
      #   # Create or update an environment variable called MY_VAR.
      #   Aliases.new.set("home=cd ~")
      def set!(assignment)
        assignment = assignment.split("=")
        return false if assignment.length < 2
        remove! assignment[0]
        assignment[1] = "\'#{assignment[1]}\'" if assignment[1] =~ /\s/
        @commands << assignment
      end

      ##
      # Removes an environment variable if it exists.
      def remove!(variable_name)
        @commands.delete_if { |i| i[0] == variable_name }
      end

      ##
      # Updates the actual shell file on disk.
      def save!
        @shell_file.write!
      end

      ##
      # Creates a copy of the associated shell file.
      def backup!
        @shell_file.backup!
      end

      ##
      # The total number of commands managed by the controller.
      def length
        @commands.length
      end

      ##
      # Creates a table representation of the command data.
      def to_table
        make_table(title: @table_title, rows: @commands)
      end

      ##
      # Returns a table for the contents of a specific variable when split
      # by a specified separating string.
      #
      # ==== Attributes
      #
      # * +name+ - The name of the variable, alias, etc., to inspect.
      # * +separator+ - A string used to split the value. Defaults to a ':'.
      #
      # ==== Examples
      #
      #   # Create or update an environment variable called MY_VAR.
      #   Exports.inspect("PATH")
      #   # +--------+-----------------------------------------------------------+
      #   # |                           Values in PATH                           |
      #   # +--------+-----------------------------------------------------------+
      #   # | index  | value                                                     |
      #   # +--------+-----------------------------------------------------------+
      #   # | 1      | /Users/name/.rvm/gems/ruby-2.1.2/bin                      |
      #   # | 2      | /Users/name/.rvm/gems/ruby-2.1.2@global/bin               |
      #   # | 3      | /Users/name/.rvm/rubies/ruby-2.1.2/bin                    |
      #   # +--------+-----------------------------------------------------------+
      def inspect(name: nil, separator:":")
        return nil if (match = find(query: name)).nil?
        count = 0
        rows = match[:value].split(separator).map{|partition| [count+=1, partition]}
        make_table(title: "Values in #{name}", rows: rows, headings: ['index', 'value'])
      end

      private

        ##
        # Returns a terminal table with a specified title and contents.
        #
        # ==== Attributes
        #
        # * +title+ - A string to be printed out as the title.
        # * +rows+ - An array of sub arrays +[[name, value],[name, value],...]+
        # * +headings+ - An array of strings for heading titles +['Name', 'Value']+
        #
        # ==== Examples
        #
        #   # Create or update an environment variable called MY_VAR.
        #   Exports.inspect("PATH")
        #   # +--------+-----------------------------------------------------------+
        #   # |                           [title]                                  |
        #   # +--------+-----------------------------------------------------------+
        #   # | Name   | Value                                                     |
        #   # +--------+-----------------------------------------------------------+
        #   # | PATH   | '/Users/name/.rvm/gems/ruby-2.1.2/bin:/Users/name/.rvm... |
        #   # | FOO    | 3000                                                      |
        #   # | BAR    | 'some other value'                                        |
        #   # +--------+-----------------------------------------------------------+
        def make_table(title: '', rows: [], headings: ['Name', 'Value'])
          return nil if rows.length < 1
          table = Terminal::Table.new(title: title, headings: headings) do |t|
            for row in rows
              if row[1].length > 100
                t.add_row [row[0], row[1][0...100]+"..."]
              else
                t.add_row row
              end
            end
          end
          return table
        end

    end
  end
end