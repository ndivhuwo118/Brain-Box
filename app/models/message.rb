class Message < ApplicationRecord
  belongs_to :game
  belongs_to :user

  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "game_#{game.id}_messages", partial: "messages/message", locals: { message: self, user: user }
  end
end
