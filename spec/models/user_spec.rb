require 'rails_helper'

RSpec.describe User, :type => :model do
# pending "add some examples to (or delete) #{__FILE__}"

	before { @user = User.new(email: "email@example.com", password: "foobar", password_confirmation: "foobar") }

	subject { @user }

	describe "should respond to the following methods" do

		# Provided by devise:
		it { should respond_to(:email) }
		it { should respond_to(:password) }
		it { should respond_to(:password_confirmation) }
		it { should respond_to(:reset_password_token) }
	  	it { should respond_to(:encrypted_password) }
	  	it { should respond_to(:reset_password_sent_at) }
	  	it { should respond_to(:remember_created_at) }
	  	it { should respond_to(:sign_in_count) }
	  	it { should respond_to(:current_sign_in_at) }
	  	it { should respond_to(:last_sign_in_at) }
	  	it { should respond_to(:current_sign_in_ip) }
	  	it { should respond_to(:last_sign_in_ip) }

	  	# Slideshow relationship:
	  	it { should respond_to(:slideshow) }

	end


	describe "should be valid when created properly" do
		it { should be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when password is not present" do
		before do
			@user = @user = User.new(email: "email@example.com", password: " ", password_confirmation: " ")
		end
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }		
		it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
			duplicate_user = @user.dup
			duplicate_user.email = @user.email.upcase
			duplicate_user.save
		end
		it { should_not be_valid }
	end

	describe "email address with mixed case" do
		let(:mixed_case_email) { "UsEr@ExAmPlE.cOM" }

		it "should be saved as lowercase" do
			@user.email = mixed_case_email
			@user.save
			expect(@user.reload.email).to eq mixed_case_email.downcase
		end
	end

	describe "Slideshow should be retrievable," do
		let!(:seed) { "27E3DB23-BCA1-8653-1ACC-313A474B9FF2" }
		
		before do
			Slideshow.create(seed: seed)
			@user.seed = seed
		end
		it "should have the same seed" do
			expect(@user.reload.slideshow.seed).to eq seed	
		end
		
	end



end











