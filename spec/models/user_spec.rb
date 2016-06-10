require 'rails_helper'

RSpec.describe User, :type => :model do

	# before { @user = User.new(email: "email@example.com", password: "foobar", password_confirmation: "foobar") }

	# Use FactoryGirl.build here instead of '.create' because some of the tests require
	# that a duplicate of @user be saved first, then the test checks @user for validity.
	# If '.create' is used, @user is saved first, and it will be the duplicate that is invalid,
	# which is not what we're testing for, even though it's correct behavior.
	let(:slideshow) { FactoryGirl.create(:slideshow) }
	let(:mature_deviation) { FactoryGirl.create(:mature) }	

	before do
		@user = FactoryGirl.build(:user)
		
		5.times do
			slideshow.deviations << FactoryGirl.create(:deviation)
		end

		slideshow.deviations << mature_deviation

	end

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
  	it { should respond_to(:seed) }
  	it { should respond_to(:admin?) }
  	it { should respond_to(:uuid) }
  	# it { should respond_to(:create_uuid) }

  	# Slideshow relationship:
  	# Handled with a method instead of an ActiveRecord relationship.
  	it { should respond_to(:slideshow) }

	end


	describe "should be valid when created properly" do
		it { should be_valid }
	end

	describe "should not be an admin by default" do
	  before { @user.save }
	  it { should_not be_admin }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when password is not present" do
		before do
			@user.password = ""
			@user.password_confirmation = ""
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

	describe "when uuid is not present" do
		before { @user.uuid = 'foo' }		
		it { should_not be_valid }
	end

	describe "when uuid is not a valid md5 hash" do
		before { @user.uuid = "foo" }		
		it { should_not be_valid }
	end

	describe "when uuid is not unique" do
		before do
			duplicate_user = @user.dup
			duplicate_user.uuid = @user.uuid
			duplicate_user.save
		end
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

	describe "slideshow should be retrievable," do
		let!(:seed) { "27E3DB23-BCA1-8653-1ACC-313A474B9FF2" }
		
		before do
			Slideshow.create(seed: seed)
			@user.seed = seed
		end
		it "should have the same seed" do
			expect(@user.slideshow.seed).to eq seed	
		end
		
	end

	describe "when user slideshow is retrieved" do
		before do
			@user.save
			@user.seed = slideshow.seed
		end

		it "should have the correct deviations" do

			user_value = @user.slideshow.deviations.to_ary.sort_by(&:id)
			slideshow_value = slideshow.deviations.to_ary.sort_by(&:id)

			# tests to make sure the contents are actually the same, not just that everything retrieved by
			# one is included in what's retrieved by the other.
			expect(user_value).to eq(slideshow_value)

		end

		it "should not include mature deviations" do
			expect(@user.slideshow.results).not_to include(mature_deviation)
		end
	  	
	end



end











