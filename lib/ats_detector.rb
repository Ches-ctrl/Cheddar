module AtsDetector
  def self.determine_ats
    name = ATS_SYSTEM_PARSER.find { |regex, ats_name| break ats_name if @string.match?(regex) }
    return ApplicantTrackingSystem.find_by(name:)
  end

  def self.build_ats_parser_from_db
    ats_mappings = {}
    p ats_mappings

    unique_url_identifiers_with_names = ApplicantTrackingSystem.distinct.order(:url_identifier).pluck(:url_identifier, :name)
    p unique_url_identifiers_with_names

    unique_url_identifiers_with_names.each do |url_identifiers, name|
      if url_identifiers.include?('|')
        individual_identifiers = url_identifiers.split('|')
      else
        individual_identifiers = [url_identifiers]
      end

      individual_identifiers.each do |identifier|
        regex_pattern = Regexp.new(identifier, Regexp::IGNORECASE)

        ats_mappings[regex_pattern] = name
      end
    end

    p ats_mappings
  end

  SUPPORTED_ATS_SYSTEMS = [
    "Greenhouse",
    "Lever",
    "Workable",
  ]

  ATS_SYSTEM_PARSER = {
    /adp/i => "ADP",
    /allibo/i => "Allibo",
    /amberjack/i => "Amberjack",
    /ambertrack/i => "Ambertrack",
    /applicantstack/i => "ApplicantStack",
    /applyflow/i => "Applyflow",
    /applytojob/i => "JazzHR",
    /ashby/i => "AshbyHQ",
    /authenticjobs/i => "Authentic Jobs",
    /avature/i => "Avature",
    /bamboohr/i => "BambooHR",
    /beamery/i => "Beamery",
    /brassring/i => "BrassRing",
    /breezyhr/i => "Breezy HR",
    /broadbean/i => "Broadbean",
    /bullhorn/i => "Bullhorn",
    /candidats/i => "CandidATS",
    /careercast/i => "Careercast",
    /careers-page/i => "Manatal",
    /catsone/i => "CATS",
    /cegid/i => "Cegid",
    /ceipal/i => "Ceipal",
    /changeworknow/i => "ChangeWorkNow",
    /clayhr/i => "ClayHR",
    /clearco/i => "ClearCo",
    /clockworkrecruiting/i => "Clockwork",
    /comeet/i => "Comeet",
    /crelate/i => "Crelate",
    /csod/i => "CSOD",
    /devitjobs/i => "DevITJobs",
    /dover/i => "Dover",
    /eightfold/i => "Eightfold",
    /employmenthero/i => "Employment Hero",
    /engage-ats/i => "EngageATS",
    /eploy/i => "Eploy",
    /factorialhr/i => "factorial",
    /findly/i => "Findly",
    /folk/i => "Folk",
    /fountain/i => "Fountain",
    /freshteam/i => "Freshteam",
    /gohire/i => "GoHire",
    /gr8people/i => "gr8people",
    /greenhouse/i => "Greenhouse",
    /gh_jid/i => "Greenhouse",
    /groupgti/i => "Group GTI",
    /harbourats/i => "Harbour ATS",
    /herpartner/i => "HRPartner",
    /hireology/i => "Hireology",
    /homerun/i => "Homerun",
    /hrcloud/i => "HR Cloud",
    /icims/i => "iCIMS",
    /inclusive/i => "Inclusive",
    /jobadder/i => "JobAdder",
    /jobinventory/i => "Jobinventory",
    /jobmate/i => "JobMate",
    /jobscore/i => "JobScore",
    /jobsoid/i => "Jobsoid",
    /jobvite/i => "Jobvite",
    /join.com/i => "Join",
    /juju/i => "Juju",
    /lano/i => "Lano",
    /lever/i => "Lever",
    /linkedin/i => "LinkedIn",
    /loxo/i => "Loxo",
    /myworkdayjobs/i => "Workday",
    /nebula/i => "Nebula.io",
    /njoyn/i => "njoyn",
    /occupop/i => "Occupop",
    /oleeo/i => "Oleeo Recruit",
    /otta/i => "Otta",
    /pageuppeople/i => "PageUp",
    /paradox/i => "Paradox",
    /paylocity/i => "Paylocity",
    /personio/i => "Personio",
    /phenom/i => "Phenom",
    /pinpoint/i => "PinpointHQ",
    /polymer/i => "Polymer",
    /recruitcrm/i => "RecruitCRM",
    /recruitee/i => "Recruitee",
    /recruiterbox/i => "Recruiterbox",
    /recruiterflow/i => "Recruiterflow",
    /recruitive/i => "Recruitive",
    /recruitty/i => "Recruitty",
    /rippling/i => "Rippling",
    /rival-hr/i => "Rival HR",
    /sagehr/i => "Sage",
    /sap/i => "SAP SuccessFactors",
    /screenloop/i => "Screenloop",
    /selectminds/i => "SelectMinds",
    /simplyhired/i => "Simplyhired",
    /smartrecruiters/i => "SmartRecruiters",
    /symphonytalent/i => "Symphony Talent",
    /tal.ai/i => "Tal.ai",
    /tal.net/i => "Tal.net",
    /talentbrew/i => "TalentBrew",
    /talentlyft/i => "TalentLyft",
    /talentreef/i => "TalentReef",
    /taleo/i => "Taleo",
    /talsuite/i => "TalSuite",
    /teamtailor/i => "TeamTailor",
    /tellent/i => "Tellent",
    /totaljobs/i => "TotalJobs",
    /ukg/i => "UKG",
    /vincere/i => "Vincere",
    /webrecruit/i => "Webrecruit",
    /workable/i => "Workable",
    /zoho/i => "Zoho Recruit"
  }
end
