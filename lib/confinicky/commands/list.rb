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

    exports = Confinicky::Controllers::Exports.new
    aliases = Confinicky::Controllers::Aliases.new

    if args.first.nil? || args.first == Confinicky::Arguments::ENVIRONMENT
      puts exports.to_table unless exports.to_table.nil?
      say_ok "Identified #{exports.length} exports in #{exports.path}"
    end

    puts "" if args.first.nil?

    if args.first.nil? || args.first == Confinicky::Arguments::ALIAS
      puts aliases.to_table unless aliases.to_table.nil?
      say_ok "Identified #{aliases.length} aliases in #{aliases.path}"
    end
  end
end

alias_command :ls, :list