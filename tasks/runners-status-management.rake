

namespace :runners do

  desc "Restarta runners"
  task :restart do
    on runners_ips, in: :parallel do |host|
      execute "sudo gitlab-runner", 'restart'
    end
  end


  desc "Registra um runner utilizando um token e endpoint com configurações já padronizadas"
  task :register_token do
    on runners_ips, in: :parallel do |host|
      registration_url = ask_question("Qual a URL de registro?")
      registration_token = ask_question("Qual o Token de registro?")
      register_params = "--non-interactive --registration-token #{registration_token} --url #{registration_url} --builds-dir /builds --docker-volumes /runners/cache:/cache --docker-image ruby:2.2 --executor docker  --docker-shm-size 4000000000 --docker-privileged true "
      execute "sudo gitlab-runner register #{register_params}"
      execute "sudo gitlab-runner restart"
    end
  end

  desc "Remove um runner"
  task :remove_token do
    on runners_ips, in: :parallel do |host|
      registration_token = ask_question("Qual a URL de registro?")
      registration_url = ask_question("Qual o Token de registro?")
      execute %Q{sudo gitlab-runner unregister --registration-token #{registration_token} --url #{registration_url}}
      execute "sudo gitlab-runner restart"
    end
  end
end
