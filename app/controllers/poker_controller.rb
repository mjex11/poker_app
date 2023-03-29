class PokerController < ApplicationController
  def index; end

  def submit
    result = PokerService.new(params[:cards]).call
    if result[:errors]
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    else
      render json: { hand: result[:hand] }, status: :ok
    end
  end
end
