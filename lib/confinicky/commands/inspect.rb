command :inspect do |c|
  c.syntax = 'cfy inspect'
  c.summary = 'Generates a list of all values for a specified environment variable.'
  c.description = ''
  c.example 'Inspect your shell path.', 'cfy inspect PATH'

  c.action do |args, options|

    # Abort if not yet setup.
    if !Confinicky::ConfigurationFile.setup?
      say_error "Confinicky's configuration is not valid or has not been setup."
      puts "Try running 'cfy setup'."
      abort
    end

    # Abort if missing arguments.
    if args.length < 1
      say_error "You must supply a variable name such as: `cfy inspect MY_VAR`"
      abort
    end

    command_group = Confinicky::Controllers::Exports.new
    puts command_group.inspect(name:args[0], separator:":")

  end
end