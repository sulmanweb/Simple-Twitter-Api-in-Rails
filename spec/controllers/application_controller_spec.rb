require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#authenticate_user!" do
    before do
      @session = FactoryBot.create(:session)
    end

    it "no result if user in signed in" do
      sign_in_test(@session)
      expect(controller.authenticate_user!).to eql nil
    end

    it "returns error if user not signed in"
  end
end
