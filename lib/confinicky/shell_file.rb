require 'fileutils'

module Confinicky

  ##
  # A model that loads and represents a shell file.
  class ShellFile

    ##
    # The alias commands stored in the shell file.
    attr_accessor :aliases

    ##
    # A list of all exports in the shell file.
    attr_accessor :exports

    ##
    # The preserved lines of code from the shell file which confinicky
    # will write back to the new shell file in the order they were received.
    attr_reader :lines

    ##
    # Returns the file path for the current instance of the shell file class.
    attr_reader :file_path

    ##
    # Parses the configuration file if it exists.
    def initialize(file_path: "")
      raise "Config file not found. Please set" if !File.exists?(@file_path = file_path)
      @exports = []
      @aliases = []
      @lines = []

      file = File.new(@file_path, "r")
      command = nil

      while (line = file.gets)
        if !command.nil? && command.open?
          command.append line
        else
          command = Confinicky::Parsers::Command.new(line: line)
        end

        @lines << line if command.line?
        @exports << command.values_array if command.export? and command.closed?
        @aliases << command.values_array if command.alias? and command.closed?
      end

      file.close()
    end

    ##
    # Returns a list of all exports in alphanumeric order.
    def exports
      @exports.sort { |x, y| x[0] <=> y[0] }
    end

    ##
    # Copies the current shell file to a temporary location.
    def backup!
      backup_name = @file_path+Time.now.getutc.to_i.to_s+".bak.tmp"
      FileUtils.cp(@file_path, backup_name)
      backup_name
    end

    ##
    # Writes a new version of the configuration file.
    def write!
      File.open(@file_path, "w") do |f|
        for line in @lines
          f.write line
        end
        f.puts @exports.map{|e| "export #{e.join("=")}"}.join("\n") if !@exports.nil? and @exports.length > 0
        f.puts @aliases.map{|a| "alias #{a.join("=")}"}.join("\n") if !@aliases.nil? and @aliases.length > 0
      end
      true
    end

  end
end