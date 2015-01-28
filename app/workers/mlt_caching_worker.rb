# This sidekiq worker will update the stored results for What's Hot every
# 4 hours so that the results displayed on the channel changer will remain
# relatively fresh. Then it will get MLT results for each deviation and 
# create a slideshow for each seed.
class MLTCachcing

	include ApplicationHelper
	include ApiHelper
	include Sidekiq::Worker
	include Sidetiq::Schedulable
	
	sidekiq_options retry: false

	recurrence backfill: false do
		daily.hour_of_day(0, 4, 8, 12, 16, 20, 24) 
	end

	def perform

		logger.info("Getting all deviation UUIDs...")

		all_uuids = get_every_deviation_uuid

		logger.info("Getting all slideshow seeds...")

		all_seeds = get_every_slideshow_seed

		logger.info("Refreshing What's Hot...")

		# Update the What's Hot deviations list.
		get_whats_hot

		logger.info("What's Hot updated. Fetching MLT for WH list...")

		# Retrieve the fresh What's Hot list.
		whats_hot = Slideshow.where(seed: "00000000-0000-0000-0000-000000000001").first

		whats_hot.deviations.each do |d|

			# Skip MLT fetching for slideshows that already exist.
			# No real point in updating slideshows, the MLT results
			# are fine as is. Plus, this MAJORLY cuts down on the
			# number of unnecessary API calls.
			next if all_seeds.include?(d.uuid)

			# Get MLT results and park 'em in the DB.
			get_mlt_results(d.uuid, all_uuids)
			
		end

		logger.info("MLT Caching run completed.\n")

	end


end