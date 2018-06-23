require 'dotenv/load'
require 'sshkit'
require 'sshkit/dsl'
require 'readline'
include SSHKit::DSL

def runners_ips
  ENV.fetch("GITLAB_RUNNERS_IPS", "").split(",")
end

def ask_question(question)
  puts question
  prompt = "\n"
  Readline.readline(prompt, true).squeeze(" ").strip
end

SSHKit::Backend::Netssh.configure do |ssh|
  ssh.connection_timeout = 30
  ssh.ssh_options = {
    keys: ENV["PRIVATE_KEY_PATH"],
    auth_methods: %w(publickey )
  }

end

Dir.glob("tasks/*.rake").each { |r| import r }
