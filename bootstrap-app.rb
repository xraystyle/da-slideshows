#!/usr/bin/ruby -w
require 'open3'
system 'clear'
# exit code
# Catch the ctrl-c, shut everything down.
Signal.trap("INT") {
	system 'clear'
	puts "\n\nShutting down app...\n\n"

	sleep 2

	unless File.exist?('tmp/pids/redis.pid')
		exit 1
	end

	puts "Quitting Sidekiq..."

	sleep 2

	sidekiq_pid = `cat tmp/pids/sidekiq.pid`
	if system "kill #{sidekiq_pid}"
		puts "Sidekiq shut down.\n\n"
	else
		puts "Sidekiq may have failed to quit.\n\n"
	end

	puts "Quitting Redis..."

	sleep 2

	redis_pid = `cat tmp/pids/redis.pid` 
	if system "kill #{redis_pid}"
		puts "Redis shut down.\n\n"
	else
		puts "Redis may have failed to quit.\n\n"
	end

	# Quit the Postgres app gracefully via osascript.
	puts "Quitting Postgres App..."
	`osascript -e 'quit app "Postgres"'`
	sleep 2
	puts "Postgres shut down.\n\n"


	puts "Quitting Puma...\n\n"

}



puts "Don't use this in production.\n\n"
puts "Press enter to continue, or ctrl-c to quit.\n\n"

gets

# Launch Postgres.app
def start_postgres_app
	`open /Applications/Postgres.app`
end



# Launch redis.
def start_redis
	exit_status = system 'redis-server config/redis-dev.conf'
	return exit_status
end




# Launch sidekiq
def start_sidekiq
	
	initial_pid = `cat tmp/pids/sidekiq.pid`
	`bundle exec sidekiq -C config/sidekiq.yml`
	sleep 1
	new_pid = `cat tmp/pids/sidekiq.pid`


	if initial_pid != new_pid
		return true
	else
		puts "pid didn't change."
		return false
	end
end



# launch Puma webserver.
def start_puma
	Open3.popen3('puma') do |stdin, stdout, stderr, wait_thr|
		while line = stdout.gets
			puts line
		end
	end
end



#  -----------------   Start Script  -----------------

system 'clear'

puts "Bootstrapping application...\n\n"

sleep 2

puts "Starting Postgress.app...\n\n"

start_postgres_app

sleep 2

if File.exist?(File.expand_path("#{ENV["HOME"]}/Library/Application Support/Postgres/var-9.4/postmaster.pid"))
	puts "Postgress started successfully.\n\n"
else 
	puts "Postgress failed to start. Check your configuration and try again."
	exit 1
end

# start redis
puts "Starting Redis...\n\n"

sleep 2

if start_redis
	puts "Redis started successfully.\n\n"
else
	puts "Error starting Redis. Retrying...\n\n"
end

unless start_redis
	puts "Redis failed to start. Check your config file and try again.\n\n"
	exit 1
end

# start sidekiq
puts "Starting Sidekiq...\n\n"

sleep 2

if start_sidekiq
	puts "Sidekiq started successfully."
else
	puts "Sidekiq failed to start. Check your config file and try again."
end

# If redis and sidekiq are running, fire up puma.

start_puma











