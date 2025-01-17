class PostsController < ApplicationController
  include Authentication

  before_action :authenticate_request, only: [:create, :destroy]

  def index 
    posts = Post.all
    render json: posts
  end

  def show
    post = Post.find(params[:id])
    render json: post
  end

  def create  
    post = Post.new(post_params)
    post.media.attach(params[:media]) if params[:media]
    if post.save
      render json: post, status: :created
    else
      render json: { error: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
