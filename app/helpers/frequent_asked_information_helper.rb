module FrequentAskedInformationHelper
  def frequent_asked_information_button_title
    if current_controller?('registrations')
      "Save"
    else
      "Next"
    end
  end
end
