require 'rails_helper'

RSpec.describe User, type: :model do
  it "can be created if username, email and password given"
  it "is invalid if username not unique"
  it "is invalid if email not unique"
  it "is valid to edit without providing current password"
  describe "#username" do
    it {is_expected.to validate_presence_of(:username)}
    it {is_expected.to allow_value("sulmanweb").for(:username)}
    it {is_expected.to allow_value("sulman_web").for(:username)}
    it {is_expected.to_not allow_value("sulmanweb ").for(:username)}
    it {is_expected.to_not allow_value("sulmanweb 1").for(:username)}
    it {is_expected.to_not allow_value("abcdefghijklmnop").for(:username)}
    it {is_expected.to_not allow_value("sulman@1").for(:username)}
  end
  describe '#email' do
    it {is_expected.to validate_presence_of(:email)}
    it {is_expected.to allow_value("sulman_web@gmail.com").for(:email)}
    it {is_expected.to_not allow_value("sulman_web@gmail@com").for(:email)}
    it {is_expected.to_not allow_value("sulmanweb@.com").for(:email)}
    it {is_expected.to_not allow_value("sulmanwebgmail.com").for(:email)}
  end
  describe '#password' do
    it {is_expected.to validate_presence_of(:password).on(:create)}
    it {is_expected.to validate_length_of(:password).is_at_least(PASSWORD_LENGTH_MIN).is_at_most(PASSWORD_LENGTH_MAX)}
    it {is_expected.to allow_value("abcd@1234").for(:password)}
    it {is_expected.to_not allow_value("abcdefg@").for(:password)}
    it {is_expected.to_not allow_value("abcdefg1").for(:password)}
    it {is_expected.to_not allow_value("abcde@1").for(:password)}
  end
end
