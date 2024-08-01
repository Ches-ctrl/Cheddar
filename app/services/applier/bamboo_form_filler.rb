# frozen_string_literal: true

module Applier
  class BambooFormFiller < FormFiller
    def initialize(payload = sample_payload)
      super
    end

    private

    def application_form = '#careerApplicationForm'

    def attach_file_to_application
      find("input[name='#{@locator}']")
        .sibling('div')
        .find('input')
        .attach_file(@filepath)
    end

    def boolean_field = find(:css, "label[for='#{@locator}']")

    def click_submit_button
      sleep 2
      p "I didn't actually submit the application."
    end

    def handle_select
      @hidden_select_field = find("select[name='#{@locator}']")
      return if option_prefilled?

      super
    end

    def option_prefilled? = @hidden_select_field.has_css?("option[value='#{@value}']")

    def select_menu = @hidden_select_field.sibling('div')

    def select_option = page.document.find_by_id(@value, visible: true)

    def sample_payload
      {
        user_fullname: 'John Smith',
        apply_url: 'https://resurgo.bamboohr.com/careers/95',
        fields: [
          {
            locator: 'firstName',
            interaction: :input,
            value: 'John'
          },
          {
            locator: 'lastName',
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
            locator: 'resumeFileId',
            interaction: :upload,
            value: 'https://res.cloudinary.com/dzpupuayh/image/upload/v1/development/nd4p85sryuu40oz77n0bhs29b2sz.pdf?_a=BACCd2Bn'
          },
          {
            locator: 'streetAddress',
            interaction: :input,
            value: 'Shoreditch Stables North, 138 Kingsland Rd'
          },
          {
            locator: 'city',
            interaction: :input,
            value: 'London'
          },
          {
            locator: 'state',
            interaction: :select,
            value: '370'
          },
          {
            locator: 'zip',
            interaction: :input,
            value: 'E2 8DY'
          },
          {
            locator: 'countryId',
            interaction: :select,
            value: '222'
          },
          {
            locator: 'dateAvailable',
            interaction: :input,
            value: '31072024'
          },
          {
            locator: 'referredBy',
            interaction: :input,
            value: 'Sergey Brin'
          },
          {
            locator: 'customQuestions[1965]',
            interaction: :input,
            value: 'A little birdie told me.'
          },
          {
            locator: 'customQuestions[1966]',
            interaction: :input,
            value: 'No, no, never applied to you before. Why?'
          },
          {
            locator: 'customQuestions[1967]',
            interaction: :input,
            value: 'Oh gosh, where to start? Everything. And nothing. Nothing at all, really. Nothing really worth mentioning.'
          },
          {
            locator: 'customQuestions[1968]',
            interaction: :input,
            value: "I like to be good. I don't like to have to ask for forgiveness. And I am good; I don't do a lot of things that are bad, I try and do nothing that's bad. I have a great relationship with God."
          },
          {
            locator: 'customQuestions[1969]',
            interaction: :input,
            value: "I have a very diverse background. I'm a gay, lesbian, transgender woman of mixed black and brown background and neurodiverse and disabled. I'm part dolphin."
          },
          {
            locator: 'customQuestions[1970]',
            interaction: :input,
            value: "Because of my condition I'm unable to work more than 20 minutes a week."
          },
          {
            locator: 'customQuestions[1971]',
            interaction: :input,
            value: "It sounds like you're attempting to discriminate against me because of my condition."
          },
          {
            locator: 'customQuestions[1972]',
            interaction: :input,
            value: 'No no, not working atm'
          },
          {
            locator: 'customQuestions[1973]',
            interaction: :input,
            value: "I have a legal right to work, although I don't like to."
          },
          {
            locator: 'customQuestions[1974]',
            interaction: :input,
            value: "Let's discuss."
          },
          {
            locator: 'customQuestions[1975]',
            interaction: :boolean,
            value: true
          }
          # {
          #   locator: '#cvFileId',
          #   interaction: :upload,
          #   value: File.open('public/Obretetskiy_cv.pdf')
          # },
          # {
          #   locator: 'motivationLetter',
          #   interaction: :input,
          #   value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
          # }
        ]
      }
    end
  end
end
