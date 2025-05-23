class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = params[:parent_id] if params[:parent_id] # Gán parent_id nếu có
    @comment.image.attach(params[:comment][:image]) if params[:comment][:image].present?

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to micropost_path(@micropost), notice: "Comment added!" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_form", partial: "comments/form", locals: { micropost: @micropost, comment: @comment }) }
        format.html { redirect_to micropost_path(@micropost), alert: "Comment could not be added." }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to micropost_path(@comment.micropost), notice: "Comment deleted" }
      end
    else
      redirect_to micropost_path(@comment.micropost), alert: "You are not authorized to delete this comment."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id, :image)
  end
end
