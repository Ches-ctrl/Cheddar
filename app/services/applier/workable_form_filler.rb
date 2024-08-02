# frozen_string_literal: true

module Applier
  class WorkableFormFiller < FormFiller
    def initialize(payload = education_experience_payload)
      Capybara.configure { |config| config.test_id = :'data-ui' }
      super
    end

    private

    def application_form = 'form[data-ui="application-form"]'

    def boolean_checkbox? = has_selector?("##{@locator}")

    def boolean_group = find(:fieldset, @locator)

    def boolean_string = @value ? 'yes' : 'no'

    def click_apply_button = false

    def click_submit_button
      sleep 2
      p "I didn't actually submit the application."
    end

    def group_section = find("div[data-ui='#{@locator}']")

    def handle_boolean
      return super if boolean_checkbox?

      boolean_group
        .find('span', text: boolean_string)
        .click
    end

    def handle_date
      handle_input
      send_keys(:return) # close datepicker
    end

    def handle_group
      within group_section do
        click_button('add-section')
        @value.each { |field| fill_in_field(field) }
        click_button('save-section')
      end
      sleep 0.2 # avoid javascript error
    end

    def select_menu = find("div[data-ui='#{@locator}']")

    def select_option = find("li[value='#{@value}']")

    def sample_payload
      {
        user_fullname: 'John Smith',
        apply_url: 'https://apply.workable.com/kroo/j/C4002EDABE/apply/',
        fields: [
          {
            locator: 'firstname',
            interaction: :input,
            value: 'John'
          },
          {
            locator: 'lastname',
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
          {
            locator: 'QA_5947083',
            interaction: :boolean,
            value: true
          },
          {
            locator: 'QA_7692993',
            interaction: :input,
            value: '£1M'
          },
          {
            locator: 'QA_7692994',
            interaction: :input,
            value: '£5M'
          },
          {
            locator: 'QA_7692995',
            interaction: :input,
            value: 'A couple days.'
          },
          {
            locator: 'QA_7692996',
            interaction: :input,
            value: 'Tier 7 visa'
          },
          {
            locator: 'QA_5947034',
            interaction: :input,
            value: 'Oh yeah, loads of experience. Lots of experience. Tons of experience. And good quality experience, too.'
          },
          {
            locator: 'QA_5947035',
            interaction: :input,
            value: "Oh yeah, a bit of experience. I've had a bit of experience in this area, to tell you the truth. Not a ton of experience. If I'm being honest, it's actually none. No experience. None whatsoever."
          },
          {
            locator: 'QA_5947036',
            interaction: :input,
            value: 'I have working knowledge of all of that and more. I also know about the Habsburgs. And the Visigoths.'
          },
          {
            locator: 'QA_6302137',
            interaction: :select,
            value: '2998916'
          },
          {
            locator: 'QA_6302138',
            interaction: :input,
            value: 'me/myself/I'
          },
          {
            locator: 'QA_7694028',
            interaction: :input,
            value: 'No.'
          }
        ]
      }
    end

    def builderai_payload
      {
        user_fullname: 'Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso',
        apply_url: 'https://apply.workable.com/builderai/j/CF5239D46D/apply/',
        fields: [
          {
            locator: 'firstname',
            interaction: :input,
            value: 'Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad'
          },
          {
            locator: 'lastname',
            interaction: :input,
            value: 'Ruiz y Picasso'
          },
          {
            locator: 'email',
            interaction: :input,
            value: 'pablo.diego@example.com'
          },
          {
            locator: 'headline',
            interaction: :input,
            value: 'Pablo Picasso was never called an asshole'
          },
          {
            locator: 'phone',
            interaction: :input,
            value: '(555) 555-5555'
          },
          {
            locator: 'address',
            interaction: :input,
            value: 'Shoreditch Stables North, 138 Kingsland Rd'
          },
          {
            locator: 'summary',
            interaction: :input,
            value: 'Some people try to pick up girls and get called assholes. This never happened to Pablo Picasso. He could walk down your street and girls could not resist to stare, and so Pablo Picasso was never called an asshole'
          },
          {
            locator: 'resume',
            interaction: :upload,
            value: 'https://res.cloudinary.com/dzpupuayh/image/upload/v1/development/nd4p85sryuu40oz77n0bhs29b2sz.pdf?_a=BACCd2Bn'
          },
          {
            locator: 'CA_18006',
            interaction: :input,
            value: 'Yeah.'
          },
          {
            locator: 'CA_18007',
            interaction: :input,
            value: '£5M'
          },
          {
            locator: 'CA_18008',
            interaction: :input,
            value: "Man, this is totally my thing. Plus, I'm like a really good worker."
          },
          {
            locator: 'CA_18009',
            interaction: :input,
            value: 'Oh gosh, where to start? Everything. And nothing. Nothing at all, really. Nothing really worth mentioning.'
          },
          {
            locator: 'cover_letter',
            interaction: :input,
            value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
          },
          {
            locator: 'CA_26752',
            interaction: :checkbox,
            value: '251784'
          },
          {
            locator: 'QA_7304836',
            interaction: :input,
            value: '£5M'
          },
          {
            locator: 'QA_7304837',
            interaction: :boolean,
            value: true
          }
        ]
      }
    end

    def education_experience_payload
      {
        user_fullname: 'Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso',
        apply_url: 'https://apply.workable.com/builderai/j/FB5D338034/apply/',
        fields: [
          {
            locator: 'firstname',
            interaction: :input,
            value: 'Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad'
          },
          {
            locator: 'lastname',
            interaction: :input,
            value: 'Ruiz y Picasso'
          },
          {
            locator: 'email',
            interaction: :input,
            value: 'pablo.diego@example.com'
          },
          {
            locator: 'headline',
            interaction: :input,
            value: 'Pablo Picasso was never called an asshole'
          },
          {
            locator: 'phone',
            interaction: :input,
            value: '(555) 555-5555'
          },
          {
            locator: 'address',
            interaction: :input,
            value: 'Shoreditch Stables North, 138 Kingsland Rd'
          },
          {
            locator: 'CA_18006',
            interaction: :input,
            value: 'Yeah.'
          },
          {
            locator: 'education',
            interaction: :group,
            value: [
              {
                locator: 'school',
                interaction: :input,
                value: 'Le Wagon'
              },
              {
                locator: 'field_of_study',
                interaction: :input,
                value: 'Underwater Basket Weaving'
              },
              {
                locator: 'degree',
                interaction: :input,
                value: 'Diploma'
              },
              {
                locator: 'start_date',
                interaction: :date,
                value: '102023'
              },
              {
                locator: 'end_date',
                interaction: :date,
                value: '122023'
              }
            ]
          },
          {
            locator: 'education',
            interaction: :group,
            value: [
              {
                locator: 'school',
                interaction: :input,
                value: "King's College London"
              },
              {
                locator: 'field_of_study',
                interaction: :input,
                value: 'Gender Studies'
              },
              {
                locator: 'degree',
                interaction: :input,
                value: 'PhD'
              },
              {
                locator: 'start_date',
                interaction: :date,
                value: '092019'
              },
              {
                locator: 'end_date',
                interaction: :date,
                value: '062023'
              }
            ]
          },
          {
            locator: 'experience',
            interaction: :group,
            value: [
              {
                locator: 'title',
                interaction: :input,
                value: 'Junior Software Engineer'
              },
              {
                locator: 'company',
                interaction: :input,
                value: 'Google'
              },
              {
                locator: 'industry',
                interaction: :input,
                value: 'Advertising'
              },
              {
                locator: 'summary',
                interaction: :input,
                value: 'To resist the Sword of the Common-wealth, in defence of another man, guilty, or innocent, no man hath Liberty; because such Liberty, takes away from the Soveraign, the means of Protecting us; and is therefore destructive of the very essence of Government.'
              },
              {
                locator: 'start_date',
                interaction: :date,
                value: '012018'
              },
              {
                locator: 'end_date',
                interaction: :date,
                value: '082020'
              }
            ]
          },
          {
            locator: 'experience',
            interaction: :group,
            value: [
              {
                locator: 'title',
                interaction: :input,
                value: 'Software Engineer II'
              },
              {
                locator: 'company',
                interaction: :input,
                value: 'Twitter'
              },
              {
                locator: 'industry',
                interaction: :input,
                value: 'Communications'
              },
              {
                locator: 'summary',
                interaction: :input,
                value: 'The finall Cause, End, or Designe of men, (who naturally love Liberty, and Dominion over others,) in the introduction of that restraint upon themselves (in which wee see them live in Common-wealths,) is the foresight of their own preservation.'
              },
              {
                locator: 'start_date',
                interaction: :date,
                value: '042024'
              },
              {
                locator: 'current',
                interaction: :boolean,
                value: true
              }
            ]
          },
          {
            locator: 'summary',
            interaction: :input,
            value: 'Some people try to pick up girls and get called assholes. This never happened to Pablo Picasso. He could walk down your street and girls could not resist to stare, and so Pablo Picasso was never called an asshole'
          },
          {
            locator: 'resume',
            interaction: :upload,
            value: 'https://res.cloudinary.com/dzpupuayh/image/upload/v1/development/nd4p85sryuu40oz77n0bhs29b2sz.pdf?_a=BACCd2Bn'
          },
          {
            locator: 'CA_18008',
            interaction: :input,
            value: "Man, this is totally my thing. Plus, I'm like a really good worker."
          },
          {
            locator: 'CA_18009',
            interaction: :input,
            value: 'Oh gosh, where to start? Everything. And nothing. Nothing at all, really. Nothing really worth mentioning.'
          },
          {
            locator: 'cover_letter',
            interaction: :input,
            value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
          },
          {
            locator: 'QA_8326235',
            interaction: :input,
            value: 'Man, I got more experience than you can wave a stick at. Months, buddy. Months and weeks of experience.'
          },
          {
            locator: 'QA_8326237',
            interaction: :input,
            value: 'Just let me know anytime.'
          },
          {
            locator: 'QA_8326238',
            interaction: :input,
            value: 'Shoreditch Stables North, 138 Kingsland Rd'
          },
          {
            locator: 'QA_8326239',
            interaction: :input,
            value: "Mate, that's pretty far away from me, actually."
          }
        ]
      }
    end
  end
end
