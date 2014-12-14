#
# Common Coldfusion Server Actions
#
#set our server type - override downstream in your stage file
set :server_type, 'windows'
  
#Coldfusion service names for windows here or override them downstream in your stage file
set :jetty_service_name, 'Coldfusion 10 Jetty Service'
set :coldfusion_service_name, 'Coldfusion 10 Application Server'

#Unix binary path for Coldfusion
set :unix_cf_binary, '/opt/coldfusion10/bin/coldfusion'


namespace :coldfusion do
    
  namespace :windows do
  
      desc 'Restart CF Jetty Service'
        task :restart_jetty do
          on roles(:all) do
            execute "net stop \'#{fetch(:jetty_service_name)}\'"
            execute "net start \'#{fetch(:jetty_service_name)}\'"
          end
      end
    
      desc 'Stop CF Jetty Service'
      task :stop_jetty do
        on roles(:all) do
          execute "net stop \'#{fetch(:jetty_service_name)}\'"
        end
      end
      
      desc 'Start CF Jetty Service'
      task :start_jetty do
            on roles(:all) do
              execute "net start \'#{fetch(:jetty_service_name)}\'"
            end
      end
      
      desc 'coldfusion restart on windows server'
      task :restart do
        on roles(:all) do
          execute "net stop \'#{fetch(:coldfusion_service_name)}\'"
          execute "net start \'#{fetch(:coldfusion_service_name)}\'"
          end
      end
    
    desc 'stop coldfusion on windows server'
    task :stop do
      on roles(:all) do
        execute "net stop \'#{fetch(:coldfusion_service_name)}\'"
        end
    end
    
    desc 'coldfusion start on windows server'
    task :start do
      on roles(:all) do
        execute "net start \'#{fetch(:coldfusion_service_name)}\'"
        end
    end
    
  end #end :windows
  
  namespace :unix do
    
    desc 'coldfusion restart on unix'
    task :restart do
      on roles(:all) do
        execute '#{fetch(:unix_cf_binary)} restart'
      end
    end
  
   desc 'stop coldfusion on unix'
    task :stop do
      on roles(:all) do
        execute '#{fetch(:unix_cf_binary)} stop'
      end
    end
 

    desc 'start coldfusion on unix' 
    task :start do
      on roles(:all) do
        execute '#{fetch(:unix_cf_binary)} start'
      end
    end

  end #end :unix
   
end #end :coldfusion



#:deploy namespace additions
namespace :deploy do
    desc 'Deploy a major release, which requires a restart of our server'
      task :major_release do
        on roles(:all) do
          before "coldfusion:windows:restart_jetty","coldfusion:#{fetch(:server_type)}:stop"
          after "coldfusion:windows:stop","windows_server:jar_sync"
          after "windows_server:jar_sync","coldfusion:#{fetch(:server_type)}:start"
      end
    end #end major release
end