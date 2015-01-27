module ApplicationHelper

	# Simple method to make logging to the Rails logger easier,
	# faster and cleaner.
	def log_message(message, options = { })
		
		# If a logfile is specified, make the logger with that file as 
		# the output. Fall back to the env log.
		if options[:logfile]
			log = Rails.root.to_s + "/log/" + options[:logfile]
			logger = Logger.new(log)
		else
			default_log = Rails.root.to_s + "/log/" + Rails.env + ".log"
			logger = Logger.new(default_log)
		end


		case options[:log_level]
		when "info", nil
			logger.info message.to_s
		when "warning"
			logger.warn message.to_s
		when "error"
			logger.error message.to_s
		end
		
	end

	# def test_logger
	# 	log_message("Test one.", logfile: "test one.log")
	# 	log_message("Test two.", logfile: "redis.log")
	# end

end















