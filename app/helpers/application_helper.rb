require 'open-uri'
require 'json'

module ApplicationHelper

	# Simple method to make logging to the Rails logger easier,
	# faster and cleaner.
	def log_messsage(message, log_level="info")
		
		case log_level
		when "info"
			Rails.logger.info "\n#{Time.now}: #{message.to_s}"
		when "warning"
			Rails.logger.warn "\n#{Time.now}: #{message.to_s}"
		when "error"
			Rails.logger.error "\n#{Time.now}: #{message.to_s}"
		end
		
	end


	# Retrieve a new API Access token from DA. Required for other API calls.
	def get_api_token
		response = open("https://www.deviantart.com/oauth2/token?grant_type=client_credentials&client_id=2220&client_secret=489e314d779745dd3ba3297b6e28900e").read
		json = JSON.parse(response)

		# if the JSON object has the key "error", something sent sideways.
		if json["error"]
			log_messsage("Error retrieving API token from DA.", "error")
			log_messsage(json["error_description"], "error")
		else
			# If it doesn't, we got an access token. 
			# Tokens are valid for 3600 seconds. Cache it in Redis for 
			# slightly less than that so we can re-use it and only 
			# reauth when necessary.
			log_messsage("API key retrieved, setting in Redis.")
			$redis.multi do
				$redis.set("access_token", json["access_token"])
				$redis.expire("access_token", 3585)
			end
		end

	end




	# Retrieve the deviations from the "What's Hot" page.
	def retrieve_whats_hot
		unless $redis.ttl("access_token") > 30
			log_messsage("Access token expires soon. Renewing...")
			get_api_token
		end

		access_token = $redis.get("access_token")



	end



end















