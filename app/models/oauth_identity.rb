# == Schema Information
#
# Table name: oauth_identities
#
#  id           :integer          not null, primary key
#  provider     :string           not null
#  uid          :string           not null
#  access_token :string
#  user_id      :integer
#

class OauthIdentity < ActiveRecord::Base
  belongs_to :user
end
