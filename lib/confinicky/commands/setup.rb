require 'yaml'

command :setup do |c|
  c.syntax = 'cfy setup'
  c.summary = 'Generates a ".confinicky" configuration YAML doc in your home directory.'
  c.description = ''
  c.example 'description', 'cfy setup'

  c.action do |args, options|

    puts Confinicky::ConfigurationFile.table

    { env: "\nWhat file do you want to store your environment vars in?\n(leave blank to keep current)",
      aliases: "\nWhat file do you want to store your aliases in?\n(leave blank to keep current)"
    }.each do |key, question|
      Confinicky::ConfigurationFile.set_path_for_key(path: ask(question), key: key)
      path = Confinicky::ConfigurationFile.path_for_key(key: key)
      if !File.exists?(path)
        File.open(path, "w"){|f| f.write "##{key.upcase}\n"}
        say_ok "Created file at: #{path}"
      else
        say_ok "Using: #{Confinicky::ConfigurationFile.path_for_key(key: key)}"
      end
    end

    Confinicky::ConfigurationFile.write!

    color "\nWrote the following configuration to:", :bold
    puts "#{Confinicky::ConfigurationFile::PATH}"
    color "\nBe sure to add the following lines to your ~/.bash_profile or ~/.bashrc files:", :bold
    color ". #{Confinicky::ConfigurationFile.path_for_key(key: :env)}", :black, :on_green
    color ". #{Confinicky::ConfigurationFile.path_for_key(key: :aliases)}", :black, :on_green
  end
end
