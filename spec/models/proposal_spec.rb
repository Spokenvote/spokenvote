# == Schema Information
#
# Table name: proposals
#
#  id          :integer          not null, primary key
#  statement   :string(255)
#  user_id     :integer
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  votes_count :integer          default(0)
#  ancestry    :string(255)
#  created_by  :integer
#

require 'spec_helper'

describe Proposal do
  it "should work" do
  end
end
