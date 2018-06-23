namespace :access do
  desc "Adiciona uma nova chave pública na máquina do runner"
  task :add_ssh_key do
    key_content = ask_question("Insira a chave que deseja adicionar")

    on runners_ips, in: :parallel do |host|
      execute %Q{echo "#{key_content}" >> ~/.ssh/authorized_keys}
    end
  end

  desc "Remove uma chave pública na máquina do runner"
  task :remove_ssh_key do
    key_content = ask_question("Insira a chave (ou parte dela) que deseja adicionar")

    on runners_ips, in: :parallel do |host|
      execute %Q{ \
        if test -f $HOME/.ssh/authorized_keys; then \
          if grep -v "#{key_content}" $HOME/.ssh/authorized_keys > $HOME/.ssh/tmp; then \
            cat $HOME/.ssh/tmp > $HOME/.ssh/authorized_keys && rm $HOME/.ssh/tmp; \
          else \
            rm $HOME/.ssh/authorized_keys && rm $HOME/.ssh/tmp; \
          fi; \
        fi
      }
    end
  end

end
