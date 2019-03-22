# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  uid        :string(255)      not null
#  provider   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  token      :string(255)
#

class Authentication < ActiveRecord::Base
    # Relations
  belongs_to :user
end
