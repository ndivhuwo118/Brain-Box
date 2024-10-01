class PlayersAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :answer
  belongs_to :round
end
