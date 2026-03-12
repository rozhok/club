class IntrosController < ApplicationController
  def new
    authorize! :create, Intro
    if current_user.intro.present?
      redirect_to post_path(current_user.intro)
    else
      @intro = Post.new(title: "Інтро: #{Current.user.name}")
    end
  end

  def edit
    @intro = Post.find(params[:id])
    authorize! :update, @intro
  end

  def create
    authorize! :create, Intro
    if current_user.intro.present?
      redirect_to root_path
      return
    end
    @intro = Post.new(post_params)
    @intro.post_type = "intro"
    @intro.title = "Інтро: #{Current.user.name}"
    @intro.user_id = Current.user.id
    @intro.state = :pending
    if @intro.save
      redirect_to post_path(@intro.id)
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @intro = Post.find(params[:id])
    authorize! :update, @intro
    if @intro.update(post_params)
      redirect_to post_path(@intro.id)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def post_params
    params.expect!(intro: [:content, :title])
  end
end
