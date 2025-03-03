# frozen_string_literal: true

class RatingsController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      rating = Rating.find_or_initialize_by(rating_params)
      if rating.new_record?
        rating.save!
      else
        render json: { errors: ['Post can only be rated once per user'] }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end

      avg_rating = rating.post.average_rating

      render json: { average_rating: avg_rating }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def rating_params
    params.permit(:post_id, :user_id, :value)
  end
end
