# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :oauth_identities
  has_many :alarms

  accepts_nested_attributes_for :oauth_identities

  before_validation -> { generate_unique_token_for(:oauth_token) }, on: :create

  def self.from_oauth(provider, params)
    if params[:oauth_token]
      user = User.find_by_oauth_token(params[:oauth_token])
    else
      find_or_create_user_from_oauth(provider, params)
    end
  end

  def self.find_or_create_user_from_oauth(provider, params)
    find_user_from_oauth(provider, params) ||
      create_user_from_oauth(provider, params)
  end

  def self.find_user_from_oauth(provider, params)
    identity = OauthIdentity.find_by(provider: provider, uid: params[:oauth_identities][:uid])

    if identity.present?
      identity.user.tap { |user| user.reset_oauth_token! }
    else
      nil
    end
  end

  def self.create_user_from_oauth(provider, params)
    identity = OauthIdentity.new(params[:oauth_identities].merge(provider: provider))

    if FacebookOauth.valid_identity?(identity)
      user = User.new(params.except(:oauth_identities).merge(password: Devise.friendly_token))

      User.transaction do
        user.save!
        identity.user = user
        identity.save!
      end

      user
    else
      false
    end
  end

  def reset_oauth_token!
    generate_unique_token_for(:oauth_token)
    self.save!
    self.oauth_token
  end

  private

  def generate_unique_token_for(field)
    token = Devise.friendly_token + Devise.friendly_token

    while self.class.exists?(field => token)
      token = Devise.friendly_token + Devise.friendly_token
    end

    self.send("#{field}=", token)
  end
end
