# Load DSL and set up stages
require "capistrano/setup"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("tasks/*.rake").each { |r| import r }
