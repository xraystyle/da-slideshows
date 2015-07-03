#!/usr/bin/ruby -w

include ApplicationHelper

duplicate_uuid_exception = /Validation failed: Uuid has already been taken/

Deviation.find_each.with_index do |d,i|

    d.src = d.src.sub(/http:/, "https:")
    d.thumb = d.thumb.sub(/http:/, "https:")

    begin
        d.save!
    rescue => e

        if e =~ duplicate_uuid_exception
            d.destroy
            log_message("Destroyed #{d.id}, duplicate UUID found.", logfile: "https_fix.log")
        else
            log_message("Error saving #{d.id}, error: #{e}", logfile: "https_fix.log")
        end

    end

    if i % 10_000 == 0
        update_message = "#{i} records processed..."
        log_message(update_message, logfile: "https_fix.log")
    end    


end