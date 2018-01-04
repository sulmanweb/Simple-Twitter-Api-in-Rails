require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "POST /auth/signup" do
    it "creates a user" do
      signup_attributes = FactoryBot.attributes_for(:user)

      post auth_signup_path, params: signup_attributes

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)

      expect(json.length).to eq 3
      expect(json["user"].length).to eq 3
    end
    it "gives 422 if data incorrect" do
      signup_attributes = FactoryBot.attributes_for(:user, username: "")

      post auth_signup_path, params: signup_attributes

      expect(response).to have_http_status(422)
    end
    it "gives 422 on duplication" do
      FactoryBot.create(:user, username: "sulmanweb")
      signup_attributes = FactoryBot.attributes_for(:user, username: "sulmanweb")

      post auth_signup_path, params: signup_attributes

      expect(response).to have_http_status(422)
    end
  end

  describe "DELETE /auth/destroy" do
    it "destroys the user" do
      session = FactoryBot.create(:session)
      headers = sign_in_test_headers session

      delete auth_destroy_path, headers: headers

      expect(response).to have_http_status(:success)

      expect(response.body.length).to eq 0
    end
    it "should give 401 when user not signed in" do
      delete auth_destroy_path, headers: {"ACCEPT": "application/json"}

      expect(response).to have_http_status(401)
    end
  end

  describe "POST /auth/signin" do
    before do
      @user = FactoryBot.create(:user)
    end
    it "creates the session for user email" do
      signin_params = {auth: @user.email, password: @user.password}

      post auth_signin_path, params: signin_params

      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)

      expect(json.length).to eq 3
      expect(json["user"].length).to eq 3
    end
    it "creates the session for user username" do
      signin_params = {auth: @user.username, password: @user.password}

      post auth_signin_path, params: signin_params

      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)

      expect(json.length).to eq 3
      expect(json["user"].length).to eq 3
    end
    it "gives 422 for wrong password" do
      signin_params = {auth: @user.username, password: "abcd1234"}
      post auth_signin_path, params: signin_params

      expect(response).to have_http_status(422)
    end
    it "gives 422 for wrong auth" do
      signin_params = {auth: @user.username + "abcd", password: @user.password}
      post auth_signin_path, params: signin_params

      expect(response).to have_http_status(422)
    end
  end

  describe "DELETE /auth/signout" do
    before do
      @session = FactoryBot.create(:session)
    end

    it "removes the user session" do
      delete auth_signout_path, headers: sign_in_test_headers(@session)

      expect(response).to have_http_status(204)
    end

    it "gives 401 if user not signed in" do
      delete auth_signout_path, headers: {"ACCEPT": "application/json"}

      expect(response).to have_http_status(401)
    end
  end
end
