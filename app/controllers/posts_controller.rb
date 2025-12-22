class PostsController < ApplicationController
  # rescue_from AccessGranted::AccessDenied, with: :access_denied
  def index
    authorize! :read, Post
    @posts = Post.includes(user: { avatar_attachment: :blob }).order(updated_at: :desc)
  end

  def show
    authorize! :read, Post
    @post = Post.with_rich_text_content_and_embeds.find(params[:id])
    @comments = @post.replies
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
      redirect_to post_path(@post.id)
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post
    if @post.update(post_params)
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

  # def access_denied
  #   if Current.user&.newcomer?
  #     redirect_to profile_edit_path
  #   end
  # end

  def post_params
    params.expect!(post: [:content, :title])
  end
end
