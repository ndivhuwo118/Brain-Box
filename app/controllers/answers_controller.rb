class AnswersController < ApplicationController

  def create
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:round_id])
    @question = @round.questions.find(params[:question_id])
    # @answer = @question.answers.find(params[:answer_id])
    # if @answer.correct?
    @next_round = @game.rounds.find_by(round_number: @round.round_number + 1)

    if @next_round
      redirect_to game_round_path(@game, @next_round)
    else
      redirect_to games_path
    end
  end

  def select
    @game = Game.find(params[:game_id])
    @round = Round.find(params[:round_id])
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])

    redirect_to game_round_path(@game, @round), notice: 'Your answer has been recorded.'
  end
end
