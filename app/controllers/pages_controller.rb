class PagesController < ApplicationController

  def boxers
    @boxers = User.all.order('nickname ASC')
  end

end
