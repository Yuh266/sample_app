class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @micropost.taggings.build.build_tag 
      @feed_items = current_user.feed.order(id: :desc).paginate(page: params[:page], per_page: 10)
    end

  end

  def help
  end

  def about
  end

  def contact
  end

end
