command :duplicates do |c|
  c.syntax = 'cfy duplicates'
  c.summary = 'Generates a list of all variables that have multiple export statements.'
  c.description = ''
  c.example 'description', 'cfy duplicates'

  c.action do |args, options|

    if Confinicky::ShellFile.has_path?
      say_error "Please set '#{Confinicky::FILE_PATH_VAR}' to point to your local configuration file."
      puts "Try running 'cfy use' for more info."
      abort
    end

    shell_file = Confinicky::ShellFile.new
    duplicates = shell_file.find_duplicates.map{|key, value| [key, value]}
    table = Terminal::Table.new :rows => duplicates
    puts table
    say_ok "Identified #{duplicates.length} variables with multiple 'export' statements in #{Confinicky::ShellFile.file_path}"
    puts "Run 'confinicky clean' to reduce these statements."
  end
end