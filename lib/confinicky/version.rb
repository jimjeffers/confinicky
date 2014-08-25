module Confinicky
  ##
  # Defines the version of the gem in an internal manner so that
  # users of the gem can query it at run time.
  module Version
    MAJOR = 0
    MINOR = 2
    PATCH = 2
    BUILD = ''

    STRING = [MAJOR, MINOR, PATCH].compact.join('.')
  end
end