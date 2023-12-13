class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :test, :faqs, :how_it_works, :about]

  def home
  end

  def test
  end

  def faqs
  end

  def how_it_works
  end
end
