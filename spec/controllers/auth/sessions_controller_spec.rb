require 'rails_helper'

RSpec.describe Auth::SessionsController, type: :controller do
  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
    end
    it "creates the user session" do
      signin_params = {auth: @user.username, password: @user.password}
      post :create, params: signin_params
      expect(response.status).to eql 201
    end
  end

  describe "#destroy" do
    before do
      @session = FactoryBot.create(:session)
    end
    it "destroys the user session" do
      sign_in_test(@session)
      delete :destroy
      expect(response.status).to eql 204
    end
  end
end
