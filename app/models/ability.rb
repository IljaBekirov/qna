# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_ability : user_ability
    else
      guest_ability
    end
  end

  private

  def guest_ability
    can :read, :all
  end

  def admin_ability
    can :manage, :all
  end

  def user_ability
    guest_ability

    can :index, User
    can :me, User

    can :create, [Question, Answer, Comment]

    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end

    can :destroy, Link, linkable: { user_id: user.id }

    can :mark_as_best, Answer, question: { user_id: user.id }

    can %i[vote_up vote_down], [Answer, Question] do |votable|
      !user.author_of?(votable)
    end

    can :vote_cancel, [Answer, Question] do |votable|
      votable.votes.find_by(user: user).present?
    end
  end
end
