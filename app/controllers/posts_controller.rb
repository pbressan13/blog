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

  private

  def post_params
    params.require(:post).permit(:title, :body, :ip)
  end

  def user_params
    params.require(:user).permit(:login)
  end
end
