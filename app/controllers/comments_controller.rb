class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = params[:parent_id] if params[:parent_id] # Gán parent_id nếu có
    @comment.image.attach(params[:comment][:image]) if params[:comment][:image]

    if @comment.save
      flash[:success] = "Comment added!"
    else
      flash[:danger] = "Comment could not be added."
    end
    redirect_to micropost_path(@micropost)
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      flash[:success] = "Comment deleted"
    else
      flash[:danger] = "You are not authorized to delete this comment."
    end
    redirect_to micropost_path(@comment.micropost)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id, :image)
  end
end
