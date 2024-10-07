class RoundsController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    @round = Round.find(params[:id])
    @question = @round.question
    @answers = @question.answers
    @game_player = @game.game_players.where(user: current_user)
    # # selected_answer = Answer.find(params[:answer_id])

    # if selected_answer.correct?
    #   @game_player = @game.game_players.find_by(user: current_user)
    # end
    # next_round = Round.where('id > ?', @round.id).first
    @next_round = @game.rounds.find_by(round_number: @round.round_number + 1)

    # if next_round
    #   redirect_to game_round_path(@game, next_round)
    # else
    #   redirect_to games_path
    # end
  end
end
