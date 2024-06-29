# frozen_string_literal: true

class UncategorizedPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def tothemoon; end

  def about; end

  def contact; end

  def privacy; end

  def terms; end

  def howitworks; end

  def pricing; end
end
