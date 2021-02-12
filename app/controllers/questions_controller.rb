class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id]) if current_user.author_of?(@question)
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash[:notice] = 'Your answer is updated'
        redirect_to @question
      else
        flash[:error] = 'Question is not updated'
        render :edit
      end
    else
      flash[:error] = 'You are not author of this question'
      redirect_to questions_path
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully deleted!'
      redirect_to questions_path
    else
      flash[:error] = 'You are not author of this question'
      redirect_to questions_path
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
