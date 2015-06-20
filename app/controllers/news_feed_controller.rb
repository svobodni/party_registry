class NewsFeedController < ApplicationController
  def index
    @news_feed = Presenters::NewsFeed.all.order(created_at: :desc)
  end
end
