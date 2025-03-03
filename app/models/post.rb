# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings, dependent: :destroy

  validates :title, :body, :ip, presence: true

  def average_rating
    ratings.average(:value).to_f.round(2).presence || 0
  end
end
