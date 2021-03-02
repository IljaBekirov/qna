module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_votable, :check_current_user, only: %i[vote_up vote_down vote_cancel]
  end

  def vote_up
    @votable.vote_up(current_user)
    render_json
  end

  def vote_down
    @votable.vote_down(current_user)
    render_json
  end

  def vote_cancel
    @votable.cancel_vote_of(current_user) if Vote.where(votable: @votable).exists?(user: current_user)
    render_json
  end

  private

  def check_current_user
    return render_unauthorized if current_user.blank?

    render_forbidden if current_user.author_of?(@votable)
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def render_unauthorized
    render json: { error: "You need to sign in or sign up before continuing." }, status: :unauthorized
  end

  def render_forbidden
    render json: { message: "You're not author" }, status: :forbidden
  end

  def render_json
    render json: {
      resourceName: @votable.class.name.downcase,
      resourceId: @votable.id,
      rating: @votable.rating
    }
  end
end
