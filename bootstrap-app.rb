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
		puts "Sidekiq killed.\n\n"
	else
		puts "Sidekiq may have failed to quit.\n\n"
	end

	puts "Quitting Redis..."

	sleep 2

	redis_pid = `cat tmp/pids/redis.pid` 
	if system "kill #{redis_pid}"
		puts "Redis killed.\n\n"
	else
		puts "Redis may have failed to quit.\n\n"
	end

	puts "Quitting Puma...\n\n"

}



puts "Don't use this in production.\n\n"
puts "Press enter to continue, or ctrl-c to quit.\n\n"

gets




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




def start_puma
	Open3.popen3('puma') do |stdin, stdout, stderr, wait_thr|
		while line = stdout.gets
			puts line
		end
	end
end

system 'clear'

puts "Bootstrapping application...\n\n"

sleep 2

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











