class CommentsController < ApplicationController
  def index
    @comments = @post.comments.includes(user: { avatar_attachment: :blob }).with_rich_text_content_and_embeds.where(parent_id: nil)
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    @parent_id = params[:parent_id]
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    @post = Post.find(params[:post_id])
    @post.transaction do
      @comment = @post.comments.create(comment_params)
      @comment.user_id = Current.user.id
      if comment_params[:parent_id].present?
        parent = Comment.find(comment_params[:parent_id])
        @comment.level = parent.level + 1
      end
      @comment.save
      @post.update!(comments_count: @post.comments_count + 1)
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  def reply
    @reply = @comment.replies.new(comment_params)
    @reply.level = @comment.level + 1
    @reply.post = @comment.post
    @reply.user = Current.user

    if @reply.save
      redirect_to post_path(@comment.post), notice: "Reply was successfully added."
    else
      redirect_to post_path(@comment.post), alert: "Failed to add reply."
    end
  end

  private

  def comment_params
    params.expect(comment: [:content, :parent_id])
  end
end
