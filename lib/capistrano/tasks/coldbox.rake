# Common coldbox actions
# TODO add cache clearing, module reloads, etc.

#Set your application variables here or override them downstream in your stage file
set :app_url, 'http://localhost/'
set :pw_reinit, 'true'

namespace :coldbox do
  
   desc 'Perform a reinit on a Coldbox application'
   task :reinit do
     on roles(:all) do
       #Send a HEAD request to reinit
       execute "curl -iI #{fetch(:app_url)}?fwreinit=#{fetch(:pw_reinit)}"
     end
   end #end reinit
   
end #end coldbox