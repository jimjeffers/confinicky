require 'fileutils'

module Confinicky
  ##
  # A model that loads and represents a shell file.
  class ShellFile

    ##
    # The alias commands stored in the shell file.
    attr_reader :aliases

    ##
    # The preserved lines of code from the shell file which confinicky
    # will write back to the new shell file in the order they were received.
    attr_reader :lines

    ##
    # Returns the file path for the current instance of the shell file class.
    attr_reader :file_path

    ##
    # References the actual file path from the shell configuration.
    def self.file_path
      ENV[Confinicky::Variables::FILE_PATH]
    end

    ##
    # Returns true if the file path has been configured in the environment.
    def self.has_path?
      self.file_path.nil?
    end

    ##
    # Returns true if the file actually exists.
    def self.exists?
      File.exists? ENV[Confinicky::Variables::FILE_PATH]
    end

    ##
    # Copies the current shell file to a temporary location.
    def self.backup!
      backup_name = Confinicky::ShellFile.file_path+Time.now.getutc.to_i.to_s+".bak.tmp"
      FileUtils.cp(Confinicky::ShellFile.file_path, backup_name)
      backup_name
    end

    ##
    # Parses the configuration file if it exists.
    def initialize(file_path: Confinicky::ShellFile.file_path)
      raise "Config file not found. Please set" if !File.exists?(@file_path = file_path)
      @exports = []
      @aliases = []
      @lines = []

      file = File.new(@file_path, "r")

      while (line = file.gets)
        command = Confinicky::Parsers::Command.new(line: line)
        @lines << line if command.line?
        @exports << command.values_array if command.export?
        @aliases << command.values_array if command.alias?
      end

      file.close()
    end

    ##
    # Detects duplicate definitions.
    def find_duplicates
      duplicates = {}
      @exports.each do |export|
        duplicates[export[0]] = (duplicates[export[0]].nil?) ? 1 : duplicates[export[0]]+1
      end
      duplicates.delete_if { |key,value| value==1}.sort_by{|key,value| value}.reverse
    end

    ##
    # Returns a list of all exports in alphanumeric order.
    def exports
      @exports.sort { |x, y| x[0] <=> y[0] }
    end

    ##
    # Finds duplicate export statements and replaces them with the actual
    # value from the environment.
    def clean!
      for duplicate in find_duplicates.map{|duplicate| duplicate[0]}
        @exports.delete_if{ |i| i[0] == duplicate}
        @exports << [duplicate, ENV[duplicate]]
      end
      write!
    end

    ##
    # Parses an assignment such as "MY_VAR=1234" and injects it into
    # the exports or updates an existing variable if possible.
    def set!(assignment)
      assignment = assignment.split("=")
      return false if assignment.length < 2
      remove! assignment[0]
      assignment[1] = "\'#{assignment[1]}\'" if assignment[1] =~ /\s/
      @exports << assignment
    end

    ##
    # Removes an environment variable if it exists.
    def remove!(variable_name)
      @exports.delete_if { |i| i[0] == variable_name }
    end

    ##
    # Writes a new version of the configuration file.
    def write!
      File.open(@file_path, "w") do |f|
        for line in @lines
          f.write line
        end
        f.puts @exports.map{|e| "export #{e.join("=")}"}.join("\n")
      end
    end

    ##
    # Returns a terminal table summarizing all known environment variables, otherwise
    # returns nil if no environment variables exist.
    def exports_table
      make_table(title: "Environment Variables", rows: @exports)
    end


    ##
    # Returns a terminal table summarizing all known aliases, otherwise
    # returns nil if no aliases exist.
    def aliases_table
      make_table(title: "Aliases", rows: @aliases)
    end

    private

      ##
      # Returns a terminal table with a specified title and contents.
      def make_table(title: '', rows: [])
        return nil if rows.length < 1
        table = Terminal::Table.new(title: title, headings: ['Name', 'Value']) do |t|
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