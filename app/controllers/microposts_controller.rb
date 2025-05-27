class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create 
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    

    if @micropost.save
      
      ActionCable.server.broadcast "microposts_channel", {
        html: render_to_string(partial: "microposts/micropost", locals: { micropost: @micropost })
      }
      head :ok 
      return
    else 
      @feed_items = current_user.feed.order(id: :desc).paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end
  
  def destroy
    @micropost.destroy
    
    ActionCable.server.broadcast "microposts_channel", {
      action: "destroy",
      micropost_id: @micropost.id
    }
    # redirect_back_or_to(root_url)
    # if request.referrer.nil?
      # redirect_to root_url, status: :see_other
    # else
      # redirect_to request.referrer, status: :see_other
    # end
  end
  
  private

  def micropost_params
    params.require(:micropost).permit(
      :content, :image,
      taggings_attributes: [
        :id, :_destroy,
        tag_attributes: [:name]
      ]
    )
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

end
