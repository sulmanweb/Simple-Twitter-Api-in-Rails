require 'rails_helper'

RSpec.describe Session, type: :model do
  it "cannot exist without utoken" do
    session = FactoryBot.build(:session)
    expect(session.save).to be_truthy
  end
  it "verifies the last_used_at to exist" do
    session = FactoryBot.build(:session)
    session.save
    expect(session.last_used_at).to_not be_nil
  end
end
