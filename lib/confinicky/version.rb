module Confinicky
  ##
  # Defines the version of the gem in an internal manner so that
  # users of the gem can query it at run time.
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 6
    BUILD = ''

    STRING = [MAJOR, MINOR, PATCH].compact.join('.')
  end
end