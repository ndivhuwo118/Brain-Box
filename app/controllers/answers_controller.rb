class AnswersController < ApplicationController

  def create
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:round_id])
    @question = @round.questions.find(params[:question_id])
    @answer = @question.answers.find(params[:answer_id])
    # if @answer.correct?
  end

  def select
    @game = Game.find(params[:game_id])
    @round = Round.find(params[:round_id])
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])

    redirect_to game_round_path(@game, @round), notice: 'Your answer has been recorded.'
  end
end
