# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  describe 'POST #create' do
    let(:user) { User.create!(login: 'user1') }
    let(:post_instance) { user.posts.create!(title: 'Post', body: 'Body', ip: '127.0.0.1') }

    it 'creates a rating and returns the average rating' do
      post :create, params: { post_id: post_instance.id, user_id: user.id, value: 4 }
      expect(response).to have_http_status(:created)
      expect(response.body).to include('average_rating')
    end

    it 'returns an error if the rating is invalid' do
      post :create, params: { post_id: post_instance.id, user_id: user.id, value: 6 }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('is not included in the list')
    end

    it 'prevents a user from rating the same post more than once' do
      post :create, params: { post_id: post_instance.id, user_id: user.id, value: 4 }
      post :create, params: { post_id: post_instance.id, user_id: user.id, value: 5 }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('post only can be rated 1 time')
    end
  end
end
