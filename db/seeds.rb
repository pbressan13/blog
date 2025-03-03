require "faker"
require "faraday"

# Initialize Faraday connection
connection = Faraday.new(url: 'http://localhost:3000')

# Generate IPs
ips = 50.times.map { Faker::Internet.ip_v4_address }

# Generate names for users 
users = 100.times.map { Faker::Internet.unique.username }

# How many counts are going to be
posts_count = 200

# Create posts, each with a random user and IP address
posts_count.times do
  ip = ips.sample
  user_login = users.sample

  post_params = { 
    user: {
      login: user_login
    },
    post: {
      title: Faker::Lorem.sentence, 
      body: Faker::Lorem.paragraph, 
      ip: ip 
    }
  }

  connection.post('/posts', post_params)
end

puts "Created #{posts_count} posts"

# Fetch all posts (to create ratings)
rated_ratings_post_percentage = 75
sample_posts_count = (posts_count * rated_ratings_post_percentage / 100).to_i
posts = Post.limit(sample_posts_count)
sample_posts = posts.sample(sample_posts_count)

# Ensure users have a unique ID for each vote
users_rated_posts = {}

sample_posts.each do |post|
  # Create a rating only if the user hasn't already rated this post
  user = nil
  # Ensure the user hasn't rated the post yet
  loop do
    user = User.find_by(login: users.sample)
    break if user.present? && (users_rated_posts[user.id].blank? || !users_rated_posts[user.id].include?(post.id))
  end

  rating_params = { 
    post_id: post.id,
    user_id: user.id, 
    value: rand(1..5) 
  }

  # POST request to create rating
  connection.post('/ratings', rating_params)

  # Track that this user has rated this post
  users_rated_posts[user.id] ||= []
  users_rated_posts[user.id] << post.id  
end

puts "Created #{sample_posts_count} ratings"
