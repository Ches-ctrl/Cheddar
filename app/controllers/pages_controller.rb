class PagesController < ApplicationController
  skip_before_action :authenticate_user! # , only: %i[home faqs how_it_works about landing privacy ts_and_cs protocol]

  def about; end

  def climate; end

  def faqs; end

  def home; end

  def how_it_works; end

  def landing; end

  def privacy; end

  def protocol; end

  def ts_and_cs; end
end
