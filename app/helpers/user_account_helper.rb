module UserAccountHelper
  def nav_css(controller, action)
    current_path?(controller, action) ? "text-indigo-600 dark:text-indigo-400" : "text-gray-400 hover:text-indigo-600"
  end

  def current_path?(controller, action)
    current_page?(controller:, action:)
  end
end
