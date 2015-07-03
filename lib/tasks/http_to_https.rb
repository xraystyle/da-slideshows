#!/usr/bin/ruby -w

Deviation.find_each.with_index do |d,i|

    d.src = d.src.sub(/http:/, "https:")
    d.thumb = d.thumb.sub(/http:/, "https:")

    if i % 10_000 == 0
        update_message = "#{i} records processed..."
        `echo #{update_message} >> ./progress.txt`
    end


    begin
        d.save!
    rescue => e
        error_message = "Error saving <#{d.id}>"
        `echo #{error_message} >> ./errors.txt`
        `echo #{e} >> ./errors.txt`
        `echo >> ./errors.txt`
    end
    

end