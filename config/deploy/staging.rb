# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.
role :app, %w{deploy@example.com}
role :web, %w{deploy@example.com}
role :db,  %w{deploy@example.com}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value

#Coldbox Reinit Information
set :pw_reinit, 'myr31n1tp455'
set :app_url, 'http://www.example.com/'


#Windows tasks
#TODO: Consolidate these in to default actions with dynamic server vars  
after "deploy:started", "windows_server:upsync_shared"
after "deploy:publishing","windows_server:downsync_shared"
after "windows_server:downsync_shared", "windows_server:sync_release"
after "windows_server:sync_release","coldfusion:windows:restart_jetty"
after "coldfusion:windows:restart_jetty","coldbox:reinit"
#rollback
after "deploy:rollback", "windows_server:sync_release"
