class OauthIdentity < ActiveRecord::Base
  belongs_to :user
end