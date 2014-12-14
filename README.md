# capistrano-cf

Coldfusion and Railo Rake Tasks for Capistrano Deployment

##Usage

capistrano-cf provides a library of rake tasks for deploying CFML applications via [Capistrano](http://capistranorb.com/) on [Coldfusion](http://www.adobe.com/products/coldfusion-family.html) or [Railo[(http://www.getrailo.org/) web application servers.  The library also includes deployment tasks specific to Windows Server, as Capistrano's default behavior of creating symlinks for shared files and directories is not compatibile with IIS.  You can specify the order the tasks are run manually in your [:stage].rb file (or deploy.rb if running the same sequence of tasks in all stages):
  
  
	#Disable default symlink behavior
	before "deploy:started", "windows_server:no_symlinks"
	# Sync shared directories
	after "deploy:started", "windows_server:upsync_shared"
	after "deploy:publishing","windows_server:downsync_shared"
	after "windows_server:downsync_shared", "windows_server:sync_release"
	after "windows_server:sync_release","coldfusion:windows:restart_jetty"
	after "coldfusion:windows:restart_jetty","coldbox:reinit"

##CFML Servers
At this time, this library has been tested on Coldfusion 9 and 10.  Look for a future update, further abstracting the CFML-server tasks based on the environment (or submit a pull request with your own updates).
	
##Deploying on Windows
###Dependencies
You will need SSH capability on your server. A simple way to accomplish this is by installing [Cygwin](https://www.cygwin.com/) with the following packages:
* [sshd](http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man8/sshd.8?query=sshd&sec=8) ([setup instructions](https://docs.oracle.com/cd/E24628_01/install.121/e22624/preinstall_req_cygwin_ssh.htm#EMBSC150))
* [git](http://git-scm.com/) or [Subversion](https://subversion.apache.org/)
* [curl](http://curl.haxx.se/)
* [rsync](http://linux.die.net/man/1/rsync) (installed in CygWin by default)

Make sure to set your service names for both the CFML application server and, if applicable, the Jetty Service.  You can skip the Jetty service task if your application does not use Java classloaders (This library was written with [Coldbox](http://www.coldbox.org/) applications in mind, and the Jetty service actions helpt to prevent Java Concurrent Modification errors when performing the framework reinit).

###Shared Files
Using IIS virtual directories for shared directories on Windows platforms is strongly recommended for large applications.  While the rysc behavior is reliable, if your shared directories are of any size (i.e. - sub-applications, image/media libraries) deployment times can increase significantly.  The best, Capistrano-friendly way to do this is to copy the live versions of those directories in to your :shared_path and configure IIS Manager for the virtual directory.  Then omit those directories from the `set :linked_dirs,%w{shared1 lib/shared2}` statement in your deploy.rb and, if your repo contains versioned files for those directories, add them to the list of rsync exclusions in your [:stage].rb file.


