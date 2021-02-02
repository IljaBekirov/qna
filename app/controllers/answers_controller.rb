class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: %i[show destroy update]

  def show; end

  def new; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    end
  end

  def update
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        flash[:notice] = 'Your answer is updated'
        redirect_to question_path(@answer.question)
      else
        flash[:error] = 'Answer is not updated'
        render :edit
      end
    else
      flash[:error] = 'You are not author of this answer'
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted!'
      redirect_to @answer.question
    else
      flash[:error] = 'You are not author of this answer'
      render 'questions/show'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
