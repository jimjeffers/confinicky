command :list do |c|
  c.syntax = 'cfy list'
  c.summary = 'Generates a list of all environment variables and/or aliases set in your configuration file(s).'
  c.description = ''
  c.example 'default', 'cfy list'
  c.example 'environment variables', 'cfy list env'
  c.example 'aliases', 'cfy list alias'

  c.action do |args, options|
    if Confinicky::ShellFile.has_path?
      say_error "Please set '#{Confinicky::FILE_PATH_VAR}' to point to your local configuration file."
      puts "Try running 'cfy use' for more info."
      abort
    end

    shell_file = Confinicky::ShellFile.new

    if args.first.nil? || args.first == Confinicky::Arguments::ENVIRONMENT
      puts shell_file.exports_table unless shell_file.exports_table.nil?
      say_ok "Identified #{shell_file.exports.length} exports in #{Confinicky::ShellFile.file_path}"
    end

    puts "" if args.first.nil?

    if args.first.nil? || args.first == Confinicky::Arguments::ALIAS
      puts shell_file.aliases_table unless shell_file.aliases_table.nil?
      say_ok "Identified #{shell_file.aliases.length} aliases in #{Confinicky::ShellFile.file_path}"
    end
  end
end

alias_command :ls, :list