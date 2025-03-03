# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should belong_to(:post) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:value) }
  it { should validate_inclusion_of(:value).in_range(1..5) }

  describe 'validate post only can be rated 1 time' do
    let(:user) { User.create!(login: 'user1') }
    let(:post) { user.posts.create!(title: 'Title', body: 'Body', ip: '127.0.0.1') }

    it 'does not allow the same user to rate the same post more than once' do
      Rating.create!(user: user, post: post, value: 5)
      not_valid_rating = Rating.new(user: user, post: post, value: 2)

      # Expect the validation to fail
      expect(not_valid_rating).not_to be_valid
      expect(not_valid_rating.errors[:user_id]).to include('post only can be rated 1 time')
    end
  end
end
