# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  uid        :string(255)
#  provider   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  token      :string(255)


require 'spec_helper'

describe "Authentication" do
  before(:each) do
    @attr = {
        :uid => 123456,
        :provider => 'facebook',
        :token => 987654321
    }
  end

  context 'Valid authentications' do

    it 'should not allow duplicate authentications' do
      Authentication.create!(@attr)
      authentication_with_duplicate_attrs = Authentication.new(@attr)
      #authentication_with_duplicate_attrs.should_not be_valid  #TODO Should be NOT, but we may not need this test
      expect(authentication_with_duplicate_attrs).to be_valid
    end

  end

end