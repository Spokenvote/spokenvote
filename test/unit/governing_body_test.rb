# == Schema Information
#
# Table name: governing_bodies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  location    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class GoverningBodyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
