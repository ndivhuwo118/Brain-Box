class SetRoundsJob < ApplicationJob
  queue_as :default

  def perform(game)
    round_number = 1
    3.times do
      round = Round.new(round_number: round_number, game_id: game.id)
      round.save!
      puts "#{round.id} round created"

      round_number += 1
    end
    # Do something later
  end
end
