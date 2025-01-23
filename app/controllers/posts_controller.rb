class PostsController < ApplicationController
  include Authentication
  skip_before_action :authenticate_request!, only: [ :index, :show ]
  before_action :authenticate_request!, only: [ :create, :destroy ]

  def index
    posts = Post.all
    render json: posts
  end

  def show
    post = Post.find(params[:id])
    render json: post
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post not found" }, status: :not_found
  end

  def create
    post = current_user.posts.new(post_params)
    post.media.attach(params[:media]) if params[:media]
    if post.save
      render json: post, status: :created
    else
      render json: { error: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      render json: @post
    else
      render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
    end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Post not found" }, status: :not_found
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Post not found" }, status: :not_found
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
