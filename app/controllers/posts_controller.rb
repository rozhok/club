class PostsController < ApplicationController
  skip_before_action :authenticate, only: :show
  before_action :authenticate_for_external, only: :show
  def index
    authorize! :read, Post.new
    @posts = Post.where(state: ["approved"]).includes(user: { avatar_attachment: :blob }).order(updated_at: :desc)
    if current_user.moderator?
      @posts = @posts.or(Post.where(state: "pending"))
    end
  end

  def show
    @post = Post.with_rich_text_content_and_embeds.find(params[:id])
    if Current.user && (can? :read, @post)
      @comments = @post.replies
    else
      render :show_external
    end
  end

  def new
    authorize! :create, Post
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :update, @post
  end

  def create
    authorize! :create, Post
    @post = Post.new(post_params)
    @post.user_id = Current.user.id
    if @post.save
      if params[:publish]
        @post.publish_or_send_to_review
      end
      GeneratePostOgImageJob.perform_later(@post.id)
      redirect_to post_path(@post.id)
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post
    if @post.update(post_params)
      if params[:publish]
        @post.publish_or_send_to_review
      end
      GeneratePostOgImageJob.perform_later(@post.id)
      redirect_to post_path(@post.id)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize! :destroy, @post
    @post.destroy
    redirect_to posts_path
  end

  def approve
    @post = Post.find(params[:id])
    authorize! :approve, @post
    @post.approve
    redirect_to post_path(@post)
  end

  def reject
    @post = Post.find(params[:id])
    authorize! :reject, @post
    @post.reject
    redirect_to post_path(@post)
  end

  def post_params
    params.expect!(post: [:content, :title, :post_type, :link])
  end
end
