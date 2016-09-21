class ResultsController < ApplicationController
  # GET /results
  def index
    render json: Game.find(params[:game_id]).results
  end

  # POST /results
  def create
    @result = Game.find(result_params[:game_id]).results.new(result_params)

    if @result.save
      render json: @result, status: :created, location: game_results_path(@result.game)
    else
      render json: @result.errors, status: :unprocessable_entity
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def result_params
    params.require(:result).permit(:game_id, :name, :organisation, :correct_count, :score,
                                   answers: [:question_id, :answer])
  end
end
