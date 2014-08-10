command :set do |c|
  c.syntax = 'confinicky set'
  c.summary = 'Sets an environment variable in your configuration file.'
  c.description = ''
  c.example 'description', 'confinicky set MY_VAR="some value"'

  c.action do |args, options|
    if Confinicky::ShellFile.has_path?
      say_error "Please set '#{Confinicky::FILE_PATH_VAR}' to point to your local configuration file."
      puts "Try running 'confinicky use' for more info."
      abort
    end

    shell_file = Confinicky::ShellFile.new

    duplicate_count = shell_file.find_duplicates.length
    if duplicate_count > 0
      say_error "Your configuration cannot be managed because it currently has duplicate export statements."
      puts "You must run 'confinicky clean' before you can manage your configuration."
      abort
    end

    if shell_file.set!(args.first)
      shell_file.write!
      say_ok "Successfully set '#{args.first}'."
      puts "Run 'source #{Confinicky::ShellFile.file_path}' or open a new terminal/shell window."
    else
      say_error "Could not set '#{args.first}' please double check to ensure you used the appropriate syntax."
    end
  end
end