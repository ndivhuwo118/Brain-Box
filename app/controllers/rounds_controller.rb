class RoundsController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:id])
    @question = @round.questions.first

    selected_answer = Answer.find(params[:answer_id])

    if selected_answer.correct?
      @game_player = @game.game_players.find_by(user: current_user)
    end

    next_question = @round.questions.where('id > ?', @question.id).first

    if next_question
      redirect_to game_round_question_path(@game, @round, next_question)
    else
      next_round = Round.where('id > ?', @round.id).first
      if next_round
        redirect_to game_round_question_path(@game, next_round, next_round.questions.first)
      else
        redirect_to game_over_path(@game)
      end
    end
  end

  def create
  end

  def answer
    @game = Game.find(params[:game_id])
    @round = Round.find(params[:round_id])
    @question = Question.find(params[:question_id])

    selected_answer = Answer.find(params[:answer_id])

    if selected_answer.correct?
      @game_player = @game.game_players.find_by(user: current_user)
    end

    next_question = @round.questions.where('id > ?', @question.id).first

    if next_question
      redirect_to game_round_question_path(@game, @round, next_question)
    else
      next_round = Round.where('id > ?', @round.id).first
      if next_round
        redirect_to game_round_question_path(@game, next_round, next_round.questions.first)
      else
        redirect_to game_over_path(@game)
      end
    end
  end
end
