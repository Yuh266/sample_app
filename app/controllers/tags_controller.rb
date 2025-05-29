class TagsController < ApplicationController
  def show
    @tag = Tag.find_by(id: params[:id])
    if @tag
      @microposts = @tag.microposts.paginate(page: params[:page])
    else
      redirect_to root_url, alert: "Tag not found"
    end
  end

  def search
    query = params[:q].to_s.strip.downcase
    @tags = Tag.where("LOWER(name) LIKE ?", "#{query}%").limit(5) 
    render json: @tags.pluck(:name)
  end
  
end


