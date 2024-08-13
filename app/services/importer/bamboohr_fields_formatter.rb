# frozen_string_literal: true

module Importer
  # This service object is responsible for formatting data received from Bamboohr, into a structured format suitable for our application.
  # It extracts specific sections (core questions and Details) and transforms them into a standardized format.
  # The output of this service is used by fields_builder.
  class BamboohrFieldsFormatter < FieldsFormatter
    private

    def select_transform_data
      @select_transform_data ||= {
        core_questions: { title: "Main application", description: nil, questions: core_questions(@data[:formFields].except(:customQuestions)) },
        additional_questions: additional_formatter(@data.dig(:formFields, :customQuestions))
      }
    end

    ###

    def core_questions(questions_data)
      return {} unless questions_data

      questions_data.map do |raw_attribute, raw_question|
        next unless raw_question.present?

        attribute = attribute(raw_attribute)
        options = (state_fields if raw_attribute == 'state') ||
                  raw_question[:options]&.map { |option| option.transform_keys({ 'id' => 'value', 'text' => 'label' }) } ||
                  [] # Daniel's edit (v v hacky!)
        type = input_type(attribute, raw_question[:type], options)
        fields = [{ name: raw_attribute, selector: nil, type:, options: }]
        label = attribute.underscore.humanize

        { attribute:, label:, description: nil, required: raw_question[:isRequired], fields: }
      end.compact
    end

    def additional_formatter(additional_data)
      return {} unless additional_data.present?

      {
        title: 'Additional questions',
        description: nil,
        questions: additional_questions(additional_data)
      }
    end

    def additional_questions(questions_data)
      return {} unless questions_data

      questions_data.map do |raw_question|
        attribute = attribute(raw_question[:question])
        options = ([{ value: 'yes', label: 'Yes' }, { value: 'no', label: 'No' }] if raw_question[:type] == 'yes_no') ||
                  raw_question[:options]&.map { |option| option.transform_keys({ 'id' => 'value', 'text' => 'label' }) } ||
                  [] # Daniel's edit (v v hacky!)
        type = input_type(attribute, raw_question[:type], options)
        fields = [{ name: "customQuestions[#{raw_question[:id]}]", selector: nil, type:, options: }] # Daniel's edit
        label = raw_question[:question]

        { attribute:, label:, description: nil, required: raw_question[:isRequired], fields: }
      end
    end

    ###
    ### attribute
    ###

    def attribute(raw_attribute)
      attribute_strict_match(raw_attribute) ||
        attribute_inclusive_match(raw_attribute) ||
        default_attribute(raw_attribute)
    end

    def attributes_dictionary = ATTRIBUTES_DICTIONARY

    ATTRIBUTES_DICTIONARY = {
      'firstName' => 'first_name',
      'lastName' => 'last_name',
      'email' => 'email',
      'streetAddress' => 'address_applicant',
      'city' => 'city_applicant',
      'state' => 'state_applicant',
      'zip' => 'zip_applicant',
      'countryId' => 'country_applicant',
      'phone' => 'phone_number',
      'linkedin' => 'linkedin',
      'coverLetterFileId' => 'cover_letter',
      'resumeFileId' => 'resume',
      'genderId' => 'gender',
      'ethnicityId' => 'ethnicity'
    }

    ###
    ### types
    ###

    def input_type(attribute, type, options)
      return :agreement_checkbox if type.eql?('checkbox') && options.empty?
      return :date_picker if attribute.eql?('date_available')
      return :yes_no_radiogroup if type.eql?('yes_no') # Daniel's edit
      return :select if options.present?
      return :upload if %w[resume cover_letter].include?(attribute)

      INPUT_TYPES[type] || :input
    end

    INPUT_TYPES = {
      'checkbox' => :select,
      'long' => :textarea,
      'short' => :input,
      'yes_no' => :yes_no_radiogroup
    }

    def output_file_name = 'bamboohr_formatter_output.json'

    ###
    ### Daniel's edit
    ###

    def state_fields = [{ value: "162", label: "Aberdeen City" }, { value: "161", label: "Aberdeenshire" }, { value: "165", label: "Angus" }, { value: "167", label: "Ards" }, { value: "163", label: "Argyll and Bute" }, { value: "178", label: "Ballymena" }, { value: "179", label: "Ballymoney" }, { value: "181", label: "Banbridge" }, { value: "171", label: "Barking and Dagenham" }, { value: "182", label: "Barnet" }, { value: "184", label: "Barnsley" }, { value: "169", label: "Bath and North East Somerset" }, { value: "115", label: "Bedford" }, { value: "174", label: "Belfast" }, { value: "116", label: "Berkshire" }, { value: "173", label: "Bexley" }, { value: "177", label: "Birmingham" }, { value: "170", label: "Blackburn with Darwen" }, { value: "186", label: "Blackpool" }, { value: "176", label: "Blaenau Gwent" }, { value: "185", label: "Bolton" }, { value: "180", label: "Bournemouth" }, { value: "187", label: "Bracknell Forest" }, { value: "188", label: "Bradford" }, { value: "172", label: "Brent" }, { value: "175", label: "Bridgend" }, { value: "183", label: "Brighton and Hove" }, { value: "190", label: "Bristol, City of" }, { value: "189", label: "Bromley" }, { value: "117", label: "Buckinghamshire" }, { value: "191", label: "Bury" }, { value: "192", label: "Caerphilly" }, { value: "199", label: "Calderdale" }, { value: "118", label: "Cambridgeshire" }, { value: "202", label: "Camden" }, { value: "205", label: "Cardiff" }, { value: "203", label: "Carmarthenshire" }, { value: "197", label: "Carrickfergus" }, { value: "207", label: "Castlereagh" }, { value: "193", label: "Central Bedfordshire" }, { value: "194", label: "Ceredigion" }, { value: "119", label: "Cheshire" }, { value: "196", label: "Cheshire East" }, { value: "160", label: "Cheshire West and Chester" }, { value: "200", label: "Clackmannanshire" }, { value: "201", label: "Coleraine" }, { value: "208", label: "Conwy" }, { value: "198", label: "Cookstown" }, { value: "120", label: "Cornwall" }, { value: "166", label: "County Antrim" }, { value: "168", label: "County Armagh" }, { value: "216", label: "County Down" }, { value: "229", label: "County Fermanagh" }, { value: "368", label: "County Londonderry" }, { value: "369", label: "County Tyrone" }, { value: "204", label: "Coventry" }, { value: "195", label: "Craigavon" }, { value: "206", label: "Croydon" }, { value: "121", label: "Cumbria" }, { value: "209", label: "Darlington" }, { value: "210", label: "Denbighshire" }, { value: "211", label: "Derby" }, { value: "122", label: "Derbyshire" }, { value: "217", label: "Derry" }, { value: "123", label: "Devon" }, { value: "124", label: "Didcot" }, { value: "214", label: "Doncaster" }, { value: "125", label: "Dorset" }, { value: "218", label: "Dudley" }, { value: "213", label: "Dumfries and Galloway" }, { value: "215", label: "Dundee City" }, { value: "212", label: "Dungannon" }, { value: "126", label: "Durham" }, { value: "219", label: "Ealing" }, { value: "220", label: "East Ayrshire" }, { value: "222", label: "East Dunbartonshire" }, { value: "223", label: "East Lothian" }, { value: "226", label: "East Renfrewshire" }, { value: "227", label: "East Riding of Yorkshire" }, { value: "127", label: "East Sussex" }, { value: "221", label: "Edinburgh, City of" }, { value: "224", label: "Eilean Siar" }, { value: "225", label: "Enfield" }, { value: "128", label: "Essex" }, { value: "228", label: "Falkirk" }, { value: "230", label: "Fife" }, { value: "231", label: "Flintshire" }, { value: "232", label: "Gateshead" }, { value: "233", label: "Glasgow City" }, { value: "129", label: "Gloucestershire" }, { value: "370", label: "Greater London" }, { value: "138", label: "Greater Manchester" }, { value: "234", label: "Greenwich" }, { value: "235", label: "Gwynedd" }, { value: "238", label: "Hackney" }, { value: "236", label: "Halton" }, { value: "241", label: "Hammersmith and Fulham" }, { value: "131", label: "Hampshire" }, { value: "245", label: "Haringey" }, { value: "244", label: "Harrow" }, { value: "243", label: "Hartlepool" }, { value: "237", label: "Havering" }, { value: "132", label: "Herefordshire" }, { value: "158", label: "Hertfordshire" }, { value: "240", label: "Highland" }, { value: "239", label: "Hillingdon" }, { value: "242", label: "Hounslow" }, { value: "248", label: "Inverclyde" }, { value: "164", label: "Isle of Anglesey" }, { value: "246", label: "Isle of Wight" }, { value: "362", label: "Isles of Scilly" }, { value: "247", label: "Islington" }, { value: "249", label: "Kensington and Chelsea" }, { value: "133", label: "Kent" }, { value: "250", label: "Kingston upon Hull" }, { value: "252", label: "Kingston upon Thames" }, { value: "251", label: "Kirklees" }, { value: "253", label: "Knowsley" }, { value: "254", label: "Lambeth" }, { value: "134", label: "Lancashire" }, { value: "260", label: "Larne" }, { value: "256", label: "Leeds" }, { value: "255", label: "Leicester" }, { value: "135", label: "Leicestershire" }, { value: "136", label: "Leinster" }, { value: "257", label: "Lewisham" }, { value: "259", label: "Limavady" }, { value: "137", label: "Lincolnshire" }, { value: "261", label: "Lisburn" }, { value: "258", label: "Liverpool" }, { value: "130", label: "London, City of" }, { value: "262", label: "Luton" }, { value: "265", label: "Magherafelt" }, { value: "264", label: "Medway" }, { value: "363", label: "Merseyside" }, { value: "271", label: "Merthyr Tydfil" }, { value: "269", label: "Merton" }, { value: "263", label: "Middlesbrough" }, { value: "159", label: "Middlesex" }, { value: "267", label: "Midlothian" }, { value: "266", label: "Milton Keynes" }, { value: "268", label: "Monmouthshire" }, { value: "270", label: "Moray" }, { value: "272", label: "Moyle" }, { value: "282", label: "Neath Port Talbot" }, { value: "276", label: "Newcastle upon Tyne" }, { value: "284", label: "Newham" }, { value: "285", label: "Newport" }, { value: "287", label: "Newry and Mourne" }, { value: "281", label: "Newtownabbey" }, { value: "139", label: "Norfolk" }, { value: "273", label: "North Ayrshire" }, { value: "274", label: "North Down" }, { value: "275", label: "North East Lincolnshire" }, { value: "278", label: "North Lanarkshire" }, { value: "279", label: "North Lincolnshire" }, { value: "280", label: "North Somerset" }, { value: "283", label: "North Tyneside" }, { value: "286", label: "North Yorkshire" }, { value: "140", label: "Northamptonshire" }, { value: "367", label: "Northern Ireland" }, { value: "141", label: "Northumberland" }, { value: "277", label: "Nottingham" }, { value: "142", label: "Nottinghamshire" }, { value: "288", label: "Oldham" }, { value: "289", label: "Omagh" }, { value: "290", label: "Orkney Islands" }, { value: "143", label: "Oxfordshire" }, { value: "291", label: "Pembrokeshire" }, { value: "292", label: "Perth and Kinross" }, { value: "297", label: "Peterborough" }, { value: "293", label: "Plymouth" }, { value: "294", label: "Poole" }, { value: "295", label: "Portsmouth" }, { value: "296", label: "Powys" }, { value: "302", label: "Reading" }, { value: "301", label: "Redbridge" }, { value: "298", label: "Redcar and Cleveland" }, { value: "303", label: "Renfrewshire" }, { value: "300", label: "Rhondda, Cynon, Taff" }, { value: "304", label: "Richmond upon Thames" }, { value: "299", label: "Rochdale" }, { value: "305", label: "Rotherham" }, { value: "144", label: "Rutland" }, { value: "314", label: "Salford" }, { value: "306", label: "Sandwell" }, { value: "308", label: "Scottish Borders, The" }, { value: "309", label: "Sefton" }, { value: "311", label: "Sheffield" }, { value: "353", label: "Shetland Islands" }, { value: "145", label: "Shropshire" }, { value: "315", label: "Slough" }, { value: "318", label: "Solihull" }, { value: "146", label: "Somerset" }, { value: "307", label: "South Ayrshire" }, { value: "147", label: "South Glamorgan" }, { value: "310", label: "South Gloucestershire" }, { value: "316", label: "South Lanarkshire" }, { value: "326", label: "South Tyneside" }, { value: "364", label: "South Yorkshire" }, { value: "323", label: "Southampton" }, { value: "319", label: "Southend-on-Sea" }, { value: "329", label: "Southwark" }, { value: "312", label: "St. Helens" }, { value: "148", label: "Staffordshire" }, { value: "322", label: "Stirling" }, { value: "313", label: "Stockport" }, { value: "325", label: "Stockton-on-Tees" }, { value: "321", label: "Stoke-on-Trent" }, { value: "320", label: "Strabane" }, { value: "149", label: "Suffolk" }, { value: "317", label: "Sunderland" }, { value: "150", label: "Surrey" }, { value: "324", label: "Sutton" }, { value: "327", label: "Swansea" }, { value: "328", label: "Swindon" }, { value: "330", label: "Tameside" }, { value: "331", label: "Telford and Wrekin" }, { value: "332", label: "Thurrock" }, { value: "333", label: "Torbay" }, { value: "334", label: "Torfaen" }, { value: "336", label: "Tower Hamlets" }, { value: "335", label: "Trafford" }, { value: "366", label: "Tyne and Wear" }, { value: "337", label: "Vale of Glamorgan, The" }, { value: "342", label: "Wakefield" }, { value: "343", label: "Walsall" }, { value: "340", label: "Waltham Forest" }, { value: "346", label: "Wandsworth" }, { value: "350", label: "Warrington" }, { value: "151", label: "Warwickshire" }, { value: "338", label: "West Berkshire" }, { value: "339", label: "West Dunbartonshire" }, { value: "344", label: "West Lothian" }, { value: "152", label: "West Midlands" }, { value: "157", label: "West Sussex" }, { value: "365", label: "West Yorkshire" }, { value: "153", label: "Western Cape" }, { value: "352", label: "Westminster" }, { value: "341", label: "Wigan" }, { value: "154", label: "Wiltshire" }, { value: "347", label: "Windsor and Maidenhead" }, { value: "349", label: "Wirral" }, { value: "348", label: "Wokingham" }, { value: "345", label: "Wolverhampton" }, { value: "155", label: "Worcestershire" }, { value: "351", label: "Wrexham" }, { value: "156", label: "York" }]
  end
end
