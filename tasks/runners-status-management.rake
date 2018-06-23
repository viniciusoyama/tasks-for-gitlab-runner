

namespace :runners do

  desc "Restarta runners"
  task :restart do
    on runners_ips, in: :parallel do |host|
      execute "sudo gitlab-runner", 'restart'
    end
  end
end
