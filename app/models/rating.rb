# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :value, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :post_id, message: 'post only can be rated 1 time' }
end
