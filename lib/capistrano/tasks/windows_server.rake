# ==============================
# Windows Tasks - Called from [:stage].rb file
# ==============================

# If there are directories that shouldn't be synced, enter them here
# Note:  If your application contains .jar classloaders those will will be locked. Exclude those here  If those need to be updated we handle those separately with the deploy:major_release option
set :sync_exclude, %w{.git includes/media *.jar}


namespace :windows_server do
	desc 'stops the default capistrano behavior of symlinking shared paths'
	task :no_symlinks do
		on roles(:all) do
			Rake::Task["deploy:symlink:release"].clear_actions
			Rake::Task["deploy:symlink:shared"].clear_actions
		end
	end

    desc 'sync our shared files up from the current release'
    task :upsync_shared do
        on roles(:all) do
          $i = 0
          linked_dirs(current_path).each do |child|
            execute "/usr/bin/rsync -vraW --delete #{child}/ #{linked_dirs(shared_path)[$i]}/"
            $i += 1
          end
          $i = 0
          linked_files(current_path).each do |file|
            execute "rm -f #{linked_files(shared_path)[$i]} &&  cp -f #{file} #{linked_files(shared_path)[$i]}"
            $i += 1
          end
        end
    end

    desc 'copy our shared files down the latest release'
      task :downsync_shared do
          on roles(:all) do
            $i = 0
            linked_dirs(shared_path).each do |child|
              execute "/usr/bin/rsync -vraW --delete #{child}/ #{linked_dirs(release_path)[$i]}/"
              $i += 1
            end
            $i = 0
            linked_files(shared_path).each do |file|
              execute "rm -f #{linked_files(release_path)[$i]} && cp -f #{file} #{linked_files(release_path)[$i]}"
              $i += 1
            end
          end
      end
  
    desc 'copy our files to a new current release directory'
    task :sync_release do
        on roles(:all) do
          rsync_excludes = ''
          fetch(:sync_exclude).each do |exclude|
            rsync_excludes = rsync_excludes + " --exclude '#{exclude}'"
          end
          execute "rsync -vraW --delete#{rsync_excludes} #{release_path}/ #{current_path}/"
          execute "chown -R SVR-Admin #{current_path} && chown -R SVR-Admin #{current_path}"
         end
    end
    
    desc 'sync jar files for a major release'
    task :jar_sync do
      on roles(:all) do
          execute "rsync -a --include '*/' --include '*.jar' --exclude '*' #{release_path}/ #{current_path}/"
      end
    end
    
end