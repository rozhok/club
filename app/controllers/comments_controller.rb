class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_parent, only: %i[show new create]

  def index
    @comments = @post.comments.with_rich_text_content_and_embeds.where(parent_id: nil)
  end

  def show
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = Current.user
    @comment.parent = @parent
    @comment.save
  end

  def update
    @comment.update(comment_params)
  end

  def destroy
    @comment.destroy
  end

  def reply
    @reply = @comment.replies.new(comment_params)
    @reply.post = @comment.post
    @reply.user = Current.user

    if @reply.save
      redirect_to post_path(@comment.post), notice: "Reply was successfully added."
    else
      redirect_to post_path(@comment.post), alert: "Failed to add reply."
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_parent
    @parent = Comment.find_by(id: params[:parent_id])
  end

  def comment_params
    params.expect(comment: [:content])
  end
end
