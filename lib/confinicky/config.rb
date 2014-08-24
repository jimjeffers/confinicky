module Confinicky

  ##
  # Paths to dependencies used primarily for configuration.
  module Paths
    CONFIG = "#{ENV['HOME']}/.Confinicky"
  end

  ##
  # Constants representing arguments which can be passed
  # to the command line interface.
  module Arguments
    ENVIRONMENT = "env"
    ALIAS = "alias"
  end

end