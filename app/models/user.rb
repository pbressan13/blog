# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :login, presence: true, uniqueness: true
end
