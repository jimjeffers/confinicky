command :duplicates do |c|
  c.syntax = 'cfy duplicates'
  c.summary = 'Generates a list of all variables that have multiple export statements.'
  c.description = ''
  c.example 'description', 'cfy duplicates'

  c.action do |args, options|

    # Abort if not yet setup.
    if !Confinicky::ConfigurationFile.setup?
      say_error "Confinicky's configuration is not valid or has not been setup."
      puts "Try running 'cfy setup'."
      abort
    end

    # Abort if missing arguments.
    if args.length < 1
      say_error "You must specify environment `cfy duplicates env` or aliases `cfy duplicates alias`."
      abort
    end

    # Use the appropriate command group controller.
    command = args[0]
    command_group = Confinicky::Controllers::Exports.new if command == Confinicky::Arguments::ENVIRONMENT
    command_group = Confinicky::Controllers::Aliases.new if command == Confinicky::Arguments::ALIAS

    # Print out any duplicates.
    duplicates = command_group.duplicates.map{|key, value| [key, value]}

    if duplicates.length > 0
      table = Terminal::Table.new :rows => duplicates
      puts table
      if command == Confinicky::Arguments::ENVIRONMENT
        say_ok "Identified #{duplicates.length} variables with multiple 'export' statements in #{command_group.path}"
      elsif command == Confinicky::Arguments::ALIAS
        say_ok "Identified #{duplicates.length} alias statements in #{command_group.path}"
      end
      puts "Run 'confinicky clean' to reduce these statements."
    else
      puts "No duplicate statements found."
    end

  end
end