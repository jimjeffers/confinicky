command :list do |c|
  c.syntax = 'confinicky list'
  c.summary = 'Generates a list of all environment variables set in your configuration file.'
  c.description = ''
  c.example 'description', 'confinicky list'

  c.action do |args, options|
    if Confinicky::ShellFile.has_path?
      say_error "Please set '#{Confinicky::FILE_PATH_VAR}' to point to your local configuration file."
      puts "Try running 'confinicky use' for more info."
      abort
    end
    shell_file = Confinicky::ShellFile.new
    table = Terminal::Table.new do |t|
      for export in shell_file.exports
        if export[1].length > 100
          t.add_row [export[0], export[1][0...100]+"..."]
        else
          t.add_row export
        end
      end
    end
    puts table
    say_ok "Identified #{shell_file.exports.length} exports in #{Confinicky::ShellFile.file_path}"
  end
end

alias_command :ls, :list