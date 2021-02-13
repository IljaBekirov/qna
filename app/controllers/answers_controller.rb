class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update edit mark_as_best]
  before_action :find_question, only: [:create]
  before_action :find_answer, only: %i[show destroy update mark_as_best edit]
  before_action :load_answers, only: %i[create update]

  def show; end

  def new; end

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.js { flash[:notice] = 'Your answer successfully created.' }
      else
        format.js { flash[:alert] = 'Your have an errors!' }
      end
    end
  end

  def update
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
    load_answers
  end

  private

  def load_answers
    @question ||= @answer.question
    @best_answer ||= @question.best_answer
    @other_answers ||= @question.other_answers
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
