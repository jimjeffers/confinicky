command :clean do |c|
  c.syntax = 'cfy clean'
  c.summary = 'Removes all duplicate export statements in the configuration file.'
  c.description = ''
  c.example 'description', 'cfy clean'

  c.action do |args, options|

    # Abort if not yet setup.
    if !Confinicky::ConfigurationFile.setup?
      say_error "Confinicky's configuration is not valid or has not been setup."
      puts "Try running 'cfy setup'."
      abort
    end

    # Abort if missing arguments.
    if args.length < 1
      say_error "You must specify environment `cfy clean env` or aliases `cfy clean alias`."
      abort
    end

    # Use the appropriate command group controller.
    command = args[0]
    command_group = Confinicky::Controllers::Exports.new if command == Confinicky::Arguments::ENVIRONMENT
    command_group = Confinicky::Controllers::Aliases.new if command == Confinicky::Arguments::ALIAS

    duplicate_count = command_group.duplicates.length
    say_ok "Your file is clean. No processing was required." and abort if duplicate_count < 1

    if agree "Backup your existing file before continuuing? (y/n)"
      say_ok "Backup saved to: "+command_group.backup!
    end

    command_group.clean!
    say_ok "Your file is clean. #{duplicate_count} duplicate statements have been reduced."

  end
end