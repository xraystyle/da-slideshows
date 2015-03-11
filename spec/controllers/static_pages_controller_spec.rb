require 'rails_helper'

RSpec.describe StaticPagesController, :type => :controller do

  describe "GET home" do
    it "returns http success" do
      request.env['HTTPS'] = 'on'
      get :home
      expect(response).to render_template 'static_pages/home'
    end
  end

end
