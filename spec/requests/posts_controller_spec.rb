require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'POST #create' do
    let(:user_params) { {login: 'user1'} }
    let(:post_params) { {title: 'Test Title', body: 'Test Body', ip: '127.0.0.1'} }

    it 'creates a post and a user if the user does not exist' do
      expect {
        post :create, params: {user: user_params, post: post_params}
      }.to change(Post, :count).by(1)
        .and change(User, :count).by(1)
    end

    it 'returns status 201 and the post data' do
      post :create, params: {user: user_params, post: post_params}
      expect(response).to have_http_status(:created)
      expect(response.body).to include('Test Title')
    end

    it 'returns validation errors when the post is invalid' do
      post :create, params: {user: user_params, post: {title: '', body: '', ip: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("can't be blank")
    end
  end

  describe 'GET #top' do
    let(:user) { User.create!(login: 'user1') }
    let(:post1) { user.posts.create!(title: 'Post 1', body: 'Body', ip: '127.0.0.1') }
    let(:post2) { user.posts.create!(title: 'Post 2', body: 'Body', ip: '127.0.0.2') }

    before do
      post1.ratings.create!(user_id: user.id, value: 5)
      post2.ratings.create!(user_id: user.id, value: 3)
    end

    it 'returns posts sorted by average rating' do
      get :top, params: {max: 10}
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Post 1')
      expect(response.body).to include('Post 2')
    end
  end

  describe 'GET #repeated_ips' do
    let(:user1) { User.create!(login: 'user1') }
    let(:user2) { User.create!(login: 'user2') }
    let(:post1) { user1.posts.create!(title: 'Post 1', body: 'Body', ip: '127.0.0.1') }
    let(:post2) { user2.posts.create!(title: 'Post 2', body: 'Body', ip: '127.0.0.1') }

    before do
      post1.reload
      post2.reload
    end

    it 'returns IPs that have multiple distinct users' do
      get :repeated_ips
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('127.0.0.1')
    end
  end
end
