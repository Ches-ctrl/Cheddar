class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home faqs how_it_works about landing privacy ts_and_cs]

  def home
  end

  def about
  end

  def faqs
  end

  def how_it_works
  end

  def climate
  end

  def landing
  end

  def privacy
  end

  def ts_and_cs
  end
end
