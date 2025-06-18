class PostsController < ApplicationController
  def index
    @posts = Post.all.with_rich_text_content_and_embeds
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.where(parent_id: nil).includes(:user, :replies)
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = Current.user.id
    if @post.save
      redirect_to post_path(@post.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def post_params
    params.expect!(post: [:content])
  end
end
