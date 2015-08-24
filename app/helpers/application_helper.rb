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


  # def get_every_deviation_uuid
  #   Deviation.pluck(:uuid).to_set
  # end

  def get_every_slideshow_seed
    Slideshow.pluck(:seed).to_set
  end

  # Translate Rails flash into a Bootstrap class.
  def bootstrap_class_for(flash_type)
   { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] 
  end


end
