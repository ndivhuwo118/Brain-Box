class PagesController < ApplicationController

  def boxers
  @boxers = User.all
  end

end
