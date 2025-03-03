require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:user) }
  it { should have_many(:ratings).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:ip) }

  describe '#average_rating' do
    it 'returns the average rating rounded to two decimal places' do
      user = User.create!(login: 'user1')
      user2 = User.create!(login: 'user2')
      post = user.posts.create!(title: 'Title', body: 'Body', ip: '127.0.0.1')

      post.ratings.create!(user_id: user.id, value: 3)
      post.ratings.create!(user_id: user2.id, value: 5)

      expect(post.average_rating).to eq(4.0)
    end

    it 'returns 0 if there are no ratings' do
      user = User.create!(login: 'user1')
      post = user.posts.create!(title: 'Title', body: 'Body', ip: '127.0.0.1')

      expect(post.average_rating).to eq(0.0)
    end
  end
end
