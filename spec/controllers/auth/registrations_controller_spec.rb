require 'rails_helper'

RSpec.describe Auth::RegistrationsController, type: :controller do
  describe "#create" do
    it "adds user" do
      user_params = FactoryBot.attributes_for(:user)
      post :create, params: user_params
      expect(response.status).to eql 201
    end
  end

  describe "#destroy" do
    before do
      @session = FactoryBot.create(:session)
    end

    it "removes user" do
      sign_in_test @session
      delete :destroy
      expect(response.status).to eql 204
    end
  end
end
