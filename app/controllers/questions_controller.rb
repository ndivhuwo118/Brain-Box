class QuestionsController < ApplicationController
  def show
    @questions = Question.find(params[:id])
    @answers = @questions.answers
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:round_id])
    @question = @round.questions.find(params[:id])
  end

  # def answer
  #   @game = Game.find(params[:game_id])
  #   @round = Round.find(params[:round_id])
  #   @question = Question.find(params[:id])
  #   @answer = Answer.find(params[:answer_id])
  # end
  def submit_answer
    # @game = Game.find(params[:game_id])
    @question = Question.find(params[:id])
    @round = @question.round
    @game = @round.game

    # selected_answer = Answer.find(params[:answer_id])

    # if selected_answer.correct?
    #   @game_player = @game.game_players.find_by(user: current_user)
    #   # update their score
    # end

    @next_round = @game.rounds.find_by(round_number: @round.round_number + 1)

    # create an answer
    if @next_round
      redirect_to game_round_path(@game, @next_round)
    else
      redirect_to games_path
    end

  end
end
