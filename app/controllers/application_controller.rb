class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :on_landing_page?
  before_action :set_tags

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :photo, :resume])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :address_first, :address_second, :city, :post_code, :phone_number, :github_profile_url, :website_url, :photo, :resume, :linkedin_profile, :preferred_pronoun_select, :preferred_pronoun_text, :salary_expectation_figure, :right_to_work, cover_letter_templates: []])
  end

  def user_root_path
    profile_url
  end

  def on_landing_page?
    controller_name == 'pages' && action_name == 'landing'
  end

  def set_tags
    set_meta_tags description: "Simply your job search with our automation job application platform, blending simplicity with a climate-first approach. Streamline your application process and apply for multiple job with just one click on our platform. Kickstart your career with Cheddar - the only site you need to get hired!",
                  keywords: "job, jobs, apply, application, automated, climate, hired, search, quick, fast, automation, one, click, effortless, career, first, entry-level",
                  og: {
                    description: "Simply your job search with our automation job application platform, blending simplicity with a climate-first approach. Streamline your application process and apply for multiple job with just one click on our platform. Kickstart your career with Cheddar - the only site you need to get hired!",
                    type: 'website',
                    url: 'https://www.cheddarjobs.com/',
                    image: 'https://www.cheddarjobs.com/',
                    site_name: 'Cheddar'
                  },
                  twitter: {
                    card: 'summary',
                    site: 'Cheddar',
                    description: 'Simply your job search with our automation job application platform, blending simplicity with a climate-first approach. Streamline your application process and apply for multiple job with just one click on our platform. Kickstart your career with Cheddar - the only site you need to get hired!',
                    image: 'https://www.cheddarjobs.com/'
                  }
   end
end
