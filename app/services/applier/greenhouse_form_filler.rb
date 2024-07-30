# frozen_string_literal: true

module Applier
  class GreenhouseFormFiller < FormFiller
    def initialize(payload = cleoai_payload)
      super
    end

    private

    def application_form = '#application-form'

    def click_submit_button
      sleep 2
      p "I didn't actually submit the application."
    end

    def click_and_answer_follow_up(value)
      value, follow_up_value = value if value.is_a?(Array)
      find(:css, "div[role='option']", text: value.strip).click
      find_by_id("#{@locator}-freeform").set(follow_up_value) if follow_up_value
    end

    def demographic_label = find_by_id("#{@locator}-label")

    def expand_demographic_select_menu
      demographic_label.sibling('div').first('div div div').click
    end

    def expand_select_menu = find_by_id(@locator).click

    def handle_demographic_question
      @value.each do |value|
        expand_demographic_select_menu
        click_and_answer_follow_up(value)
      end
    end

    def handle_demographic_select
      expand_select_menu
      click_and_answer_follow_up(@value)
    end

    def handle_multi_select
      @value.each do |value|
        find(:css, "input[type='checkbox'][value='#{value}'][name='#{@locator}']").click
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

    def cleoai_payload
      {
        user_fullname: 'John Smith',
        apply_url: 'https://job-boards.greenhouse.io/cleoai/jobs/7552121002',
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
            locator: 'resume',
            interaction: :upload,
            value: 'https://res.cloudinary.com/dzpupuayh/image/upload/v1/development/nd4p85sryuu40oz77n0bhs29b2sz.pdf?_a=BACCd2Bn'
          },
          # {
          #   locator: 'button[aria-describedby="cover_letter-allowable-file-types"]',
          #   interaction: :upload,
          #   value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
          # },
          {
            locator: 'question_28496729002',
            interaction: :input,
            value: 'https://www.linkedin.com/in/my_profile'
          },
          {
            locator: 'question_28496730002',
            interaction: :input,
            value: 'Gosh, it would be really cool and fun.'
          },
          {
            locator: 'question_28496731002',
            interaction: :select,
            value: '0'
          },
          {
            locator: 'question_28496732002',
            interaction: :input,
            value: '£1,000,000'
          },
          {
            locator: 'question_28496733002[]',
            interaction: :multi_select,
            value: ['176762294002']
          },
          {
            locator: 'question_28496734002[]',
            interaction: :multi_select,
            value: ['176762295002', '176762303002', '176762307002']
          },
          {
            locator: '4000100002',
            interaction: :demographic_question,
            value: ['Man', 'Woman', ['I self describe as', 'The Ever-Evolving Enigma Embracing Every Embodiment']]
          },
          {
            locator: '4000101002',
            interaction: :demographic_question,
            value: ['White', 'Mixed or Multiple ethnic groups', 'Asian', ['Other', 'Tiger']]
          },
          {
            locator: '4000102002',
            interaction: :demographic_question,
            value: ['18-24 years old', '25-34 years old', '35-44 years old']
          },
          {
            locator: '4000862002',
            interaction: :demographic_select,
            value: ['Other - please specify', 'Asexual, pansexual and furry']
          },
          {
            locator: '4000863002',
            interaction: :demographic_select,
            value: ['Yes ', 'I got a monkey.']
          },
          {
            locator: '4000864002',
            interaction: :demographic_select,
            value: ['Yes', 'I got a rash.']
          },
          {
            locator: '4000865002',
            interaction: :demographic_select,
            value: 'Selective Grammar School'
          },
          {
            locator: '4024833002',
            interaction: :demographic_select,
            value: "Other such as: retired, this question does not apply to me, I don’t know."
          }
        ]
      }
    end
  end
end
