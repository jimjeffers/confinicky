command :remove do |c|
  c.syntax = 'cfy remove'
  c.summary = 'Removes an alias or environment variable in your configuration.'
  c.description = ''
  c.example 'Remove an environment variable', 'cfy remove export MY_VAR'
  c.example 'Remove an alias', 'cfy remove alias my_alias'

  c.action do |args, options|

    # Abort if not yet setup.
    if !Confinicky::ConfigurationFile.setup?
      say_error "Confinicky's configuration is not valid or has not been setup."
      puts "Try running 'cfy setup'."
      abort
    end

    # Abort if missing arguments.
    if args.length < 2
      say_error "You must supply an expression such as: `cfy remove export MY_VAR`"
      abort
    end

    # Use the appropriate command group controller.
    command, expression = args[0], args[1]
    command_group = Confinicky::Controllers::Exports.new if command == Confinicky::Arguments::ENVIRONMENT
    command_group = Confinicky::Controllers::Aliases.new if command == Confinicky::Arguments::ALIAS

    # Abort if duplicate commands have been found.
    if command_group.duplicates.length > 0
      say_error "Your configuration cannot be managed because it currently has duplicate statements."
      puts "You must run 'cfy clean' before you can manage your configuration."
      abort
    end

    # Set the variable and save changes to disk.
    if command_group.remove!(expression) and command_group.save!
      say_ok "Successfully removed '#{args.first}'."
      puts "Open a new terminal/shell window for these changes to take affect."
    else
      say_error "Could not remove '#{expression}' please double check to ensure you used the appropriate syntax."
    end

  end

end

alias_command :rm, :remove