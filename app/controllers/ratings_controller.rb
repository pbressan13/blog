class RatingsController < ApplicationController
  def create
    rating = Rating.create!(rating_params)
    avg_rating = rating.post.average_rating

    render json: { average_rating: avg_rating }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def rating_params
    params.permit(:post_id, :user_id, :value)
  end
end
