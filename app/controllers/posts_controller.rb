class PostsController < ApplicationController
  def create
    user = User.find_or_create_by!(login: user_params[:login])
    post = user.posts.create!(
      title: post_params[:title],
      body: post_params[:body],
      ip: post_params[:ip]
      )
      render json: post.as_json(include: :user), status: :created
  rescue ActiveRecord::RecordInvalid => error
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def top
    top_posts = Post.left_joins(:ratings)
    .select("posts.id, posts.title, posts.body, AVG(ratings.value) AS average_rating")
    .group(:id)
    .order(Arel.sql("AVG(ratings.value) DESC NULLS LAST"))
    .limit(params[:max].to_i)

    top_posts = top_posts.map do |post|
      {
        id: post.id,
        title: post.title,
        body: post.body,
        average_rating: post.average_rating
      }
    end

    render json: top_posts
  end

  def repeated_ips
    ips = Post.select(:ip, "array_agg(DISTINCT users.login) AS logins")
              .joins(:user)
              .group(:ip)
              .having("COUNT(DISTINCT user_id) > 1")
              .order(Arel.sql("count(DISTINCT users.login) DESC"))

    repeated_ips = ips.map do |post|
      {
        ip: post.ip,
        logins: post.logins
      }
      end

    render json: repeated_ips
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :ip)
  end

  def user_params
    params.require(:user).permit(:login)
  end
end
