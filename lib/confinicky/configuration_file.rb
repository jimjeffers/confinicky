module Confinicky

  ##
  # A singleton model representing the configuration YAML utilized
  # by Confinicky.
  class ConfigurationFile

    SUPPORTED_KEYS = [:aliases, :env]
    PATH = Confinicky::Paths::CONFIG

    @@configuration = nil

    ##
    # Retrieves the value of the environment variables file path.
    def self.path_for_key(key: nil)
      self.raise_if_key_not_supported(key)
      self.get_configuration[:files][key]
    end

    ##
    # Set's the aliases file path.
    def self.set_path_for_key(path: "", key: nil)
      self.raise_if_key_not_supported(key)
      self.get_configuration[:files][key] = path if self.valid_path?(path)
    end

    ##
    # Writes the output to the appropriate YAML file.
    def self.write!
      File.open(PATH, 'w') {|f| f.write self.get_configuration.to_yaml }
    end

    ##
    # Returns a terminal table displaying the current configuration.
    def self.table
      Terminal::Table.new(title: "Configuration", headings: ['type', 'path']) do |t|
        self.get_configuration[:files].each {|k,v| t.add_row [k.to_s,v]}
      end
    end

    ##
    # Returns true if the configuration file exists along with
    # all specified paths.
    def self.setup?
      File.exists?(PATH) &&
      File.exists?(self.get_configuration[:files][:env]) &&
      File.exists?(self.get_configuration[:files][:aliases])
    end

    ##
    # Forces a configuration, primarily for testing purposes.
    def self.force_config!(configuration)
      @@configuration = configuration
    end

    private

      ##
      # Raises an error if a specified key is not supported.
      def self.raise_if_key_not_supported(key)
        raise "Unsupported key supplied to configuration: "+key.to_s unless SUPPORTED_KEYS.include?(key)
      end

      ##
      # Returns false if the path is blank and raises an error if the
      # supplied path does not point to an existing file.
      def self.valid_path?(path)
        if (!path.nil? && path.length > 0)
          raise "File does not exist at: #{path}" unless File.exists?(path)
          return true
        end
        false
      end

      ##
      # Lazy loading to retrieve the contents of the configuration file.
      def self.get_configuration
        @@configuration || self.load_configuration
      end

      ##
      # Loads the configuration file or generates a default hash.
      def self.load_configuration
        return @@configuration = YAML::load_file(PATH) if File.exists?(PATH)
        @@configuration = {files: {aliases: "#{ENV['HOME']}/aliases", env: "#{ENV['HOME']}/env"}}
      end

  end
end