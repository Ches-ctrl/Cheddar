namespace :ff do
  desc "Test AshbyFormFiller"
  task ashbyhq: :environment do
    payload = prompt_user(ASHBY_PAYLOADS)
    Applier::AshbyFormFiller.call(payload)
  end

  desc "Test BambooFormFiller"
  task bamboohr: :environment do
    payload = prompt_user(BAMBOO_PAYLOADS)
    Applier::BambooFormFiller.call(payload)
  end

  desc "Test DevitFormFiller"
  task devitjobs: :environment do
    payload = prompt_user(DEVITJOBS_PAYLOADS)
    Applier::DevitFormFiller.call(payload)
  end

  desc "Test GreenhouseFormFiller"
  task greenhouse: :environment do
    payload = prompt_user(GREENHOUSE_PAYLOADS)
    Applier::GreenhouseFormFiller.call(payload)
  end

  desc "Test GhFormFiller"
  task greenhouse_old: :environment do
    payload = prompt_user(GREENHOUSE_OLD_PAYLOADS)
    Applier::GhFormFiller.call(payload)
  end

  desc "Test WorkableFormFiller"
  task workable: :environment do
    payload = prompt_user(WORKABLE_PAYLOADS)
    Applier::WorkableFormFiller.call(payload)
  end
end

def prompt_user(group)
  return if group.empty?

  options_count = group.size
  return group.first if options_count == 1

  group.map.with_index do |payload, index|
    puts "#{index + 1}) #{payload[:epithet]}"
  end

  puts "\nWhich payload should I use?"

  response = nil
  until response
    puts "Select a number between 1 and #{options_count}:"
    response = $stdin.gets.chomp

    response = response.to_i - 1
    response = nil if response.negative? || response >= options_count
  end

  group[response]
end

ASHBY_PAYLOADS =
  [
    {
      epithet: :sample_payload,
      user_fullname: 'John Smith',
      apply_url: 'https://jobs.ashbyhq.com/lightdash/9efa292a-cc34-4388-90a2-2bed5126ace4',
      fields: [
        {
          locator: '_systemfield_name',
          interaction: :input,
          value: 'John Smith'
        },
        {
          locator: '_systemfield_email',
          interaction: :input,
          value: 'j.smith@example.com'
        },
        {
          locator: '00415714-75f3-49b9-b856-ac674fd5ce8b',
          interaction: :location,
          value: 'London, Greater London, England, United Kingdom'
        },
        {
          locator: '36913b1f-c34f-4693-919c-400304a2a11d',
          interaction: :input,
          value: 'https://www.linkedin.com/in/my_profile'
        },
        {
          locator: 'f93bff8c-2442-42b7-b040-3876fa160aba',
          interaction: :input,
          value: "This is a very good company to work for. Fantastic reviews on Glassdoor. I have long dreamed of applying to work at this company. You do amazing and innovative things!"
        },
        {
          locator: '_systemfield_resume',
          interaction: :upload,
          value: File.open('public/Obretetskiy_cv.pdf')
        }
      ]
    },
    {
      epithet: :multiverse_payload,
      user_fullname: 'Jean-Jacques Rousseau',
      apply_url: 'https://jobs.ashbyhq.com/multiverse/69afde82-dad8-4923-937e-a8d7f0551db4',
      fields: [
        {
          locator: '_systemfield_name',
          interaction: :input,
          value: 'Jean-Jacques Rousseau'
        },
        {
          locator: '_systemfield_email',
          interaction: :input,
          value: 'j.j.rousseau@example.com'
        },
        {
          locator: '_systemfield_resume',
          interaction: :upload,
          value: 'https://res.cloudinary.com/dzpupuayh/image/upload/v1/development/nd4p85sryuu40oz77n0bhs29b2sz.pdf?_a=BACCd2Bn'
        },
        {
          locator: '1e68a3c6-1709-40e3-ad14-379c7f5bb56d',
          interaction: :upload,
          value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
        },
        {
          locator: '569d6217-f421-453e-b860-49a3c33c0359',
          interaction: :input,
          value: '(555) 555-5555'
        },
        {
          locator: '28412d74-aaaa-41c2-9cee-7305e6e4d496',
          interaction: :input,
          value: 'https://www.linkedin.com/in/my_profile'
        },
        {
          locator: 'a46e0f80-7b7d-4125-8edd-b17be1c967f9',
          interaction: :input,
          value: 'we/us'
        },
        {
          locator: '42fb1f5b-4a09-4039-aafe-ae7ec9ae57fd',
          interaction: :input,
          value: 'Jerry'
        },
        {
          locator: '457eb7ca-14cf-4c02-9332-7a4b31cc4623',
          interaction: :input,
          value: "This is a very good company to work for. Fantastic reviews on Glassdoor. I have long dreamed of applying to work at this company. You do amazing and innovative things!"
        },
        {
          locator: '3195b1dd-b981-434f-a7dd-7a57f4c62419',
          interaction: :input,
          value: 'No, no special adjustments.'
        },
        {
          locator: '9b73492f-1411-4863-8883-cf426cf197f0',
          interaction: :input,
          value: 'I was just googling like I usually do.'
        },
        {
          locator: 'bfdda3fa-f75f-48ef-9870-f4f168ac71ae',
          interaction: :input,
          value: '7 years.'
        },
        {
          locator: '2c1cc015-c579-4c80-954a-b10e627abbb9',
          interaction: :boolean,
          value: false
        },
        {
          locator: 'cf0f1bc7-7ce6-4eb3-aebc-b6562141cb68',
          interaction: :radiogroup,
          value: '30-39'
        },
        {
          locator: '8d7dcc65-3a0b-476a-b679-574b869780bb',
          interaction: :radiogroup,
          value: 'Another Gender Identity'
        },
        {
          locator: '0a90dc7e-908c-449f-9151-95612d844b10',
          interaction: :radiogroup,
          value: 'I prefer not to answer'
        },
        {
          locator: 'a63b6f87-d090-40f0-a462-bf5bb03f5e45',
          interaction: :multi_select,
          value: ['Lesbian', 'Gay', 'Queer', 'Other']
        },
        {
          locator: '1e21d43f-548e-481a-aa5f-f048c73f3de3',
          interaction: :multi_select,
          value: ['Asian - (Asian British, Indian, Pakistani, Bangladeshi, Chinese, Asian any other background)', 'Indigenous or Native American', 'Native Hawaiian or Other Pacific Islander', 'Mixed Ethnic Background', 'White']
        },
        {
          locator: '425ffaa2-f458-4327-84dc-1d65cd7622a7',
          interaction: :radiogroup,
          value: 'Yes'
        },
        {
          locator: '8869ac83-51af-43c9-a1f9-d0f43db306d8',
          interaction: :radiogroup,
          value: 'Yes'
        },
        {
          locator: '4ece9e72-c191-4c97-98dc-cc23b006799d',
          interaction: :radiogroup,
          value: 'Yes'
        }
      ]
    }
  ]

