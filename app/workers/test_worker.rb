# Sidetiq is tested working.

# class TestWorker

# 	include Sidekiq::Worker
# 	include Sidetiq::Schedulable


# 	recurrence { minutely }

# 	def perform
# 		# logger.info "I'm running once a minute!" 	
# 	end

# end