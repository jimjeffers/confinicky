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
      say_ok "Using: #{Confinicky::ConfigurationFile.path_for_key(key: key)}"
    end

    Confinicky::ConfigurationFile.write!

    say_ok "\nWrote the following configuration to:\n#{Confinicky::ConfigurationFile::PATH}"
    puts Confinicky::ConfigurationFile.table
  end
end
