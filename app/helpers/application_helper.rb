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


  def get_every_deviation_uuid
    log_message("get_every_deviation_uuid was just called.")
    all_uuids = Set.new

    Deviation.find_each do |d|
      all_uuids << d.uuid
    end

    all_uuids

  end

  def get_every_slideshow_seed

    all_seeds = Set.new

    Slideshow.find_each do |s|
      all_seeds << s.seed
    end

    all_seeds

  end

  # Translate Rails flash into a Bootstrap class.
  def bootstrap_class_for(flash_type)
   { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] 
  end


end
