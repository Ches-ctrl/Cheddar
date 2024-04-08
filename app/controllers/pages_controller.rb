class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home test faqs how_it_works about jobs landing privacy ts_and_cs]

  def home
  end

  def test
  end

  def faqs
  end

  def how_it_works
  end

  def jobs
  end

  def temp
  end

  def climate
  end

  def landing
  end

  def about
  end

  def privacy
  end

  def ts_and_cs
  end
end
