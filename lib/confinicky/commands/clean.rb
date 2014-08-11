command :clean do |c|
  c.syntax = 'cfy clean'
  c.summary = 'Removes all duplicate export statements in the configuration file.'
  c.description = ''
  c.example 'description', 'cfy clean'

  c.action do |args, options|
    if Confinicky::ShellFile.has_path?
      say_error "Please set '#{Confinicky::FILE_PATH_VAR}' to point to your local configuration file."
      puts "Try running 'cfy use' for more info."
      abort
    end
    shell_file = Confinicky::ShellFile.new
    duplicate_count = shell_file.find_duplicates.length
    say_ok "Your file is clean. No processing was required." and abort if duplicate_count < 1

    if agree "Backup your existing file before continuuing? (y/n)"
      say_ok "Backup saved to: "+Confinicky::ShellFile.backup!
    end

    shell_file.clean!
    say_ok "Your file is clean. #{duplicate_count} duplicate statements have been reduced."
  end
end