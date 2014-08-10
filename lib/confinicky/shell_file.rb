require 'fileutils'

module Confinicky
  class ShellFile

    ##
    # References the actual file path from the shell configuration.
    def self.file_path
      ENV[Confinicky::FILE_PATH_VAR]
    end

    ##
    # Returns true if the file path has been configured in the environment.
    def self.has_path?
      self.file_path.nil?
    end

    ##
    # Returns true if the file actually exists.
    def self.exists?
      File.exists? ENV[Confinicky::FILE_PATH_VAR]
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
    def initialize
      raise "Config file not found. Please set" if !Confinicky::ShellFile.exists?
      @exports = []
      @lines = []
      file = File.new(Confinicky::ShellFile.file_path, "r")

      while (line = file.gets)
        if line =~ /\Aexport /
          export = line.gsub(/\Aexport /,"").split("=")
          @exports << [export[0], export[1].gsub(/\n/, "")]
        else
          @lines << line
        end
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
      File.open(Confinicky::ShellFile.file_path, "w") do |f|
        for line in @lines
          f.write line
        end
        f.puts @exports.map{|e| "export #{e.join("=")}"}.join("\n")
      end
    end

  end
end