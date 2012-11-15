class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id
    # Relations
  belongs_to :user
end
