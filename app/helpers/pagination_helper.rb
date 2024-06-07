module PaginationHelper
  def pagy_next(pagy)
    pagy_url_for(pagy, pagy.next, absolute: false)
  end

  def pagy_prev(pagy)
    pagy_url_for(pagy, pagy.prev, absolute: false)
  end
end
