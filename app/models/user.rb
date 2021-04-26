class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         # :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  def author_of?(object)
    id == object.user_id
  end

  def subscribed_of?(object)
    object.subscriptions.where(user: self).exists?
  end
end
