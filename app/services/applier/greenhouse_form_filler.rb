# frozen_string_literal: true

module Applier
  class GreenhouseFormFiller < FormFiller
    def initialize(payload = sample_payload)
      super
      convert_locators
    end

    private

    def application_form = '#application-form'

    def click_submit_button
      sleep 2
      p "I didn't actually submit the application."
    end

    def click_and_answer_follow_up(checkbox, follow_up_value)
      checkbox.click
      return unless follow_up_value

      find(:css, "input[type='text']", focused: true).set(follow_up_value)
    end

    def convert_locators
      @fields.each do |field|
        locator = field[:locator]
        field[:locator] = "question_#{locator}" if numerical?(locator)
      end
    end

    def expand_select_menu = find_by_id(@locator).click

    def handle_demographic_question
      parent = find(:css, "input[type='hidden'][value='#{@locator}']")
               .ancestor('div', class: 'demographic_question')
      within parent do
        @value.each do |value|
          value, follow_up_value = value if value.is_a?(Array)
          checkbox = find(:css, "input[type='checkbox'][value='#{value}']")
          click_and_answer_follow_up(checkbox, follow_up_value)
        end
      end
    end

    def handle_multi_select
      @value.each do |value|
        find(:css, "input[type='checkbox'][value='#{value}'][set='#{@locator}']").click
      end
    end

    def handle_select
      expand_select_menu
      select_option.click
    end

    def handle_upload
      pdf_tmp_file
      attach_file_to_application
    end

    def hidden_element
      find(:css, "input[type='hidden'][value='#{@locator}']")
    end

    def numerical?(string) = string.to_i.positive?

    def pdf_tmp_file
      uri = URI.parse(@value)
      @value = Net::HTTP.get_response(uri).body
      super
    end

    def select_option = find("#react-select-#{@locator}-option-#{@value}")

    def sample_payload
      {
        user_fullname: 'John Smith',
        apply_url: 'https://job-boards.greenhouse.io/narvar/jobs/5976785',
        fields: [
          {
            locator: 'first_name',
            interaction: :input,
            value: 'John'
          },
          {
            locator: 'last_name',
            interaction: :input,
            value: 'Smith'
          },
          {
            locator: 'email',
            interaction: :input,
            value: 'j.smith@example.com'
          },
          {
            locator: 'phone',
            interaction: :input,
            value: '(555) 555-5555'
          },
          {
            locator: "resume",
            interaction: :upload,
            value: 'https://res.cloudinary.com/dzpupuayh/image/upload/v1/development/nd4p85sryuu40oz77n0bhs29b2sz.pdf?_a=BACCd2Bn'
          },
          # {
          #   locator: 'button[aria-describedby="cover_letter-allowable-file-types"]',
          #   interaction: :upload,
          #   value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
          # },
          {
            locator: '48034254',
            interaction: :input,
            value: 'Coca-Cola'
          },
          {
            locator: '48034255',
            interaction: :input,
            value: 'Owner and CEO'
          },
          {
            locator: '48034256',
            interaction: :input,
            value: 'https:://www.linkedin.com/in/my_profile'
          },
          {
            locator: '48034257',
            interaction: :select,
            value: 0
          },
          {
            locator: '48034258',
            interaction: :select,
            value: 0
          },
          {
            locator: '48034259',
            interaction: :select,
            value: 0
          },
          {
            locator: '48034260',
            interaction: :select,
            value: 0
          },
          {
            locator: 'gender',
            interaction: :select,
            value: 0
          },
          {
            locator: 'hispanic_ethnicity',
            interaction: :select,
            value: 1
          },
          {
            locator: 'veteran_status',
            interaction: :select,
            value: 1
          },
          {
            locator: 'disability_status',
            interaction: :select,
            value: 0
          }
        ]
      }
    end

    def codepath_payload
      # old format
      {
        user_fullname: 'John Smith',
        apply_url: 'https://boards.greenhouse.io/codepath/jobs/4035988007',
        fields: [
          {
            locator: 'first_name',
            interaction: :input,
            value: 'John'
          },
          {
            locator: 'last_name',
            interaction: :input,
            value: 'Smith'
          },
          {
            locator: 'email',
            interaction: :input,
            value: 'j.smith@example.com'
          },
          {
            locator: 'phone',
            interaction: :input,
            value: '(555) 555-5555'
          },
          {
            locator: "button[aria-describedby='resume-allowable-file-types']",
            interaction: :upload,
            value: File.open('public/Obretetskiy_cv.pdf')
          },
          {
            locator: 'button[aria-describedby="cover_letter-allowable-file-types"]',
            interaction: :upload,
            value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
          },
          {
            locator: '4159819007',
            interaction: :input,
            value: 'https://www.linkedin.com/in/my_profile'
          },
          {
            locator: '4159820007',
            interaction: :input,
            value: 'Would be really cool and fun.'
          },
          {
            locator: '4179768007',
            interaction: :input,
            value: 'So I helped to build this thing. It was a lot of work! Phew! And you know, it all went pretty well.'
          },
          {
            locator: '4159821007',
            interaction: :select,
            value: '1'
          },
          {
            locator: '4782743007',
            interaction: :select,
            value: '6001300007'
          },
          {
            locator: '6561969007',
            interaction: :input,
            value: 'John Quincy Adams'
          },
          {
            locator: '4006277007',
            interaction: :demographic_question,
            value: ['4037604007', '4037606007', ['4037607007', 'The Ever-Evolving Enigma Embracing Every Embodiment']]
          },
          {
            locator: '4006278007',
            interaction: :demographic_question,
            value: ['4037610007', '4037611007', '4037612007', '4037614007', '4037617007', ['4037618007', 'diverse']]
          },
          {
            locator: '4006279007',
            interaction: :demographic_question,
            value: ['4037622007', '4037624007', '4037625007', '4037627007']
          },
          {
            locator: '4006280007',
            interaction: :demographic_question,
            value: [['4037630007', 'Sometimes.']]
          },
          {
            locator: '4006281007',
            interaction: :demographic_question,
            value: ['4037632007']
          },
          {
            locator: '4006282007',
            interaction: :demographic_question,
            value: [['4037638007', "You can't handle the truth!"]]
          }
        ]
      }
    end
  end
end
