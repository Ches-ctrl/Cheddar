# frozen_string_literal: true

module Applier
  class GhFormFiller < FormFiller
    private

    def click_submit_button
      sleep 2
      p "I didn't actually submit the application."
    end

    def attach_file_to_application
      attach_file(@filepath) do
        find(@locator).click
      end
    end

    def click_and_answer_follow_up(checkbox, follow_up_value)
      checkbox.click
      return unless follow_up_value

      find(:css, "input[type='text']", focused: true).set(follow_up_value)
    end

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

    def handle_input
      return super unless locator_is_numerical?

      field = hidden_element.sibling(:css, 'input, textarea', visible: true)[:id]
      fill_in(field, with: @value)
    end

    def handle_multi_select
      @value.each do |value|
        find(:css, "input[type='checkbox'][value='#{value}'][set='#{@locator}']").click
      end
    end

    def handle_select
      hidden_element.sibling('div', visible: true).click
      page.document.find('li', text: selector_text, visible: true).click
    end

    def hidden_element
      find(:css, "input[type='hidden'][value='#{@locator}']")
    end

    def locator_is_numerical?
      @locator.to_i.positive?
    end

    def selector_text
      within(hidden_element.sibling(:css, "select", visible: false)) do
        find(:css, "option[value='#{@value}']").text
      end
    end

    def sample_payload
      {
        user_fullname: 'John Smith',
        apply_url: 'https://boards.greenhouse.io/cleoai/jobs/4628944002',
        form_locator: '#application_form',
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
            locator: '27737478002',
            interaction: :input,
            value: 'I would like to earn a decent salary. I am not greedy.'
          },
          {
            locator: '18804072002',
            interaction: :multi_select,
            value: ['88174211002']
          },
          {
            locator: '24229694002',
            interaction: :multi_select,
            value: ['114986929002', '114986935002', '114986948002']
          },
          {
            locator: '4000101002',
            interaction: :demographic_question,
            value: ['4000548002', '4004737002', '4000550002']
          },
          {
            locator: '4000862002',
            interaction: :demographic_question,
            value: ['4004741002']
          }
        ]
      }
    end

    def codepath_payload
      {
        user_fullname: 'John Smith',
        apply_url: 'https://boards.greenhouse.io/codepath/jobs/4035988007',
        form_locator: '#application_form',
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
