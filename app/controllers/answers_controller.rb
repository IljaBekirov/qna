class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update edit mark_as_best]
  before_action :find_question, only: [:create]
  before_action :find_answer, only: %i[show destroy update mark_as_best edit]

  def show; end

  def new; end

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    answers
    respond_to do |format|
      if @answer.save
        format.js { flash[:notice] = 'Your answer successfully created.' }
      else
        format.js { flash[:alert] = 'Your have an errors!' }
      end
    end
  end

  def update
    @question = @answer.question
    answers
    if current_user.author_of?(@answer)
      respond_to do |format|
        if @answer.update(answer_params)
          format.js { flash[:notice] = 'Your answer is updated' }
        else
          format.js { flash[:error] = 'Answer is not updated' }
        end
      end
    else
      flash[:error] = 'You are not author of this answer'
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def mark_as_best
    @question = @answer.question
    @question.mark_as_best(@answer) if current_user.author_of?(@question)
    answers
  end

  private

  def answers
    @best_answer = @question.answers.where(id: @question.best_answer_id)
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

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
