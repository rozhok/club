class IntrosController < ApplicationController
  def new
    authorize! :create, Post
    if user.newcomer?
      @post = Post.new
    else
      redirect_to root_path
    end
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :update, @post
  end

  def create
    authorize! :create, Post
    if !user.newcomer?
      redirect_to root_path
      return
    end
    @post = Post.new(post_params)
    @post.post_type = "intro"
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

  def post_params
    params.expect!(post: [:content, :title])
  end
end
