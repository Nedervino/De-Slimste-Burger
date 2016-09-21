class GamesController < ApplicationController
  def show
    render json: Game.find(params[:id])
  end

  def create
    game = Game.new
    if game.save!
      render json: game, status: :created
    end
  end
end