BAMBOO_PAYLOADS =
  [
    {
      epithet: :sample_payload,
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
      ]
    }
  ]

DEVITJOBS_PAYLOADS = [
  {
    epithet: :sample_payload,
    user_fullname: 'John Smith',
    apply_url: 'https://devitjobs.uk/jobs/Critical-Software-Software-Engineer',
    form_locator: 'form',
    fields: [
      {
        locator: 'name',
        interaction: :input,
        value: 'John Smith'
      },
      {
        locator: 'email',
        interaction: :input,
        value: 'j.smith@example.com'
      },
      {
        locator: 'isFromEurope',
        interaction: :radiogroup,
        value: 'Yes'
      },
      {
        locator: '#cvFileId',
        interaction: :upload,
        value: File.open('public/Obretetskiy_cv.pdf')
      },
      {
        locator: 'motivationLetter',
        interaction: :input,
        value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
      }
    ]
  }
]

GREENHOUSE_PAYLOADS = [
  {
    epithet: :sample_payload,
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
      {
        locator: 'cover_letter',
        interaction: :upload,
        value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
      },
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
  },
  {
    epithet: :cleoai_payload,
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
      {
        locator: 'cover_letter',
        interaction: :upload,
        value: 'Thank you for considering my application. It really is an honor to apply to your company. Please hire me. I would like to work here very much. I promise to work very very hard and always get along well with my coworkers.'
      },
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
]

GREENHOUSE_OLD_PAYLOADS = [
  {
    epithet: :codepath_payload,
    user_fullname: 'John Smith',
    apply_url: 'https://boards.greenhouse.io/codepath/jobs/4035988007#app',
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
        value: 'https://res.cloudinary.com/dzpupuayh/image/upload/v1/development/nd4p85sryuu40oz77n0bhs29b2sz.pdf?_a=BACCd2Bn'
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
]

WORKABLE_PAYLOADS = [
  {
    epithet: :sample_payload,
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
  },
  {
    epithet: :builderai_payload,
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
  },
  {
    epithet: :education_experience_payload,
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
]
