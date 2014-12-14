#
# Common Railo Server Actions
#
#set our server type - override downstream in your stage file
set :server_type, 'windows'
  
#Railo service names for windows here or override them downstream in your stage file
set :railo_service_name, 'Apache Tomcat Railo'

#Unix binary path for Railo (e.g. - [railo path]/railo_ctl)
set :railo_unix_binary, '/opt/railo/railo_ctl'


namespace :railo do
    
  namespace :windows do
  
      desc 'restart Railo on windows server'
      task :restart do
        on roles(:all) do
          execute "net stop \'#{fetch(:railo_service_name)}\'"
          execute "net start \'#{fetch(:railo_service_name)}\'"
          end
      end
    
    desc 'stop Railo on windows server'
    task :stop do
      on roles(:all) do
        execute "net stop \'#{fetch(:railo_service_name)}\'"
        end
    end
    
    desc 'start Railo on windows server'
    task :start do
      on roles(:all) do
        execute "net start \'#{fetch(:railo_service_name)}\'"
        end
    end
    
  end #end :windows
  
  namespace :unix do
    
    desc 'restart Railo on unix'
    task :restart do
      on roles(:all) do
        execute '#{fetch(:railo_unix_binary)} restart'
      end
    end
  
   desc 'stop Railo on unix'
    task :stop do
      on roles(:all) do
        execute '#{fetch(:railo_unix_binary)} stop'
      end
    end
 

    desc 'start Railo on unix' 
    task :start do
      on roles(:all) do
        execute '#{fetch(:railo_unix_binary)} start'
      end
    end

  end #end :unix
   
end #end :coldfusion



#:deploy namespace additions
namespace :deploy do
    desc 'Deploy a major release, which requires a restart of our server'
      task :major_release do
        on roles(:all) do
          after "deploy:finished","railo:#{fetch(:server_type)}:restart"
      end
    end #end major release
end
