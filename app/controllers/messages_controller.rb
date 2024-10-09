class MessagesController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @message = Message.new(message_params)
    @message.game = @game
    @message.user = current_user
    if @message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:messages, partial: "messages/message", locals: { message: @message, user: current_user })
        end
        format.html { redirect_to game_path(@game) }
      end
    else
      render "games/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
