command :set do |c|
  c.syntax = 'cfy set'
  c.summary = 'Sets an alias or environment variable in your configuration.'
  c.description = ''
  c.example 'Set an environment variable', 'cfy set export MY_VAR="some value"'
  c.example 'Set an environment alias', 'cfy set alias home="cd ~"'

  c.action do |args, options|

    # Abort if not yet setup.
    if !Confinicky::ConfigurationFile.setup?
      say_error "Confinicky's configuration is not valid or has not been setup."
      puts "Try running 'cfy setup'."
      abort
    end

    # Abort if missing arguments.
    if args.length < 2
      say_error "You must supply an expression such as: `cfy set export MY_VAR=\"some value\"`"
      abort
    end

    # Use the appropriate command group controller.
    command, expression = args[0], args[1]
    command_group = Confinicky::Controllers::Exports.new if command == Confinicky::Arguments::ENVIRONMENT
    command_group = Confinicky::Controllers::Aliases.new if command == Confinicky::Arguments::ALIAS

    # Abort if duplicate commands have been found.
    if command_group.duplicates.length > 0
      say_error "Your configuration cannot be managed because it currently has duplicate statements."
      puts "You must run 'cfy clean #{command}' before you can manage your configuration."
      abort
    end

    # Set the variable and save changes to disk.
    if command_group.set!(expression) and command_group.save!
      say_ok "Successfully set '#{args.first}'."
      puts "Open a new terminal/shell window for these changes to take affect."
    else
      say_error "Could not set '#{expression}' please double check to ensure you used the appropriate syntax."
    end

  end
end