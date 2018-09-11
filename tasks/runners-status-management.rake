

namespace :runners do

  desc "Restarta runners"
  task :restart do
    on runners_ips, in: :parallel do |host|
      execute "sudo gitlab-runner", 'restart'
    end
  end

  desc "Install docker dompose"
  task :install_compose do
    on runners_ips, in: :parallel do |host|
      sudo "sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose"
      sudo "chmod +x /usr/bin/docker-compose"
    end
  end

  desc "Install and configure docker"
  task :install_docker do
    on runners_ips, in: :parallel do |host|
      sudo "yum update -y"
      sudo "yum install -y docker"
      sudo "service docker start"
      sudo "usermod -a -G docker ec2-user"
    end
  end

  desc "Install gitlab runner"
  task :install_runner do
    on runners_ips, in: :parallel do |host|
      sudo "curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash"
      sudo "yum install -y gitlab-runner"
      sudo "usermod -aG docker gitlab-runner"
    end
  end

  task :setup_gitlab_runner do
    on runners_ips, in: :parallel do |host|
      sudo "mkdir -p /builds"
      sudo "mkdir -p /runners"
      sudo "mkdir -p /runners/cache"
      sudo "chmod -R 777 /builds"
      sudo "chmod -R 777 /runners"
    end
  end

  task :install => [:install_docker, :install_compose, :install_runner, :setup_gitlab_runner]

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
