class AnswersController < ApplicationController
  def select
    @game = Game.find(params[:game_id])
    @round = Round.find(params[:round_id])
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])

    redirect_to game_round_path(@game, @round), notice: 'Your answer has been recorded.'
  end

  def new
    @answer = @question.answers.new
    3.times { @question.answers.build}
  end

  def create
    @question = Question.find(params[:question_id])
    @answers = @question.answers.create(answers_params)
    if @answers.any?(&:persisted?)
      redirect_to question_path(@question), notice: "Answer created!"
    else
      render :new, alert: "Answer not saved!"
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:question).permit(answers_attributes: [:content, :decoy])
  end
end
