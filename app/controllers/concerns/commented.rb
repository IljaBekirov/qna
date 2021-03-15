module Commented
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :setup_resource, only: [:add_comment]
    after_action :publish_comment, only: [:add_comment]
  end

  def add_comment
    @comment = @commented.comments.new(comment_params)
    @comment.user = current_user
    respond_to { |format| format.js { render partial: 'comments/add_comment', layout: false } if @comment.save }
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def setup_resource
    @commented = model_klass.find(params[:id])
  end

  def publish_comment
    return if @commented.errors.any?

    ActionCable.server.broadcast(
      'comments',
      comment: @comment,
      author: current_user.email
    )
  end
end
