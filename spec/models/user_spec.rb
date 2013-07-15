# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#

require 'spec_helper'

describe "Authenticate User" do  #TODO Need some help here understanding if I'm really testing the full Authentications controller, as I don't understand how to pass things to the controller itself.
  before(:each) do
    @auth = {
      provider: 'facebook',
      uid: '88888888',
      token: '999999999',
      name: Faker.name,
      email: Faker::Internet.email,
    }
  end

  it 'should create a new user' do
    user = User.from_omniauth(nil, @auth)
    user.should be_valid
    user.should be_persisted
  end

  it 'should authenticate a new user' do
    user = User.from_omniauth(nil, @auth)
    userauth = user.authentications.create(:provider => @auth[:provider], :uid => @auth[:uid], :token => @auth[:token])
    userauth.should be_valid
    userauth.should be_persisted
  end

  #it 'should not authenticate bad auth data' do
  #  user = User.from_omniauth(nil, @auth)
  #  # TODO Line below won't run for the exact failure I'm trying to test for.
  #  userauth = user.authentications.create(:provider => nil, :uid => @auth[:uid], :token => @auth[:token])
  #  userauth.should_not be_valid
  #end

  #it 'should not authenticate bad auth data' do
  #  user = User.from_omniauth(nil, @auth)
  #  userauth = user.authentications.create(:provider => nil, :uid => @auth[:uid], :token => @auth[:token]) unless authentication
  #  userauth.should_not be_valid
  #  userauth.should_not be_persisted
  #end

end

describe "User" do
  before(:each) do
    @attr = {
      :name => Faker.name,
      :email => Faker::Internet.email,
      :password => "secret",
      :password_confirmation => "secret",
    }
  end

  it "should create a new user given valid attributes" do
    user = User.new(@attr)
    user.should be_valid
    user.save.should be_true
  end

  it "should NOT require an email address" do
    no_email_user = User.new(@attr.merge(:email => nil))
    no_email_user.should be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should ACCEPT multiple NULL email addresses" do
    User.new(@attr.merge(:email => nil))
    user_with_duplicate_null_email = User.new(@attr.merge(:email => nil))
    user_with_duplicate_null_email.should be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do
    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  #
  #describe "password validations" do          # Depreciating due to Facebook-only strategy
  #  it "should require a password" do         # TODO Pratik, please remove if you agree.
  #    User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
  #  end
  #
  #  it "should require a matching password confirmation" do
  #    User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
  #  end
  #
  #  it "should reject short passwords" do
  #    short = "a" * 5
  #    hash = @attr.merge(:password => short, :password_confirmation => short)
  #    User.new(hash).should_not be_valid
  #  end
  #end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
  end

  describe 'associations' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:hub) { create(:hub) }
    let!(:proposal1) { create(:proposal, user: user2, hub: hub) }
    let!(:proposal2) { create(:proposal, user: user2, hub: hub) }
    let!(:proposal3) { create(:proposal, user: user1, hub: hub) }
    let!(:vote1) { create(:vote, proposal: proposal1, user: user1) }
    let!(:vote2) { create(:vote, proposal: proposal2, user: user1) }

    describe '#voted_proposals' do
      it 'gives list of proposals that the user voted on' do
        user1.voted_proposals.should match_array([proposal1, proposal2])
      end
    end

    describe '#proposals' do
      it 'gives list of proposals created by the user' do
        user1.proposals.should match_array([proposal3])
        user2.proposals.should match_array([proposal1, proposal2])
      end
    end
  end
end
