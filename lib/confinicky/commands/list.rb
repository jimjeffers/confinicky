command :list do |c|
  c.syntax = 'cfy list'
  c.summary = 'Generates a list of all environment variables set in your configuration file.'
  c.description = ''
  c.example 'description', 'cfy list'

  c.action do |args, options|
    if Confinicky::ShellFile.has_path?
      say_error "Please set '#{Confinicky::FILE_PATH_VAR}' to point to your local configuration file."
      puts "Try running 'cfy use' for more info."
      abort
    end

    shell_file = Confinicky::ShellFile.new
    puts shell_file.exports_table unless shell_file.exports_table.nil?
    say_ok "Identified #{shell_file.exports.length} exports in #{Confinicky::ShellFile.file_path}"
  end
end

alias_command :ls, :list