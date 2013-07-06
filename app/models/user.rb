# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  # attr_accessible :title, :body

  # Associations
  has_many :authentications, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :proposals, dependent: :destroy  # Created by user
  has_many :voted_proposals, through: :votes, source: :proposal  # Voted by user

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def username
    self.name.presence || self.email.split('@').first.titlecase
  end

  def is_admin?
    self.email && ENV['ADMIN_EMAILS'].to_s.downcase.include?(self.email)
  end

  def facebook_auth
    if authentications.any?
      self.authentications.first.uid
    end
  end

  def gravatar_hash
    Digest::MD5.hexdigest(self.email.downcase)
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0,20]
      )
    end
    user
  end


  def self.from_omniauth(any_existing_user, auth) # TODO Pratik, slick Ryan Bates way of creating the user on the fly if you want to try it.
    where(id: any_existing_user).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      #user.username = auth.name
      user.save!
    end
  end


end