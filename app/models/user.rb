# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                    class_name: "Relationship",
                                    dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { self.email.downcase! }
  before_save :create_remember_token
  before_save :create_confirmation_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
  									format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false }

  #validates_uniqueness_of :email, case_sensitive: false
 	validates :password, presence: true, length: { minimum: 6 }, on: :create
 	validates :password_confirmation, presence: true, on: :create

  default_scope order: 'users.created_at DESC'

  def feed
    Micropost.from_users_followed_by(self)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def send_password_reset
    create_password_reset_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

 	private
 	
	 	def create_remember_token
	 		self.remember_token = SecureRandom.urlsafe_base64
	 	end

    def create_password_reset_token
      self.password_reset_token = SecureRandom.urlsafe_base64
    end

    def create_confirmation_token
      self.confirmation_token = SecureRandom.urlsafe_base64
    end
end