# frozen_string_literal: true

module Importer
  class GreenhouseFieldsBuilder < ApplicationTask
    include FaradayHelpers

    def initialize(job, data)
      @job = job
      @data = data.with_indifferent_access
    end

    def call
      return unless processable

      process
    end

    private

    def processable
      @job && @data
    end

    def process
      build_fields
      log_and_return_fields
    end

    ###

    def build_fields
      @fields = [
        {
          build_type: :api,
          section_slug: "core_fields",
          title: "Main application",
          description: nil,
          questions: questions_builder(@data[:questions])
        },
        {
          build_type: :api,
          section_slug: "demographic_fields",
          title: section_attribute_finder(:demographic_questions, :header),
          description: section_attribute_finder(:demographic_questions, :description),
          questions: questions_builder(@data.dig(:demographic_questions, :questions))
        },
        {
          build_type: :api,
          section_slug: "compliance_fields",
          title: section_attribute_finder(:compliance, :title) || "EEOC compliance questions",
          description: section_attribute_finder(:compliance, :description),
          questions: questions_builder(@data[:compliance])
        }
      ]
    end

    def log_and_return_fields
      puts pretty_generate(@fields)
      @fields
    end

    def section_attribute_finder(section, attribute)
      @data.dig(section, attribute)
    end

    def questions_builder(section)
      return [] unless section.present?

      section.map do |question|
        question_params(question).merge(fields: fields_params(question))
      end
    end

    def fields_params(question)
      fields = question[:fields] || [question] # specific to demographic_questions
      fields.map do |field|
        id = field[:name]
        selector = field[:id] # specific to demographic_questions
        type = field[:type]
        max_length = field[:max_length] || 255
        options = options_params(field[:values] || field[:answer_options]) # specific to demographic_questions
        { id:, selector:, type:, max_length:, options: }
      end
    end

    def question_params(question)
      { attribute: question[:fields].present? ? core_attribute(question) : demographic_attribute(question), # specific to demographic_questions
        description: question[:description],
        label: question[:label],
        required: question[:required] }
    end

    def options_params(values)
      return [] if values.none?

      values.map { |value| { id: (value[:value] || value[:id]).to_s, label: value[:label] } } # specific to demographic_questions
    end

    def core_attribute(question) = question[:fields].first[:name]

    # specific to demographic_questions
    def demographic_attribute(question) = question[:label].parameterize.underscore.first(50)

    #   MODELE = [{
    #     build_type: :api,
    #     section_slug: "core_fields",
    #     title: "Main application",
    #     description: nil,
    #     questions: [{
    #       attribute: :first_name,
    #       required: true,
    #       label: "First Name",
    #       description: nil,
    #       fields: [{
    #         id: "first_name",
    #         selector: nil,
    #         type: :input,
    #         max_length: 255,
    #         options: []
    #       }]
    #     },
    #                 {
    #                   attribute: :last_name,
    #                   required: true,
    #                   label: "Last Name",
    #                   description: nil,
    #                   fields: [{
    #                     id: "last_name",
    #                     selector: nil,
    #                     type: :input,
    #                     max_length: 255,
    #                     options: []
    #                   }]
    #                 },
    #                 {
    #                   attribute: :email,
    #                   required: true,
    #                   label: "Email",
    #                   description: nil,
    #                   fields: [{
    #                     id: "email",
    #                     selector: nil,
    #                     type: :input,
    #                     max_length: 255,
    #                     options: []
    #                   }]
    #                 },
    #                 {
    #                   attribute: :phone_number,
    #                   required: true,
    #                   label: "Phone",
    #                   description: nil,
    #                   fields: [{
    #                     id: "phone",
    #                     selector: nil,
    #                     type: :input,
    #                     max_length: 255,
    #                     options: []
    #                   }]
    #                 },
    #                 {
    #                   attribute: :city_applicant,
    #                   required: false,
    #                   label: "Location (City)",
    #                   description: nil,
    #                   fields: [{
    #                     id: "auto_complete_input",
    #                     selector: "input[name=\"job_application[location]\"]",
    #                     type: :location,
    #                     max_length: 255,
    #                     options: []
    #                   }]
    #                 },
    #                 {
    #                   attribute: :resume,
    #                   required: true,
    #                   label: "Resume/CV",
    #                   description: nil,
    #                   fields: [{
    #                     id: nil,
    #                     selector: "button[aria-describedby=\"resume-allowable-file-types\"]",
    #                     type: :upload,
    #                     max_length: 255,
    #                     options: []
    #                   },
    #                            {
    #                              id: "resume_text",
    #                              selector: nil,
    #                              type: :input,
    #                              options: []
    #                            }]
    #                 },
    #                 {
    #                   attribute: :cover_letter,
    #                   required: false,
    #                   label: "Cover Letter",
    #                   description: nil,
    #                   fields: [{
    #                     id: nil,
    #                     selector: "button[aria-describedby=\"cover_letter-allowable-file-types\"]",
    #                     type: :upload,
    #                     max_length: 255,
    #                     options: []
    #                   },
    #                            {
    #                              id: "cover_letter_text",
    #                              selector: nil,
    #                              type: :input,
    #                              options: []
    #                            }]
    #                 },
    #                 {
    #                   attribute: "are_you_legally_authorized_to_work_in_the_united_states",
    #                   required: true,
    #                   label: "Are you legally authorized to work in the United States?",
    #                   description: nil,
    #                   fields: [{
    #                     id: "28109247002",
    #                     type: :select,
    #                     options: [{
    #                       id: "1",
    #                       label: "Yes"
    #                     }, {
    #                       id: "0",
    #                       label: "No"
    #                     }]
    #                   }]
    #                 },
    #                 {
    #                   attribute: "in_the_future_will_you_require_immigration_sponsorship_by_mot",
    #                   required: true,
    #                   label: "In the future will you require immigration sponsorship by Motive to work in the United States? ",
    #                   description: nil,
    #                   fields: [{
    #                     id: "28109248002",
    #                     type: :select,
    #                     options: [{
    #                       id: "1",
    #                       label: "Yes"
    #                     }, {
    #                       id: "0",
    #                       label: "No"
    #                     }]
    #                   }]
    #                 },
    #                 {
    #                   attribute: "linkedin_profile",
    #                   required: false,
    #                   label: "LinkedIn Profile",
    #                   description: nil,
    #                   fields: [{
    #                     id: "28109249002",
    #                     type: :input,
    #                     max_length: 255,
    #                     options: []
    #                   }]
    #                 },
    #                 {
    #                   attribute: "github_url",
    #                   required: false,
    #                   label: "Github URL",
    #                   description: nil,
    #                   fields: [{
    #                     id: "28109250002",
    #                     type: :input,
    #                     max_length: 255,
    #                     options: []
    #                   }]
    #                 },
    #                 {
    #                   attribute: "what_tangible_factors_are_most_important_to_you_when_consider",
    #                   required: true,
    #                   label: "What tangible factors are most important to you when considering a job opportunity?",
    #                   description: "<p>Select your top 3.</p>",
    #                   fields: [{
    #                     id: "28109253002",
    #                     type: :multi_select,
    #                     options: [{
    #                       id: "171883594002",
    #                       label: "Career Growth"
    #                     },
    #                               {
    #                                 id: "171883595002",
    #                                 label: "Work-life Balance"
    #                               },
    #                               {
    #                                 id: "171883596002",
    #                                 label: "Remote Work"
    #                               },
    #                               {
    #                                 id: "171883597002",
    #                                 label: "Leadership"
    #                               },
    #                               {
    #                                 id: "171883598002",
    #                                 label: "Compensation"
    #                               },
    #                               {
    #                                 id: "171883599002",
    #                                 label: "Benefits"
    #                               },
    #                               {
    #                                 id: "171883600002",
    #                                 label: "PTO"
    #                               },
    #                               {
    #                                 id: "171883601002",
    #                                 label: "Career Stability"
    #                               },
    #                               {
    #                                 id: "171883602002",
    #                                 label: "Culture"
    #                               },
    #                               {
    #                                 id: "171883603002",
    #                                 label: "Company Outlook"
    #                               }]
    #                   }]
    #                 },
    #                 {
    #                   attribute: "what_about_motive_makes_it_an_appealing_place_to_work",
    #                   required: true,
    #                   label: "What about Motive makes it an appealing place to work?",
    #                   description: nil,
    #                   fields: [{
    #                     id: "28109254002",
    #                     type: :textarea,
    #                     options: []
    #                   }]
    #                 },
    #                 {
    #                   attribute: "pronouns",
    #                   required: false,
    #                   label: "Pronouns",
    #                   description: "<p>Let Motive know what pronouns you use so we can address you correctly.</p>",
    #                   fields: [{
    #                     id: "28109255002",
    #                     type: :select,
    #                     options: [{
    #                       id: "171883604002",
    #                       label: "She/her"
    #                     },
    #                               {
    #                                 id: "171883605002",
    #                                 label: "He/him"
    #                               },
    #                               {
    #                                 id: "171883606002",
    #                                 label: "They/them"
    #                               },
    #                               {
    #                                 id: "171883607002",
    #                                 label: "El/Ellos"
    #                               },
    #                               {
    #                                 id: "171883608002",
    #                                 label: "Ella/Ellas"
    #                               },
    #                               {
    #                                 id: "171883609002",
    #                                 label: "Elle/Elles"
    #                               },
    #                               {
    #                                 id: "171883610002",
    #                                 label: "Other"
    #                               }]
    #                   }]
    #                 },
    #                 {
    #                   attribute: "how_did_you_hear_about_this_opportunity",
    #                   required: true,
    #                   label: "How did you hear about this opportunity?",
    #                   description: nil,
    #                   fields: [{
    #                     id: "28109256002",
    #                     type: :select,
    #                     options: [{
    #                       id: "171883611002",
    #                       label: "LinkedIn"
    #                     },
    #                               {
    #                                 id: "171883612002",
    #                                 label: "Glassdoor"
    #                               },
    #                               {
    #                                 id: "171883613002",
    #                                 label: "BuiltIn"
    #                               },
    #                               {
    #                                 id: "171883614002",
    #                                 label: "Comparably"
    #                               },
    #                               {
    #                                 id: "171883615002",
    #                                 label: "Medium"
    #                               },
    #                               {
    #                                 id: "171883616002",
    #                                 label: "Motive Careers Page"
    #                               },
    #                               {
    #                                 id: "171883617002",
    #                                 label: "Referred by a friend"
    #                               },
    #                               {
    #                                 id: "171883618002",
    #                                 label: "Instagram"
    #                               },
    #                               {
    #                                 id: "171883619002",
    #                                 label: "RepVue"
    #                               }]
    #                   }]
    #                 },
    #                 {
    #                   attribute: "do_you_have_hands_on_knowledge_of_machine_learning_techniques",
    #                   required: true,
    #                   label: "Do you have hands on knowledge of machine learning techniques and algorithms?",
    #                   description: nil,
    #                   fields: [{
    #                     id: "28165607002",
    #                     type: :input,
    #                     max_length: 255,
    #                     options: []
    #                   }]
    #                 },
    #                 {
    #                   attribute: "have_you_built_telematics_ai_models_for_a_growing_tech_compan",
    #                   required: true,
    #                   label: "Have you built telematics AI models for a growing tech company in any of your prior roles?",
    #                   description: nil,
    #                   fields: [{
    #                     id: "28165608002",
    #                     type: :textarea,
    #                     options: []
    #                   }]
    #                 }]
    #   },
    #             {
    #               build_type: :api,
    #               section_slug: "demographic_fields",
    #               title: "Global Diversity Survey",
    #               description: "<p>We invite applicants to share their demographic background. If you choose to complete this survey, your responses may be used to identify areas of improvement in our hiring process.</p>",
    #               questions: [{
    #                 attribute: "how_would_you_describe_your_gender_identity",
    #                 required: false,
    #                 label: "How would you describe your gender identity? (mark all that apply)",
    #                 description: nil,
    #                 fields: [{
    #                   id: "4024732002",
    #                   type: :select,
    #                   options: [{
    #                     id: "4148157002",
    #                     label: "Male",
    #                     free_form: false,
    #                     decline_to_answer: false
    #                   },
    #                             {
    #                               id: "4148158002",
    #                               label: "Female",
    #                               free_form: false,
    #                               decline_to_answer: false
    #                             },
    #                             {
    #                               id: "4148160002",
    #                               label: "I don't wish to answer",
    #                               free_form: false,
    #                               decline_to_answer: false
    #                             }]
    #                 }]
    #               },
    #                           {
    #                             attribute: "do_you_have_a_disability_or_chronic_condition_physical_visu",
    #                             required: false,
    #                             label: "Do you have a disability or chronic condition (physical, visual, auditory, cognitive, mental, emotional, or other) that substantially limits one or more of your major life activities, including mobility, communication and learning?",
    #                             description: nil,
    #                             fields: [{
    #                               id: "4024734002",
    #                               type: :select,
    #                               options: [{
    #                                 id: "4148169002",
    #                                 label: "Yes",
    #                                 free_form: false,
    #                                 decline_to_answer: false
    #                               },
    #                                         {
    #                                           id: "4148170002",
    #                                           label: "No",
    #                                           free_form: false,
    #                                           decline_to_answer: false
    #                                         },
    #                                         {
    #                                           id: "4148171002",
    #                                           label: "I prefer to self-describe",
    #                                           free_form: true,
    #                                           decline_to_answer: false
    #                                         },
    #                                         {
    #                                           id: "4148172002",
    #                                           label: "I don't wish to answer",
    #                                           free_form: false,
    #                                           decline_to_answer: false
    #                                         }]
    #                             }]
    #                           }]
    #             },
    #             {
    #               build_type: :api,
    #               section_slug: "compliance_fields",
    #               title: "EEOC compliance questions",
    #               description: "&lt;p&gt;PUBLIC BURDEN STATEMENT:According to the Paperwork Reduction Act of 1995 no persons are required to respond to a collection of information unless such collection displays a valid OMB control number. This survey should take about 5 minutes to complete.&lt;/p&gt;\n",
    #               questions: [{
    #                 attribute: "disabilitystatus",
    #                 required: false,
    #                 label: "DisabilityStatus",
    #                 description: "&lt;h3&gt;&lt;strong&gt;Voluntary Self-Identification of Disability&lt;/strong&gt;&lt;/h3&gt;\n&lt;div style=&quot;display:flex; justify-content:space-between;&quot;&gt;\n  &lt;div&gt;\n    &lt;div&gt;Form CC-305&lt;/div&gt;\n    &lt;div&gt;Page 1 of 1&lt;/div&gt;\n  &lt;/div&gt;\n  &lt;div&gt;\n    &lt;div&gt;OMB Control Number 1250-0005&lt;/div&gt;\n    &lt;div&gt;Expires 04/30/2026&lt;/div&gt;\n  &lt;/div&gt;\n&lt;/div&gt;\n&lt;br&gt;\n&lt;strong&gt;Why are you being asked to complete this form?&lt;/strong&gt;\n&lt;p&gt;We are a federal contractor or subcontractor. The law requires us to provide equal employment opportunity to qualified people with disabilities. We have a goal of having at least 7% of our workers as people with disabilities. The law says we must measure our progress towards this goal. To do this, we must ask applicants and employees if they have a disability or have ever had one. People can become disabled, so we need to ask this question at least every five years.&lt;/p&gt;\n&lt;p&gt;Completing this form is voluntary, and we hope that you will choose to do so. Your answer is confidential. No one who makes hiring decisions will see it. Your decision to complete the form and your answer will not harm you in any way. If you want to learn more about the law or this form, visit the U.S. Department of Labor’s Office of Federal Contract Compliance Programs (OFCCP) website at &lt;a href=&quot;https://www.dol.gov/ofccp&quot; target=&quot;_blank&quot;&gt;www.dol.gov/ofccp&lt;/a&gt;.&lt;/p&gt;\n&lt;strong&gt;How do you know if you have a disability?&lt;/strong&gt;\n&lt;p&gt;A disability is a condition that substantially limits one or more of your “major life activities.” If you have or have ever had such a condition, you are a person with a disability. &lt;strong&gt;Disabilities include, but are not limited to:&lt;/strong&gt;&lt;/p&gt;\n&lt;ul&gt;\n  &lt;li&gt;Alcohol or other substance use disorder (not currently using drugs illegally)&lt;/li&gt;\n  &lt;li&gt;Autoimmune disorder, for example, lupus, fibromyalgia, rheumatoid arthritis, HIV/AIDS&lt;/li&gt;\n  &lt;li&gt;Blind or low vision&lt;/li&gt;\n  &lt;li&gt;Cancer (past or present)&lt;/li&gt;\n  &lt;li&gt;Cardiovascular or heart disease&lt;/li&gt;\n  &lt;li&gt;Celiac disease&lt;/li&gt;\n  &lt;li&gt;Cerebral palsy&lt;/li&gt;\n  &lt;li&gt;Deaf or serious difficulty hearing&lt;/li&gt;\n  &lt;li&gt;Diabetes&lt;/li&gt;\n  &lt;li&gt;Disfigurement, for example, disfigurement caused by burns, wounds, accidents, or congenital disorders&lt;/li&gt;\n  &lt;li&gt;Epilepsy or other seizure disorder&lt;/li&gt;\n  &lt;li&gt;Gastrointestinal disorders, for example, Crohn&#39;s Disease, irritable bowel syndrome&lt;/li&gt;\n  &lt;li&gt;Intellectual or developmental disability&lt;/li&gt;\n  &lt;li&gt;Mental health conditions, for example, depression, bipolar disorder, anxiety disorder, schizophrenia, PTSD&lt;/li&gt;\n  &lt;li&gt;Missing limbs or partially missing limbs&lt;/li&gt;\n  &lt;li&gt;Mobility impairment, benefiting from the use of a wheelchair, scooter, walker, leg brace(s) and/or other supports&lt;/li&gt;\n  &lt;li&gt;Nervous system condition, for example, migraine headaches, Parkinson’s disease, multiple sclerosis (MS)&lt;/li&gt;\n  &lt;li&gt;Neurodivergence, for example, attention-deficit/hyperactivity disorder (ADHD), autism spectrum disorder, dyslexia, dyspraxia, other learning disabilities&lt;/li&gt;\n  &lt;li&gt;Partial or complete paralysis (any cause)&lt;/li&gt;\n  &lt;li&gt;Pulmonary or respiratory conditions, for example, tuberculosis, asthma, emphysema&lt;/li&gt;\n  &lt;li&gt;Short stature (dwarfism)&lt;/li&gt;\n  &lt;li&gt;Traumatic brain injury&lt;/li&gt;\n&lt;/ul&gt;\n",
    #                 fields: [{
    #                   id: "disability_status",
    #                   type: :select,
    #                   options: [{
    #                     id: "3",
    #                     label: "I do not want to answer"
    #                   },
    #                             {
    #                               id: "2",
    #                               label: "No, I do not have a disability and have not had one in the past"
    #                             },
    #                             {
    #                               id: "1",
    #                               label: "Yes, I have a disability, or have had one in the past"
    #                             }]
    #                 }]
    #               },
    #                           {
    #                             attribute: "veteranstatus",
    #                             required: false,
    #                             label: "VeteranStatus",
    #                             description: "&lt;p&gt;\n  If you believe you belong to any of the categories of protected veterans listed below, please indicate by making the appropriate selection.\n  As a government contractor subject to the Vietnam Era Veterans Readjustment Assistance Act (VEVRAA), we request this information in order to measure\n  the effectiveness of the outreach and positive recruitment efforts we undertake pursuant to VEVRAA. Classification of protected categories\n  is as follows:\n&lt;/p&gt;\n&lt;p&gt;A &quot;disabled veteran&quot; is one of the following:a veteran of the U.S. military, ground, naval or air service who is entitled to compensation (or who but for the receipt of military retired pay would be entitled to compensation) under laws administered by the Secretary of Veterans Affairs; or a person who was discharged or released from active duty because of a service-connected disability.&lt;/p&gt;\n&lt;p&gt;A &quot;recently separated veteran&quot; means any veteran during the three-year period beginning on the date of such veteran&#39;s discharge or release from active duty in the U.S. military, ground, naval, or air service.&lt;/p&gt;\n&lt;p&gt;An &quot;active duty wartime or campaign badge veteran&quot; means a veteran who served on active duty in the U.S. military, ground, naval or air service during a war, or in a campaign or expedition for which a campaign badge has been authorized under the laws administered by the Department of Defense.&lt;/p&gt;\n&lt;p&gt;An &quot;Armed forces service medal veteran&quot; means a veteran who, while serving on active duty in the U.S. military, ground, naval or air service, participated in a United States military operation for which an Armed Forces service medal was awarded pursuant to Executive Order 12985.&lt;/p&gt;\n",
    #                             fields: [{
    #                               id: "veteran_status",
    #                               type: :select,
    #                               options: [{
    #                                 id: "3",
    #                                 label: "I don't wish to answer"
    #                               },
    #                                         {
    #                                           id: "2",
    #                                           label: "I identify as one or more of the classifications of a protected veteran"
    #                                         },
    #                                         {
    #                                           id: "1",
    #                                           label: "I am not a protected veteran"
    #                                         }]
    #                             }]
    #                           },
    #                           {
    #                             attribute: "race",
    #                             required: false,
    #                             label: "Race",
    #                             description: "&lt;h3&gt;&lt;strong&gt;Voluntary Self-Identification&lt;/strong&gt;&lt;/h3&gt;&lt;br/&gt;&lt;p&gt;For government reporting purposes, we ask candidates to respond to the below self-identification survey.\nCompletion of the form is entirely voluntary. Whatever your decision, it will not be considered in the hiring\nprocess or thereafter. Any information that you do provide will be recorded and maintained in a\nconfidential file.&lt;/p&gt;\n\n&lt;p&gt;As set forth in Motive’s Equal Employment Opportunity policy,\nwe do not discriminate on the basis of any protected group status under any applicable law.&lt;/p&gt;\n",
    #                             fields: [{
    #                               id: "race",
    #                               type: :select,
    #                               options: [{
    #                                 id: "8",
    #                                 label: "Decline To Self Identify"
    #                               },
    #                                         {
    #                                           id: "7",
    #                                           label: "Two or More Races"
    #                                         },
    #                                         {
    #                                           id: "6",
    #                                           label: "Native Hawaiian or Other Pacific Islander"
    #                                         },
    #                                         {
    #                                           id: "5",
    #                                           label: "White"
    #                                         },
    #                                         {
    #                                           id: "4",
    #                                           label: "Hispanic or Latino"
    #                                         },
    #                                         {
    #                                           id: "3",
    #                                           label: "Black or African American"
    #                                         },
    #                                         {
    #                                           id: "2",
    #                                           label: "Asian"
    #                                         },
    #                                         {
    #                                           id: "1",
    #                                           label: "American Indian or Alaskan Native"
    #                                         }]
    #                             }]
    #                           },
    #                           {
    #                             attribute: "gender",
    #                             required: false,
    #                             label: "Gender",
    #                             description: "&lt;h3&gt;&lt;strong&gt;Voluntary Self-Identification&lt;/strong&gt;&lt;/h3&gt;&lt;br/&gt;&lt;p&gt;For government reporting purposes, we ask candidates to respond to the below self-identification survey.\nCompletion of the form is entirely voluntary. Whatever your decision, it will not be considered in the hiring\nprocess or thereafter. Any information that you do provide will be recorded and maintained in a\nconfidential file.&lt;/p&gt;\n\n&lt;p&gt;As set forth in Motive’s Equal Employment Opportunity policy,\nwe do not discriminate on the basis of any protected group status under any applicable law.&lt;/p&gt;\n",
    #                             fields: [{
    #                               id: "gender",
    #                               type: :select,
    #                               options: [{
    #                                 id: "3",
    #                                 label: "Decline To Self Identify"
    #                               }, {
    #                                 id: "2",
    #                                 label: "Female"
    #                               }, {
    #                                 id: "1",
    #                                 label: "Male"
    #                               }]
    #                             }]
    #                           }]
    #             }]
  end
end
