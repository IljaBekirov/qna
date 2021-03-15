class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]
  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer = Answer.new
    @answer.links.new
    set_gon
    @comment = Comment.new
  end

  def new
    @question = Question.new
    @question.links.new # .build
    @question.build_reward
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

  def set_gon
    gon.question_id = @question.id
    gon.current_user_id = current_user&.id
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: {
          question: @question,
          current_user: current_user
        }
      )
    )
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[id name url _destroy done],
                                                    reward_attributes: %i[id title image])
  end
end
