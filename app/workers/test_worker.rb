# # Sidetiq is tested working.

# class TestWorker

# 	include Sidekiq::Worker
# 	include Sidetiq::Schedulable


# 	# recurrence { hourly.minute_of_hour(22,24,26,28,30) }

# 	def perform
# 		# logger.info "I'm running once every 2 minutes!" 	
# 	end

# end