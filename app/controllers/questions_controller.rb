class QuestionsController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:round_id])
    @question = @round.questions.find(params[:id])
    @answers = @question.answers
  end

  def submit_answer
    # @game = Game.find(params[:game_id])
    @question = Question.find(params[:id])
    @round = @question.round
    @game = @round.game

    if current_user == @game.current_player.user
      @game_player = @game.current_player
    else
      @game_player = @game.opponent_player
    end
 

    @game_player.play_count += 1
    selected_answer = Answer.find(params[:answer_id])

    @question.answers.each do |answer|
      @correct_answer = answer if answer.decoy == false
    end

    # Update the game state based on the selected answer

    @game_player.score += 1 if selected_answer == @correct_answer

    @game_player.save

    @next_round = @game.rounds.find_by(round_number: @round.round_number + 1)

    # Redirect to the next round or to the games list
    if @next_round
      redirect_to game_round_path(@game, @next_round)
    else
      @game_player.update(played: true)
      # winner! method

      if @game.complete?
        @game.winner!
        Turbo::StreamsChannel.broadcast_update_to(
          "winner_game_#{@game.id}",
          target: "winner_game_#{@game.id}",
          partial: "games/winner", locals: { game: @game }
        )
      end
      redirect_to results_game_path(@game)
    end
  end
end

# class QuestionsController < ApplicationController
#   def show
#     @questions = Question.find(params[:id])
#     @answers = @questions.answers
#     @game = Game.find(params[:game_id])
#     @round = @game.rounds.find(params[:round_id])
#     @question = @round.questions.find(params[:id])
#   end

#   # def answer
#   #   @game = Game.find(params[:game_id])
#   #   @round = Round.find(params[:round_id])
#   #   @question = Question.find(params[:id])
#   #   @answer = Answer.find(params[:answer_id])
#   # end
#   def submit_answer
#     # @game = Game.find(params[:game_id])
#     @question = Question.find(params[:id])
#     @round = @question.round
#     @game = @round.game
#     raise
#     # selected_answer = Answer.find(params[:answer_id])

#     # if selected_answer.correct?
#     #   @game_player = @game.game_players.find_by(user: current_user)
#     #   # update their score
#     # end

#     @next_round = @game.rounds.find_by(round_number: @round.round_number + 1)

#     # create an answer
#     if @next_round
#       redirect_to game_round_path(@game, @next_round)
#     else
#       redirect_to games_path
#     end
#   end
# end
