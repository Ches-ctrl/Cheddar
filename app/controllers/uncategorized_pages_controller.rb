# frozen_string_literal: true

class UncategorizedPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def tothemoon; end
end
