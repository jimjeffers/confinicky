command :use do |c|
  c.syntax = 'cfy use'
  c.summary = 'Appends the confinicky file path shell variable to your configuration.'
  c.description = ''
  c.example 'Set a file:', 'cfy use /User/[YOUR_USER_NAME]/.bashrc'

  c.action do |args, options|
    @file_path = args.first

    if @file_path.nil?
      say_error "You must specify a path. See example:"
      puts 'cfy use /User/[YOUR_USER_NAME]/.bashrc'
      abort
    end

    say_error "Could not locate '#{@file_path}'." and abort if !File.exist?(@file_path)

    open(@file_path, 'a') { |f|
      f.puts "export #{Confinicky::FILE_PATH_VAR}=#{@file_path}"
    }

    say_ok "Set #{Confinicky::FILE_PATH_VAR} to #{@file_path}"
    if ENV[Confinicky::FILE_PATH_VAR].nil?
      puts "Run 'source #{@file_path}' or open a new terminal/shell window."
    end
  end
end