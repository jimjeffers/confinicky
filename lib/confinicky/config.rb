module Confinicky

  ##
  # Paths to dependencies used primarily for configuration.
  module Paths
    CONFIG = "#{ENV['HOME']}/.Confinicky"
  end

  ##
  # Environment variables referenced by confinicky.
  module Variables
    FILE_PATH = "CONFINICKY_FILE_PATH"
  end

  ##
  # Constants representing arguments which can be passed
  # to the command line interface.
  module Arguments
    ENVIRONMENT = "env"
    ALIAS = "alias"
  end

end