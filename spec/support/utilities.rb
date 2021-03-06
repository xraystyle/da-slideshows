
# def make_uuid

# 	# make random numbers for the first few parts of the seed.
# 	# last part doesn't matter. That's enough entropy to avoid
# 	# collisions.		
# 	first = Random.rand(268435456..4294967295).to_s(16).upcase
# 	second = Random.rand(4096..65535).to_s(16).upcase
# 	third = Random.rand(4096..65535).to_s(16).upcase
# 	fourth = Random.rand(4096..65535).to_s(16).upcase
	
# 	"#{first}-#{second}-#{third}-#{fourth}-C32495BB6097"

# end	

def expect_email(email)
  delivered = ActionMailer::Base.deliveries.last
  expected =  email.deliver

  delivered.multipart?.should == expected.multipart?
  delivered.headers.except("Message-Id").should == expected.headers.except("Message-Id")
end