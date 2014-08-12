command :list do |c|
  c.syntax = 'cfy list'
  c.summary = 'Generates a list of all environment variables and/or aliases set in your configuration file(s).'
  c.description = ''
  c.example 'default', 'cfy list'
  c.example 'environment variables', 'cfy list env'
  c.example 'aliases', 'cfy list alias'

  c.action do |args, options|
    if !Confinicky::ConfigurationFile.setup?
      say_error "Confinicky's configuration is not valid or has not been setup."
      puts "Try running 'cfy setup'."
      abort
    end

    if args.first.nil? || args.first == Confinicky::Arguments::ENVIRONMENT
      path = Confinicky::ConfigurationFile.path_for_key(key: :env)
      shell_file = Confinicky::ShellFile.new(file_path: path)
      puts shell_file.exports_table unless shell_file.exports_table.nil?
      say_ok "Identified #{shell_file.exports.length} exports in #{path}"
    end

    puts "" if args.first.nil?

    if args.first.nil? || args.first == Confinicky::Arguments::ALIAS
      path = Confinicky::ConfigurationFile.path_for_key(key: :aliases)
      shell_file = Confinicky::ShellFile.new(file_path: path)
      puts shell_file.aliases_table unless shell_file.aliases_table.nil?
      say_ok "Identified #{shell_file.aliases.length} aliases in #{path}"
    end
  end
end

alias_command :ls, :list