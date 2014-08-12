require 'yaml'

command :setup do |c|
  c.syntax = 'cfy setup'
  c.summary = 'Generates a ".confinicky" configuration YAML doc in your home directory.'
  c.description = ''
  c.example 'description', 'cfy setup'

  c.action do |args, options|
    path = Confinicky::Paths::CONFIG

    if File.exists?(path)
      config = YAML::load_file(path)
    else
      config = {files: {aliases: "#{ENV['HOME']}/aliases", env: "#{ENV['HOME']}/env"}}
    end

    env = ask("\nWhat file do you want to store your environment vars in?\n(leave blank to keep current: #{config[:files][:env]})")

    aliases = ask("\nWhat file do you want to store your aliases in?\n(leave blank to keep current: #{config[:files][:aliases]})")

    config[:files][:env] = env if env.length > 0
    config[:files][:aliases] = aliases if aliases.length > 0

    File.open(path, 'w') {|f| f.write config.to_yaml }

    say_ok "Wrote configuration (#{path})"
  end
end
