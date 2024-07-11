# rubocop:disable Lint/SymbolConversion
# rubocop:disable Style/NumericLiterals
# rubocop:disable Style/QuotedSymbols

EXAMPLES = {
  'AshbyHQ' => {
    endpoint: 'https://jobs.ashbyhq.com/api/non-user-graphql?op=ApiJobPosting',
    request_type: :post,
    headers: { 'Content-Type' => 'application/json' },
    body: {
      query: "query ApiJobPosting($organizationHostedJobsPageName: String!, $jobPostingId: String!) {  jobPosting(    organizationHostedJobsPageName: $organizationHostedJobsPageName    jobPostingId: $jobPostingId  ) {    applicationForm {      ...FormRenderParts      __typename    }    surveyForms {      ...FormRenderParts      __typename    }    applicationDeadline    __typename  }}fragment JSONBoxParts on JSONBox {  value  __typename}fragment FileParts on File {  id  filename  __typename}fragment FormFieldEntryParts on FormFieldEntry {  id  field  fieldValue {    ... on JSONBox {      ...JSONBoxParts      __typename    }    ... on File {      ...FileParts      __typename    }    ... on FileList {      files {        ...FileParts        __typename      }      __typename    }    __typename  }  isRequired  descriptionHtml  isHidden  __typename}fragment FormRenderParts on FormRender {  id  formControls {    identifier    title    __typename  }  errorMessages  sections {    fieldEntries {      ...FormFieldEntryParts      __typename    }    isHidden    __typename  }  sourceFormDefinitionId  __typename}",
      variables: {
        jobPostingId: job_id,
        organizationHostedJobsPageName: ats_identifier
      }
    }.to_json,
    example_response: {
      "data": {
        "jobPosting": {
          "applicationForm": {
            "id": "75b23552-aeb0-4df2-b0c4-9f690c199c2a",
            "formControls": [
              {
                "identifier": "cf5b46c2-9308-40a4-8b4f-3adf86b5ed0e",
                "title": "Submit",
                "__typename": "FormControl"
              }
            ],
            "errorMessages": [],
            "sections": [
              {
                "fieldEntries": [
                  {
                    "id": "75b23552-aeb0-4df2-b0c4-9f690c199c2a__systemfield_name",
                    "field": {
                      "id": "f0013947-99aa-4e66-88aa-0a57f2d3fdad",
                      "path": "_systemfield_name",
                      "humanReadablePath": "Name",
                      "title": "Name",
                      "isNullable": false,
                      "isPrivate": false,
                      "isDeactivated": false,
                      "isMany": false,
                      "metadata": {},
                      "type": "String",
                      "__autoSerializationID": "StringField"
                    },
                    "fieldValue": null,
                    "isRequired": true,
                    "descriptionHtml": "<p>First and last name please!</p>",
                    "isHidden": null,
                    "__typename": "FormFieldEntry"
                  },
                  {
                    "id": "75b23552-aeb0-4df2-b0c4-9f690c199c2a__systemfield_email",
                    "field": {
                      "id": "2319052d-8473-4a03-a0ab-7f4a27952863",
                      "path": "_systemfield_email",
                      "humanReadablePath": "Email",
                      "title": "Email",
                      "isNullable": false,
                      "isPrivate": false,
                      "isDeactivated": false,
                      "isMany": false,
                      "metadata": {},
                      "type": "Email",
                      "__autoSerializationID": "EmailField"
                    },
                    "fieldValue": null,
                    "isRequired": true,
                    "descriptionHtml": null,
                    "isHidden": null,
                    "__typename": "FormFieldEntry"
                  },
                  {
                    "id": "75b23552-aeb0-4df2-b0c4-9f690c199c2a_00415714-75f3-49b9-b856-ac674fd5ce8b",
                    "field": {
                      "id": "528f00db-a256-4d66-bcf6-d16a047937b1",
                      "path": "00415714-75f3-49b9-b856-ac674fd5ce8b",
                      "humanReadablePath": "",
                      "title": "Where are you based or where would you be planning on working from?",
                      "isNullable": false,
                      "isPrivate": false,
                      "isDeactivated": false,
                      "isMany": false,
                      "metadata": {},
                      "type": "Location",
                      "locationTypes": [
                        "City"
                      ],
                      "__autoSerializationID": "LocationField"
                    },
                    "fieldValue": null,
                    "isRequired": true,
                    "descriptionHtml": null,
                    "isHidden": null,
                    "__typename": "FormFieldEntry"
                  },
                  {
                    "id": "75b23552-aeb0-4df2-b0c4-9f690c199c2a_36913b1f-c34f-4693-919c-400304a2a11d",
                    "field": {
                      "id": "6248f4e8-ccb5-45aa-9ef7-b38de8da16eb",
                      "path": "36913b1f-c34f-4693-919c-400304a2a11d",
                      "humanReadablePath": "",
                      "title": "Can we get a link to your Linkedin profile? ",
                      "isNullable": false,
                      "isPrivate": false,
                      "isDeactivated": false,
                      "isMany": false,
                      "metadata": {},
                      "type": "String",
                      "__autoSerializationID": "StringField"
                    },
                    "fieldValue": null,
                    "isRequired": true,
                    "descriptionHtml": null,
                    "isHidden": null,
                    "__typename": "FormFieldEntry"
                  },
                  {
                    "id": "75b23552-aeb0-4df2-b0c4-9f690c199c2a_f93bff8c-2442-42b7-b040-3876fa160aba",
                    "field": {
                      "id": "a762db6f-cba9-4af1-b9ec-d9d50c1b6d7b",
                      "path": "f93bff8c-2442-42b7-b040-3876fa160aba",
                      "humanReadablePath": "",
                      "title": "Can you tell us what attracted you to apply to Lightdash?",
                      "isNullable": false,
                      "isPrivate": false,
                      "isDeactivated": false,
                      "isMany": false,
                      "metadata": {},
                      "type": "LongText",
                      "__autoSerializationID": "LongTextField"
                    },
                    "fieldValue": null,
                    "isRequired": true,
                    "descriptionHtml": "<p>We don't need a whole cover letter, a couple of sentences will do!</p>",
                    "isHidden": null,
                    "__typename": "FormFieldEntry"
                  },
                  {
                    "id": "75b23552-aeb0-4df2-b0c4-9f690c199c2a__systemfield_resume",
                    "field": {
                      "id": "8601dd9e-cc55-4da5-a58f-86378310f9e2",
                      "path": "_systemfield_resume",
                      "humanReadablePath": "Resume",
                      "title": "Do you have a resume or CV you can share? ",
                      "isNullable": false,
                      "isPrivate": false,
                      "isDeactivated": false,
                      "isMany": false,
                      "metadata": {},
                      "type": "File",
                      "__autoSerializationID": "FileField"
                    },
                    "fieldValue": null,
                    "isRequired": false,
                    "descriptionHtml": null,
                    "isHidden": null,
                    "__typename": "FormFieldEntry"
                  }
                ],
                "isHidden": null,
                "__typename": "FormSectionRender"
              }
            ],
            "sourceFormDefinitionId": "4e97c17b-3a1a-4385-b4f3-d521e707a7a4",
            "__typename": "FormRender"
          },
          "surveyForms": [],
          "applicationDeadline": null,
          "__typename": "JobPostingDetails"
        }
      }
    }
  },
  'BambooHR' => {
    endpoint: "https://#{ats_identifier}.bamboohr.com/careers/#{job_id}/detail",
    request_type: :get,
    example_response: {
      "meta": {},
      "result": {
        "jobOpening": {
          "jobOpeningShareUrl": "https://avidbots.bamboohr.com/careers/529",
          "jobOpeningName": "Customer Care Associate, RA Shift Lead",
          "jobOpeningStatus": "Filled",
          "jobCategoryId": null,
          "departmentId": "19492",
          "departmentLabel": "Support Operations",
          "employmentStatusLabel": "Full-Time",
          "location": {
            "city": "Cali",
            "state": "Colombia",
            "postalCode": "Cra. 58 #3-08",
            "addressCountry": "Colombia"
          },
          "atsLocation": {
            "country": null,
            "countryId": null,
            "state": null,
            "city": null
          },
          "description": "<p><span>Avidbots like one of the cores of the company, offer comprehensive sales, service, and support to our customers on four continents and do its best to make sure the experience with the robot is extraordinary, </span><span>always aiming at the success of our clients.</span></p>\r\n<p><br></p>\r\n<p>Is also important for us as a company to offer <span>professional growth to the talent we have and make of their experience in what we do, one of our greatest assets. That is why in this opportunity we are opening an internal vacancy for the RM shift leader role. </span></p>\r\n<p><br></p>\r\n<p>The shift leader is the person in charge of guaranteeing the efficient functioning of the operation during the day; this implies carrying out the organization of the shift, verifying that the tickets are made in Jira, and ensuring that the assistance is as fast and efficient as possible assuring good management of customer service in communication channels, both with internal and external customers.</p>\r\n<p>Must provide support and feedback to team members and safeguard that the team works as a single unit. Will have a direct connection with the team manager to evaluate the group's performance monthly.</p>\r\n<p><br></p>\r\n<p>So, apply now if you think you have what it takes to help us to make our customer's experience better every time. Thank you!.</p>",
          "compensation": "2175000",
          "datePosted": "2022-09-07",
          "minimumExperience": "Experienced",
          "locationType": "2"
        },
        "formFields": {
          "firstName": {
            "isRequired": true,
            "value": ""
          },
          "lastName": {
            "isRequired": true,
            "value": ""
          },
          "email": {
            "isRequired": true,
            "value": ""
          },
          "phone": {
            "isRequired": true,
            "value": ""
          },
          "resumeFileId": {
            "isRequired": true,
            "value": ""
          },
          "desiredPay": {
            "isRequired": false,
            "value": ""
          },
          "streetAddress": {
            "isRequired": true,
            "value": ""
          },
          "city": {
            "isRequired": true,
            "value": ""
          },
          "state": {
            "isRequired": true,
            "value": "",
            "options": []
          },
          "zip": {
            "isRequired": true,
            "value": ""
          },
          "countryId": {
            "isRequired": true,
            "value": "47",
            "options": [
              {
                "id": "1",
                "text": "United States"
              },
              {
                "id": "2",
                "text": "Canada"
              },
              {
                "id": "3",
                "text": "Australia"
              },
              {
                "id": "4",
                "text": "Afghanistan"
              },
              {
                "id": "5",
                "text": "Albania"
              },
              {
                "id": "6",
                "text": "Algeria"
              },
              {
                "id": "7",
                "text": "American Samoa"
              },
              {
                "id": "8",
                "text": "Andorra"
              },
              {
                "id": "9",
                "text": "Anguilla"
              },
              {
                "id": "10",
                "text": "Angola"
              },
              {
                "id": "11",
                "text": "Antarctica"
              },
              {
                "id": "12",
                "text": "Antigua and Barbuda"
              },
              {
                "id": "13",
                "text": "Argentina"
              },
              {
                "id": "14",
                "text": "Armenia"
              },
              {
                "id": "15",
                "text": "Aruba"
              },
              {
                "id": "16",
                "text": "Austria"
              },
              {
                "id": "17",
                "text": "Azerbaijan"
              },
              {
                "id": "18",
                "text": "Bahamas"
              },
              {
                "id": "19",
                "text": "Bahrain"
              },
              {
                "id": "20",
                "text": "Bangladesh"
              },
              {
                "id": "21",
                "text": "Barbados"
              },
              {
                "id": "22",
                "text": "Belgium"
              },
              {
                "id": "23",
                "text": "Belize"
              },
              {
                "id": "24",
                "text": "Benin"
              },
              {
                "id": "25",
                "text": "Bermuda"
              },
              {
                "id": "26",
                "text": "Bhutan"
              },
              {
                "id": "27",
                "text": "Bolivia"
              },
              {
                "id": "28",
                "text": "Bosnia and Herzegovina"
              },
              {
                "id": "29",
                "text": "Botswana"
              },
              {
                "id": "30",
                "text": "Bouvet Island"
              },
              {
                "id": "31",
                "text": "Brazil"
              },
              {
                "id": "32",
                "text": "British Indian Ocean Territory"
              },
              {
                "id": "33",
                "text": "Brunei Darussalam"
              },
              {
                "id": "34",
                "text": "Bulgaria"
              },
              {
                "id": "35",
                "text": "Burkina Faso"
              },
              {
                "id": "36",
                "text": "Burundi"
              },
              {
                "id": "37",
                "text": "Cambodia"
              },
              {
                "id": "38",
                "text": "Cameroon"
              },
              {
                "id": "39",
                "text": "Cape Verde"
              },
              {
                "id": "40",
                "text": "Cayman Islands"
              },
              {
                "id": "41",
                "text": "Central African Republic"
              },
              {
                "id": "42",
                "text": "Chad"
              },
              {
                "id": "43",
                "text": "Chile"
              },
              {
                "id": "44",
                "text": "China"
              },
              {
                "id": "45",
                "text": "Christmas Island"
              },
              {
                "id": "46",
                "text": "Cocos (Keeling Islands)"
              },
              {
                "id": "47",
                "text": "Colombia"
              },
              {
                "id": "48",
                "text": "Comoros"
              },
              {
                "id": "49",
                "text": "Congo"
              },
              {
                "id": "50",
                "text": "Cook Islands"
              },
              {
                "id": "51",
                "text": "Costa Rica"
              },
              {
                "id": "52",
                "text": "Cote D'Ivoire (Ivory Coast)"
              },
              {
                "id": "53",
                "text": "Croatia (Hrvatska)"
              },
              {
                "id": "54",
                "text": "Cuba"
              },
              {
                "id": "55",
                "text": "Cyprus"
              },
              {
                "id": "56",
                "text": "Czech Republic"
              },
              {
                "id": "57",
                "text": "Denmark"
              },
              {
                "id": "58",
                "text": "Djibouti"
              },
              {
                "id": "59",
                "text": "Dominica"
              },
              {
                "id": "60",
                "text": "Dominican Republic"
              },
              {
                "id": "61",
                "text": "East Timor"
              },
              {
                "id": "62",
                "text": "Egypt"
              },
              {
                "id": "63",
                "text": "El Salvador"
              },
              {
                "id": "64",
                "text": "Ecuador"
              },
              {
                "id": "65",
                "text": "Equatorial Guinea"
              },
              {
                "id": "66",
                "text": "Eritrea"
              },
              {
                "id": "67",
                "text": "Estonia"
              },
              {
                "id": "68",
                "text": "Ethiopia"
              },
              {
                "id": "69",
                "text": "Falkland Islands (Malvinas)"
              },
              {
                "id": "70",
                "text": "Faroe Islands"
              },
              {
                "id": "71",
                "text": "Fiji"
              },
              {
                "id": "72",
                "text": "Finland"
              },
              {
                "id": "73",
                "text": "France"
              },
              {
                "id": "74",
                "text": "France, Metropolitan"
              },
              {
                "id": "75",
                "text": "French Guiana"
              },
              {
                "id": "76",
                "text": "French Polynesia"
              },
              {
                "id": "77",
                "text": "French Southern Territories"
              },
              {
                "id": "78",
                "text": "French West Indies"
              },
              {
                "id": "79",
                "text": "Gabon"
              },
              {
                "id": "80",
                "text": "Gambia"
              },
              {
                "id": "81",
                "text": "Georgia"
              },
              {
                "id": "82",
                "text": "Germany"
              },
              {
                "id": "83",
                "text": "Ghana"
              },
              {
                "id": "84",
                "text": "Gibraltar"
              },
              {
                "id": "85",
                "text": "Greece"
              },
              {
                "id": "86",
                "text": "Greenland"
              },
              {
                "id": "87",
                "text": "Grenada"
              },
              {
                "id": "88",
                "text": "Guadeloupe"
              },
              {
                "id": "89",
                "text": "Guam"
              },
              {
                "id": "90",
                "text": "Guatemala"
              },
              {
                "id": "91",
                "text": "Guinea"
              },
              {
                "id": "92",
                "text": "Guinea-Bissau"
              },
              {
                "id": "93",
                "text": "Guyana"
              },
              {
                "id": "94",
                "text": "Haiti"
              },
              {
                "id": "95",
                "text": "Heard and McDonald Islands"
              },
              {
                "id": "96",
                "text": "Honduras"
              },
              {
                "id": "97",
                "text": "Hong Kong"
              },
              {
                "id": "98",
                "text": "Hungary"
              },
              {
                "id": "99",
                "text": "Iceland"
              },
              {
                "id": "100",
                "text": "India"
              },
              {
                "id": "101",
                "text": "Indonesia"
              },
              {
                "id": "102",
                "text": "Iran"
              },
              {
                "id": "103",
                "text": "Iraq"
              },
              {
                "id": "104",
                "text": "Ireland"
              },
              {
                "id": "105",
                "text": "Israel"
              },
              {
                "id": "106",
                "text": "Italy"
              },
              {
                "id": "107",
                "text": "Jamaica"
              },
              {
                "id": "108",
                "text": "Japan"
              },
              {
                "id": "109",
                "text": "Jordan"
              },
              {
                "id": "110",
                "text": "Kazakhstan"
              },
              {
                "id": "111",
                "text": "Kenya"
              },
              {
                "id": "112",
                "text": "Kiribati"
              },
              {
                "id": "113",
                "text": "Korea (North)"
              },
              {
                "id": "114",
                "text": "Korea (South)"
              },
              {
                "id": "115",
                "text": "Kuwait"
              },
              {
                "id": "116",
                "text": "Kyrgyzstan"
              },
              {
                "id": "117",
                "text": "Laos"
              },
              {
                "id": "118",
                "text": "Latvia"
              },
              {
                "id": "119",
                "text": "Lebanon"
              },
              {
                "id": "120",
                "text": "Lesotho"
              },
              {
                "id": "121",
                "text": "Liberia"
              },
              {
                "id": "122",
                "text": "Libya"
              },
              {
                "id": "123",
                "text": "Liechtenstein"
              },
              {
                "id": "124",
                "text": "Lithuania"
              },
              {
                "id": "125",
                "text": "Luxembourg"
              },
              {
                "id": "126",
                "text": "Macao"
              },
              {
                "id": "127",
                "text": "Macedonia"
              },
              {
                "id": "128",
                "text": "Madagascar"
              },
              {
                "id": "129",
                "text": "Malawi"
              },
              {
                "id": "130",
                "text": "Malaysia"
              },
              {
                "id": "131",
                "text": "Maldives"
              },
              {
                "id": "132",
                "text": "Mali"
              },
              {
                "id": "133",
                "text": "Malta"
              },
              {
                "id": "134",
                "text": "Marshall Islands"
              },
              {
                "id": "135",
                "text": "Martinique"
              },
              {
                "id": "136",
                "text": "Mauritania"
              },
              {
                "id": "137",
                "text": "Mauritius"
              },
              {
                "id": "138",
                "text": "Mayotte"
              },
              {
                "id": "139",
                "text": "Mexico"
              },
              {
                "id": "140",
                "text": "Micronesia"
              },
              {
                "id": "141",
                "text": "Moldova"
              },
              {
                "id": "142",
                "text": "Monaco"
              },
              {
                "id": "143",
                "text": "Mongolia"
              },
              {
                "id": "144",
                "text": "Montenegro"
              },
              {
                "id": "145",
                "text": "Montserrat"
              },
              {
                "id": "146",
                "text": "Morocco"
              },
              {
                "id": "147",
                "text": "Mozambique"
              },
              {
                "id": "148",
                "text": "Namibia"
              },
              {
                "id": "149",
                "text": "Nauru"
              },
              {
                "id": "150",
                "text": "Nepal"
              },
              {
                "id": "151",
                "text": "Netherlands"
              },
              {
                "id": "152",
                "text": "Netherlands Antilles"
              },
              {
                "id": "153",
                "text": "New Caledonia"
              },
              {
                "id": "154",
                "text": "New Zealand"
              },
              {
                "id": "155",
                "text": "Nicaragua"
              },
              {
                "id": "156",
                "text": "Niger"
              },
              {
                "id": "157",
                "text": "Nigeria"
              },
              {
                "id": "158",
                "text": "Niue"
              },
              {
                "id": "159",
                "text": "Norfolk Island"
              },
              {
                "id": "160",
                "text": "Northern Mariana Islands"
              },
              {
                "id": "161",
                "text": "Norway"
              },
              {
                "id": "162",
                "text": "Oman"
              },
              {
                "id": "163",
                "text": "Pakistan"
              },
              {
                "id": "164",
                "text": "Palau"
              },
              {
                "id": "165",
                "text": "Panama"
              },
              {
                "id": "166",
                "text": "Papua New Guinea"
              },
              {
                "id": "167",
                "text": "Paraguay"
              },
              {
                "id": "168",
                "text": "Peru"
              },
              {
                "id": "169",
                "text": "Philippines"
              },
              {
                "id": "170",
                "text": "Pitcairn"
              },
              {
                "id": "171",
                "text": "Poland"
              },
              {
                "id": "172",
                "text": "Portugal"
              },
              {
                "id": "173",
                "text": "Puerto Rico"
              },
              {
                "id": "174",
                "text": "Qatar"
              },
              {
                "id": "175",
                "text": "Rwanda"
              },
              {
                "id": "176",
                "text": "Reunion"
              },
              {
                "id": "177",
                "text": "Romania"
              },
              {
                "id": "178",
                "text": "Russian Federation"
              },
              {
                "id": "179",
                "text": "Samoa"
              },
              {
                "id": "180",
                "text": "San Marino"
              },
              {
                "id": "181",
                "text": "Sao Tome and Principe"
              },
              {
                "id": "182",
                "text": "Saudi Arabia"
              },
              {
                "id": "183",
                "text": "Senegal"
              },
              {
                "id": "184",
                "text": "Serbia"
              },
              {
                "id": "185",
                "text": "Seychelles"
              },
              {
                "id": "186",
                "text": "Sierra Leone"
              },
              {
                "id": "187",
                "text": "Singapore"
              },
              {
                "id": "188",
                "text": "Slovakia"
              },
              {
                "id": "189",
                "text": "Slovenia"
              },
              {
                "id": "190",
                "text": "Solomon Islands"
              },
              {
                "id": "191",
                "text": "South Africa"
              },
              {
                "id": "192",
                "text": "Spain"
              },
              {
                "id": "193",
                "text": "Sri Lanka"
              },
              {
                "id": "194",
                "text": "St. Helena"
              },
              {
                "id": "195",
                "text": "Saint Kitts and Nevis"
              },
              {
                "id": "196",
                "text": "Saint Lucia"
              },
              {
                "id": "197",
                "text": "St. Pierre and Miquelon"
              },
              {
                "id": "198",
                "text": "Saint Vincent and the Grenadines"
              },
              {
                "id": "199",
                "text": "Sudan"
              },
              {
                "id": "200",
                "text": "Suriname"
              },
              {
                "id": "201",
                "text": "Svalbard"
              },
              {
                "id": "202",
                "text": "Swaziland"
              },
              {
                "id": "203",
                "text": "Sweden"
              },
              {
                "id": "204",
                "text": "Switzerland"
              },
              {
                "id": "205",
                "text": "Syria"
              },
              {
                "id": "206",
                "text": "Taiwan"
              },
              {
                "id": "207",
                "text": "Tajikistan"
              },
              {
                "id": "208",
                "text": "Tanzania"
              },
              {
                "id": "209",
                "text": "Thailand"
              },
              {
                "id": "210",
                "text": "Togo"
              },
              {
                "id": "211",
                "text": "Tokelau"
              },
              {
                "id": "212",
                "text": "Tonga"
              },
              {
                "id": "213",
                "text": "Trinidad and Tobago"
              },
              {
                "id": "214",
                "text": "Tunisia"
              },
              {
                "id": "215",
                "text": "Turkey"
              },
              {
                "id": "216",
                "text": "Turkmenistan"
              },
              {
                "id": "217",
                "text": "Turks and Caicos Islands"
              },
              {
                "id": "218",
                "text": "Tuvalu"
              },
              {
                "id": "219",
                "text": "Uganda"
              },
              {
                "id": "220",
                "text": "Ukraine"
              },
              {
                "id": "221",
                "text": "United Arab Emirates"
              },
              {
                "id": "222",
                "text": "United Kingdom"
              },
              {
                "id": "223",
                "text": "US Minor Outlying Islands"
              },
              {
                "id": "224",
                "text": "Uruguay"
              },
              {
                "id": "225",
                "text": "Uzbekistan"
              },
              {
                "id": "226",
                "text": "Vanuatu"
              },
              {
                "id": "227",
                "text": "Vatican City State"
              },
              {
                "id": "228",
                "text": "Venezuela"
              },
              {
                "id": "229",
                "text": "Viet Nam"
              },
              {
                "id": "230",
                "text": "Virgin Islands (British)"
              },
              {
                "id": "231",
                "text": "Virgin Islands, U.S."
              },
              {
                "id": "232",
                "text": "Wallis and Futuna Islands"
              },
              {
                "id": "233",
                "text": "Western Sahara"
              },
              {
                "id": "234",
                "text": "Yemen"
              },
              {
                "id": "235",
                "text": "Yugoslavia"
              },
              {
                "id": "236",
                "text": "Zaire"
              },
              {
                "id": "237",
                "text": "Zambia"
              },
              {
                "id": "238",
                "text": "Åland Islands"
              },
              {
                "id": "239",
                "text": "Saint Barthélemy"
              },
              {
                "id": "240",
                "text": "Bonaire, Sint Eustatius and Saba"
              },
              {
                "id": "241",
                "text": "Belarus"
              },
              {
                "id": "242",
                "text": "Congo, the Democratic Republic of the"
              },
              {
                "id": "243",
                "text": "Curaçao"
              },
              {
                "id": "244",
                "text": "Guernsey"
              },
              {
                "id": "245",
                "text": "South Georgia and the South Sandwich Islands"
              },
              {
                "id": "246",
                "text": "Isle of Man"
              },
              {
                "id": "247",
                "text": "Jersey"
              },
              {
                "id": "248",
                "text": "Myanmar"
              },
              {
                "id": "249",
                "text": "Palestinian Territories"
              },
              {
                "id": "250",
                "text": "Somalia"
              },
              {
                "id": "251",
                "text": "South Sudan"
              },
              {
                "id": "252",
                "text": "Sint Maarten (Dutch part)"
              },
              {
                "id": "253",
                "text": "Zimbabwe"
              },
              {
                "id": "254",
                "text": "Kosovo"
              },
              {
                "id": "255",
                "text": "Kurdistan"
              },
              {
                "id": "256",
                "text": "Saint Martin (French part)"
              }
            ]
          },
          "linkedinUrl": {
            "isRequired": false,
            "value": ""
          },
          "dateAvailable": {
            "isRequired": false,
            "value": ""
          },
          "websiteUrl": {
            "isRequired": false,
            "value": ""
          },
          "customQuestions": [],
          "genderId": [],
          "ethnicityId": [],
          "veteranStatusId": [],
          "disabilityId": []
        }
      }
    }
  },
  'Greenhouse' => {
    endpoint: "https://boards-api.greenhouse.io/v1/boards/#{ats_identifier}/jobs/#{job_id}?questions=true&location_questions=true&demographic_questions=true&&compliance=true&pay_transparency=true",
    request_type: :get,
    example_response: {
      "absolute_url": "https://boards.greenhouse.io/cleoai/jobs/4628944002",
      "data_compliance": [
        {
          "type": "gdpr",
          "requires_consent": false,
          "requires_processing_consent": false,
          "requires_retention_consent": false,
          "retention_period": null
        }
      ],
      "internal_job_id": 4490235002,
      "location": {
        "name": "London"
      },
      "metadata": null,
      "id": 4628944002,
      "updated_at": "2024-05-14T06:37:24-04:00",
      "requisition_id": "48",
      "title": "Senior Backend Ruby Engineer ",
      "pay_input_ranges": [],
      "content": "&lt;section class=&quot;section section--text&quot;&gt;\n&lt;p&gt;&lt;em&gt;We strongly encourage applications from people of colour, the LGBTQ+ community, people with disabilities, neurodivergent people, parents, carers, and people from lower socio-economic backgrounds.&lt;/em&gt;&lt;/p&gt;\n&lt;p&gt;&lt;em&gt;If there’s anything we can do to accommodate your specific situation, please let us know.&lt;/em&gt;&lt;/p&gt;\n&lt;p&gt;&lt;strong&gt;About Cleo&lt;/strong&gt;&lt;/p&gt;\n&lt;p&gt;Most people come to Cleo to do work that matters. Every day, we empower people to build a life beyond their next paycheck, building a beloved AI that enables you to forge your own path toward financial well-being.&lt;/p&gt;\n&lt;p&gt;Backed by some of the most well-known investors in tech, we’ve reached millions of people to support them throughout their financial lives, from their first paycheck to their first home and beyond. We&#39;re hitting headlines too. This year, Forbes named us as one of their &lt;a href=&quot;https://www.forbes.com/sites/amyfeldman/2023/08/15/next-billion-dollar-startups-2023/&quot;&gt;Next Billion Dollar Startups&lt;/a&gt;, and we were crowned the &#39;Hottest Tech Scaleup&#39; at the Europas.&lt;/p&gt;\n&lt;p&gt;&lt;a href=&quot;https://www.linkedin.com/company/cleo-ai/&quot;&gt;Follow us on LinkedIn&lt;/a&gt; to keep up to date with new product features and insights from the team.&lt;/p&gt;\n&lt;h3&gt;&lt;strong&gt;What you&#39;ll be doing&lt;/strong&gt;&lt;/h3&gt;\n&lt;ul&gt;\n&lt;li&gt;Joining a cross-functional product squad and collaborating with a mix of engineers, designers, analysts and other disciplines to develop features that enhance our users&#39; financial health.&lt;/li&gt;\n&lt;li&gt;Collaborating with other senior peers in your squad and pillar to provide technical insight into upcoming work, and leading the delivery by helping pull everyone together to get it shipped.&lt;/li&gt;\n&lt;li&gt;Mentoring colleagues to help them grow as engineers and actively supporting their development.&lt;/li&gt;\n&lt;li&gt;Working on our Ruby on Rails monolith, building data models, APIs, and business logic services.&lt;/li&gt;\n&lt;li&gt;Delivering your work using agile methodologies and tools like tests, observability, AB-tests, and feature flags.&lt;/li&gt;\n&lt;li&gt;Analyzing data to identify problems and generate new ideas, using various sources such as our database, application logs, and user research data.&lt;/li&gt;\n&lt;li&gt;Supporting colleagues through in-hours support and optionally joining the compensated out-of-hours on-call rotation.&lt;/li&gt;\n&lt;li&gt;Contributing to cross-cutting concerns that improve our engineering efforts.&lt;/li&gt;\n&lt;li&gt;Taking part in shaping the work of your squad beyond technical aspects, participating in product ideation, user research, design reviews, retrospectives, and more.&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;Here are some examples, big and small, of the kinds of product feature work our engineers have taken part in over the last year:&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;Building a secured credit card&lt;/li&gt;\n&lt;li&gt;Launching new budget analysis features&lt;/li&gt;\n&lt;li&gt;implementing pricing experiments for subscriptions&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;Want to hear more from our engineers? &lt;a href=&quot;https://web.meetcleo.com/blog/what-do-you-do-backend-engineer&quot; target=&quot;_blank&quot;&gt;Check out Magda&#39;s blog post.&amp;nbsp;&lt;/a&gt;&lt;/p&gt;\n&lt;h3&gt;About you&lt;/h3&gt;\n&lt;p&gt;You are passionate about making a positive difference in society by improving the financial health of our users. You align with our&amp;nbsp;&lt;a href=&quot;https://web.meetcleo.com/life-at-cleo&quot;&gt;company values&lt;/a&gt;&amp;nbsp;and&amp;nbsp;&lt;a href=&quot;https://web.meetcleo.com/blog/cleo-engineering-principles&quot;&gt;engineering principles&lt;/a&gt;, which drive our ways of working and software delivery.&lt;/p&gt;\n&lt;p&gt;As this is a SE3-SE4 position as described in our &lt;a href=&quot;https://cleo-ai.progressionapp.com/&quot;&gt;public progression framework&lt;/a&gt; we’re looking for someone who has at least 4 years industry experience of using Ruby on Rails. If it’s not quite that much, maybe you want to look at our standard &lt;a href=&quot;https://boards.greenhouse.io/cleoai/jobs/5033034002&quot; target=&quot;_blank&quot;&gt;Backend role&lt;/a&gt;.&lt;/p&gt;\n&lt;h3&gt;&lt;strong&gt;What do you get for all your hard work?&lt;/strong&gt;&lt;/h3&gt;\n&lt;ul&gt;\n&lt;li&gt;&lt;strong&gt;A competitive compensation package (£90,034 - £109,763 base&amp;nbsp; + equity for SE4 | £71,774&amp;nbsp; - £90,035 base + equity for SE3)&lt;/strong&gt;. You can view our public progression framework and salary bandings here:&amp;nbsp;&lt;a href=&quot;https://cleo-ai.progressionapp.com/&quot;&gt;https://cleo-ai.progressionapp.com/&lt;/a&gt;&lt;/li&gt;\n&lt;li&gt;Work at one of the fastest-growing tech startups, backed by top VC firms, Sofina, Balderton &amp;amp; EQT Ventures&lt;/li&gt;\n&lt;li&gt;&lt;strong&gt;A clear progression plan.&lt;/strong&gt;&amp;nbsp;We want you to keep growing. That means trying new things, leading others, challenging the status quo and owning your impact. Always with our complete support.&lt;/li&gt;\n&lt;li&gt;&lt;strong&gt;Flexibility&lt;/strong&gt;: We can’t fight for the world’s financial health if we’re not healthy ourselves. We work with everyone to make sure they have the balance they need to do their best work.&lt;/li&gt;\n&lt;li&gt;&lt;strong&gt;Hybrid-first: &lt;/strong&gt;Join our hybrid-first team, where we blend the best of both remote and in-office work. We expect our team members to be in our London office 1-2 times a week. On Thursdays, we buy you lunch but you can come in whichever days work best! We can consider fully-remote candidates for SE4 level - for our remote employees we&#39;ll cover your travel to the London office every term (every four months).&lt;/li&gt;\n&lt;li&gt;Other benefits;\n&lt;ul&gt;\n&lt;li&gt;\n&lt;ul&gt;\n&lt;li&gt;Check out our new benefits package here:&amp;nbsp;&lt;a href=&quot;https://web.meetcleo.com/blog/big-benefits-energy-the-latest-cleo-employee-benefits&quot;&gt;https://web.meetcleo.com/blog/big-benefits-energy-the-latest-cleo-employee-benefits&lt;/a&gt;&lt;/li&gt;\n&lt;li&gt;25 days annual leave a year + public holidays (+ an additional day for every year you spend at Cleo)&lt;/li&gt;\n&lt;li&gt;6% employer-matched pension&amp;nbsp;&lt;/li&gt;\n&lt;li&gt;Company-wide performance reviews every 8 months e.g every 2 terms, in line with our termly cycles (Jan-April, May-Aug, Sept-Dec):\n&lt;ul&gt;\n&lt;li&gt;Generous pay increases for high-performers and high-growth team members&lt;/li&gt;\n&lt;li&gt;Equity top-ups for team members getting promoted&lt;/li&gt;\n&lt;/ul&gt;\n&lt;/li&gt;\n&lt;li&gt;Private Medical Insurance via Vitality, dental cover, and life assurance&lt;/li&gt;\n&lt;li&gt;Enhanced parental leave&lt;/li&gt;\n&lt;li&gt;1 month paid sabbatical after 4 years at Cleo&lt;/li&gt;\n&lt;li&gt;Regular socials and activities, online and in-person&lt;/li&gt;\n&lt;li&gt;We&#39;ll pay for your OpenAI subscription&lt;/li&gt;\n&lt;li&gt;Online mental health support via Spill&lt;/li&gt;\n&lt;li&gt;And many more!&lt;/li&gt;\n&lt;/ul&gt;\n&lt;/li&gt;\n&lt;/ul&gt;\n&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;&lt;strong&gt;UK App access:&lt;/strong&gt;&amp;nbsp;The Cleo app is no longer downloadable in the UK. If you’re an existing user, you’ll still have access to the app. But some features won’t be available. Why? 99% of our users are based in the US – where financial health is often overlooked. We’ve decided to shift our focus to where we can provide the most value and make the greatest impact for users who need it most. Then we’ll be able to apply what we learn to better support our UK users in the future.&lt;/p&gt;\n&lt;p&gt;For more info on next steps, please visit our Engineering Interview process page:&amp;nbsp;&lt;a href=&quot;https://web.meetcleo.com/blog/how-we-do-engineering-interviews-at-cleo&quot; target=&quot;_new&quot;&gt;https://web.meetcleo.com/blog/how-we-do-engineering-interviews-at-cleo&lt;/a&gt;&lt;/p&gt;\n&lt;/section&gt;",
      "departments": [
        {
          "id": 4039503002,
          "name": "Engineering",
          "child_ids": [],
          "parent_id": null
        }
      ],
      "offices": [
        {
          "id": 4021094002,
          "name": "London",
          "location": "London, England, United Kingdom",
          "child_ids": [],
          "parent_id": null
        }
      ],
      "compliance": null,
      "demographic_questions": {
        "header": "Demographics",
        "description": "<p>We're massively focused on creating a diverse and inclusive workplace at Cleo and we believe that starts right from the very beginning of your journey with us. We have a few questions that we'd love you to answer to make sure that our hiring process is as fair and inclusive as possible.</p>\n<p>All data collected is completely&nbsp;<strong data-stringify-type=\"bold\">anonymous</strong>&nbsp;and has&nbsp;<strong data-stringify-type=\"bold\">zero</strong>&nbsp;attachment or bearing on your application.</p>\n<p>&nbsp;</p>",
        "questions": [
          {
            "id": 4000100002,
            "label": "What is your gender?",
            "required": true,
            "type": "multi_value_multi_select",
            "answer_options": [
              {
                "id": 4000543002,
                "label": "Man",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000544002,
                "label": "Woman",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000545002,
                "label": "Non-binary / third gender",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000547002,
                "label": "I self describe as",
                "free_form": true,
                "decline_to_answer": false
              },
              {
                "id": 4003484002,
                "label": "I don't wish to answer",
                "free_form": false,
                "decline_to_answer": true
              }
            ]
          },
          {
            "id": 4000101002,
            "label": "How would you describe your race / ethnicity?",
            "required": true,
            "type": "multi_value_multi_select",
            "answer_options": [
              {
                "id": 4000548002,
                "label": "White",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004737002,
                "label": "Mixed or Multiple ethnic groups",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000549002,
                "label": "Black",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000550002,
                "label": "Asian",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000551002,
                "label": "Middle Eastern",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000552002,
                "label": "Other",
                "free_form": true,
                "decline_to_answer": false
              },
              {
                "id": 4003485002,
                "label": "I don't wish to answer",
                "free_form": false,
                "decline_to_answer": true
              }
            ]
          },
          {
            "id": 4000102002,
            "label": "Which age group do you belong to",
            "required": true,
            "type": "multi_value_multi_select",
            "answer_options": [
              {
                "id": 4000554002,
                "label": "Under 18 years old",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000555002,
                "label": "18-24 years old",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000556002,
                "label": "25-34 years old",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000557002,
                "label": "35-44 years old",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000558002,
                "label": "45-54 years old",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4000559002,
                "label": "Over 55 years old",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4003486002,
                "label": "I don't wish to answer",
                "free_form": false,
                "decline_to_answer": true
              }
            ]
          },
          {
            "id": 4000862002,
            "label": "What is your sexual orientation?",
            "required": true,
            "type": "multi_value_single_select",
            "answer_options": [
              {
                "id": 4004738002,
                "label": "Bisexual",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004739002,
                "label": "Straight/heterosexual",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004740002,
                "label": "Gay/Lesbian",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004741002,
                "label": "I don't know",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004742002,
                "label": "Other - please specify",
                "free_form": true,
                "decline_to_answer": false
              },
              {
                "id": 4004743002,
                "label": "I don't wish to answer",
                "free_form": false,
                "decline_to_answer": true
              }
            ]
          },
          {
            "id": 4000863002,
            "label": "Are you a carer? If yes, please specify.",
            "required": true,
            "type": "multi_value_single_select",
            "answer_options": [
              {
                "id": 4004744002,
                "label": "Yes ",
                "free_form": true,
                "decline_to_answer": false
              },
              {
                "id": 4004745002,
                "label": "No",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004746002,
                "label": "I don't wish to answer",
                "free_form": false,
                "decline_to_answer": true
              }
            ]
          },
          {
            "id": 4000864002,
            "label": "Would you identify yourself as a person with a disability? If yes, please specify.",
            "required": true,
            "type": "multi_value_single_select",
            "answer_options": [
              {
                "id": 4004754002,
                "label": "Yes",
                "free_form": true,
                "decline_to_answer": false
              },
              {
                "id": 4004748002,
                "label": "No",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004749002,
                "label": "I don't wish to answer",
                "free_form": false,
                "decline_to_answer": true
              }
            ]
          },
          {
            "id": 4000865002,
            "label": "How would you describe the majority of your education?",
            "required": true,
            "type": "multi_value_single_select",
            "answer_options": [
              {
                "id": 4004750002,
                "label": "State school",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004751002,
                "label": "Fee-paying school",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004752002,
                "label": "Selective Grammar School",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4004753002,
                "label": "I don't wish to answer",
                "free_form": false,
                "decline_to_answer": true
              }
            ]
          },
          {
            "id": 4024833002,
            "label": "What was the occupation of your main household earner when you were about aged 14?",
            "required": true,
            "type": "multi_value_single_select",
            "answer_options": [
              {
                "id": 4148788002,
                "label": "Modern professional & traditional professional occupations such as: teacher, nurse, physiotherapist, social worker, musician, police officer (sergeant or above), software designer, accountant, solicitor, medical practitioner, scientist, civil / mechanical",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4148789002,
                "label": "Senior, middle or junior managers or administrators such as: finance manager, chief executive, large business owner, office manager, retail manager, bank manager, restaurant manager, warehouse manager.",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4148790002,
                "label": "Clerical and intermediate occupations such as: secretary, personal assistant, call centre agent, clerical worker, nursery nurse.",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4148791002,
                "label": "Technical and craft occupations such as: motor mechanic, plumber, printer, electrician, gardener, train driver.",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4148792002,
                "label": "Routine, semi-routine manual and service occupations such as: postal worker, machine operative, security guard, caretaker, farm worker, catering assistant, sales assistant, HGV driver, cleaner, porter, packer, labourer, waiter/waitress, bar staff.",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4148793002,
                "label": "Long-term unemployed (claimed Jobseeker’s Allowance or earlier unemployment benefit for more than a year).",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4148794002,
                "label": "Small business owners who employed less than 25 people such as: corner shop owners, small plumbing companies, retail shop owner, single restaurant or cafe owner, taxi owner, garage owner.",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4148795002,
                "label": "Other such as: retired, this question does not apply to me, I don’t know.",
                "free_form": false,
                "decline_to_answer": false
              },
              {
                "id": 4148796002,
                "label": "I don't wish to answer",
                "free_form": false,
                "decline_to_answer": true
              }
            ]
          }
        ]
      },
      "questions": [
        {
          "description": null,
          "label": "First Name",
          "required": true,
          "fields": [
            {
              "name": "first_name",
              "type": "input_text",
              "values": []
            }
          ]
        },
        {
          "description": null,
          "label": "Last Name",
          "required": true,
          "fields": [
            {
              "name": "last_name",
              "type": "input_text",
              "values": []
            }
          ]
        },
        {
          "description": null,
          "label": "Email",
          "required": true,
          "fields": [
            {
              "name": "email",
              "type": "input_text",
              "values": []
            }
          ]
        },
        {
          "description": null,
          "label": "Phone",
          "required": true,
          "fields": [
            {
              "name": "phone",
              "type": "input_text",
              "values": []
            }
          ]
        },
        {
          "description": null,
          "label": "Resume/CV",
          "required": true,
          "fields": [
            {
              "name": "resume",
              "type": "input_file",
              "values": []
            },
            {
              "name": "resume_text",
              "type": "textarea",
              "values": []
            }
          ]
        },
        {
          "description": null,
          "label": "Cover Letter",
          "required": false,
          "fields": [
            {
              "name": "cover_letter",
              "type": "input_file",
              "values": []
            },
            {
              "name": "cover_letter_text",
              "type": "textarea",
              "values": []
            }
          ]
        },
        {
          "description": null,
          "label": "What are your salary expectations for the role?",
          "required": true,
          "fields": [
            {
              "name": "question_27737478002",
              "type": "input_text",
              "values": []
            }
          ]
        },
        {
          "description": null,
          "label": "Do you require sponsorship to work in the UK?",
          "required": true,
          "fields": [
            {
              "name": "question_27737479002",
              "type": "input_text",
              "values": []
            }
          ]
        },
        {
          "description": null,
          "label": "What location are you looking to work from? ",
          "required": true,
          "fields": [
            {
              "name": "question_8607378002",
              "type": "input_text",
              "values": []
            }
          ]
        },
        {
          "description": "<p>Please check out our <a href=\"https://web.meetcleo.com/page/candidate-privacy-policy\" target=\"_blank\" rel=\"noopener\"><strong>Candidate Privacy Notice</strong></a>&nbsp;</p>",
          "label": "Let's make sure you know how we handle your data 🔐",
          "required": true,
          "fields": [
            {
              "name": "question_18804072002[]",
              "type": "multi_value_multi_select",
              "values": [
                {
                  "label": "I've read it 🤓",
                  "value": 88174211002
                }
              ]
            }
          ]
        },
        {
          "description": null,
          "label": "Share a link to your portfolio / website (if you have one)",
          "required": false,
          "fields": [
            {
              "name": "question_7920799002",
              "type": "input_text",
              "values": []
            }
          ]
        },
        {
          "description": "<p class=\"p1\">If you&rsquo;ve heard about us from multiple sources, you can check multiple boxes.</p>",
          "label": "Where did you hear about us?",
          "required": true,
          "fields": [
            {
              "name": "question_24229694002[]",
              "type": "multi_value_multi_select",
              "values": [
                {
                  "label": "Someone at Cleo reached out to me",
                  "value": 114986914002
                },
                {
                  "label": "LinkedIn Jobs",
                  "value": 114986917002
                },
                {
                  "label": "LinkedIn - Cleo Post",
                  "value": 114986920002
                },
                {
                  "label": "LinkedIn - Employee Post",
                  "value": 114986923002
                },
                {
                  "label": "Cleo Blog",
                  "value": 114986926002
                },
                {
                  "label": "Cleo Tech Blog",
                  "value": 114986929002
                },
                {
                  "label": "Data Science Festival",
                  "value": 114986932002
                },
                {
                  "label": "Silicon Milkroundabout",
                  "value": 114986935002
                },
                {
                  "label": "Women in Product Meetup",
                  "value": 114986939002
                },
                {
                  "label": "Intertech Pride Event",
                  "value": 114986942002
                },
                {
                  "label": "ProductTank Meetup",
                  "value": 114986945002
                },
                {
                  "label": "Brighton Ruby",
                  "value": 114986948002
                },
                {
                  "label": "Referred by a friend",
                  "value": 114986950002
                },
                {
                  "label": "Prefer not to say",
                  "value": 114986952002
                }
              ]
            }
          ]
        }
      ],
      "location_questions": []
    }
  },
  'Manatal' => {
    endpoint: "https://core.api.manatal.com/open/v3/career-page/#{ats_identifier}/jobs/#{job_id}/application-form/",
    request_type: :get,
    example_response: [
      {
        "id": 964253,
        "label": "Full Name",
        "slug": "full_name",
        "is_required": true,
        "display_type": "text",
        "type": "char",
        "field_category": "candidate_field"
      },
      {
        "id": 964254,
        "label": "Email",
        "slug": "email",
        "is_required": true,
        "display_type": "text",
        "type": "char",
        "field_category": "candidate_field"
      },
      {
        "id": 964255,
        "label": "Phone",
        "slug": "phone_number",
        "is_required": true,
        "display_type": "text",
        "type": "char",
        "field_category": "candidate_field"
      },
      {
        "id": 964256,
        "label": "Linkedin",
        "slug": "",
        "is_required": true,
        "display_type": "",
        "type": "longtext",
        "field_category": "social_media"
      },
      {
        "id": 964257,
        "label": "Resume",
        "slug": "",
        "is_required": true,
        "display_type": "",
        "type": "char",
        "field_category": "resume"
      },
      {
        "id": 974059,
        "label": "Current Company",
        "slug": "current_company",
        "is_required": false,
        "display_type": "text",
        "type": "char",
        "field_category": "candidate_field"
      },
      {
        "id": 974045,
        "label": "Current Position",
        "slug": "current_position",
        "is_required": false,
        "display_type": "text",
        "type": "char",
        "field_category": "candidate_field"
      },
      {
        "id": 974189,
        "label": "Years of Experience",
        "slug": "years_of_experience",
        "is_required": false,
        "display_type": "",
        "type": "integer",
        "field_category": "candidate_field"
      },
      {
        "id": 974047,
        "label": "Diploma",
        "slug": "latest_degree",
        "is_required": true,
        "display_type": "text",
        "type": "char",
        "field_category": "candidate_field"
      },
      {
        "id": 974191,
        "label": "Languages",
        "slug": "languages",
        "is_required": false,
        "display_type": "text",
        "type": "char",
        "field_category": "candidate_field"
      },
      {
        "id": 974190,
        "label": "Nationalities",
        "slug": "nationalities",
        "is_required": false,
        "display_type": "text",
        "type": "char",
        "field_category": "candidate_field"
      },
      {
        "id": 974048,
        "label": "Location",
        "slug": "city",
        "is_required": true,
        "display_type": "text",
        "type": "char",
        "field_category": "candidate_field"
      },
      {
        "id": 974168,
        "label": "Can Relocate",
        "slug": "canrelocate",
        "is_required": false,
        "display_type": "boolean",
        "type": "boolean",
        "field_category": "candidate_field"
      }
    ]
  },
  'Recruitee' => {
    endpoint: "https://#{ats_identifier}.recruitee.com/api/offers",
    request_type: :get,
    example_response:
    {
      "sharing_description": "Radish Lab, a creative agency based in Brooklyn, NY, is always accepting applications for Freelance Copywriters to join our team for various projects for our nonprofit clients. \n\nThe ideal candidate w",
      "state_name": "New York",
      "id": 1390320,
      "employment_type_code": "contract",
      "remote": true,
      "options_cover_letter": "optional",
      "city": "BROOKLYN",
      "position": 45,
      "department": null,
      "experience_code": "mid_level",
      "published_at": "2023-07-25 17:53:46 UTC",
      "title": "Copywriter Talent Pool",
      "careers_url": "https://radishlab.recruitee.com/o/copywriter-talen-pool",
      "country": "United States",
      "sharing_image": null,
      "postal_code": null,
      "company_name": "Radish Lab",
      "locations": [
        {
          "id": 94693,
          "name": "BROOKLYN",
          "state": "New York",
          "country": "United States",
          "city": "BROOKLYN",
          "translations": {
            "en": {
              "name": "BROOKLYN",
              "city": "BROOKLYN",
              "street": null,
              "postal_code": null,
              "note": null
            }
          },
          "country_code": "US",
          "state_code": "NY",
          "street": null,
          "postal_code": null,
          "note": null
        }
      ],
      "guid": "56ucy",
      "locations_question_required": true,
      "on_site": false,
      "locations_question_type": "multiple_choice",
      "slug": "copywriter-talen-pool",
      "sharing_title": "Copywriter Talent Pool",
      "location_question_visible": false,
      "hybrid": false,
      "updated_at": "2024-07-10 09:55:41 UTC",
      "tags": [],
      "created_at": "2023-07-25 16:04:54 UTC",
      "open_questions": [
        {
          "id": 2039662,
          "position": 1,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "Do you have experience working in an agency environment?",
          "kind": "boolean",
          "translations": {
            "en": {
              "body": "Do you have experience working in an agency environment?"
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039663,
          "position": 2,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "Do you have experience working on a small team?",
          "kind": "boolean",
          "translations": {
            "en": {
              "body": "Do you have experience working on a small team?"
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039664,
          "position": 3,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "Are you located within 3 hours of Eastern Standard Time?",
          "kind": "boolean",
          "translations": {
            "en": {
              "body": "Are you located within 3 hours of Eastern Standard Time?"
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039665,
          "position": 4,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "If you are located in the US, are you authorized to work in the US? (We are not sponsoring visas at this time).",
          "kind": "boolean",
          "translations": {
            "en": {
              "body": "If you are located in the US, are you authorized to work in the US? (We are not sponsoring visas at this time)."
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039668,
          "position": 5,
          "options": {
            "length": 120
          },
          "required": false,
          "body": "If you are outside of the US, are you authorized to work in the US? (we are not sponsoring visas at this time).",
          "kind": "boolean",
          "translations": {
            "en": {
              "body": "If you are outside of the US, are you authorized to work in the US? (we are not sponsoring visas at this time)."
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039673,
          "position": 6,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "What Country are you located in?",
          "kind": "string",
          "translations": {
            "en": {
              "body": "What Country are you located in?"
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039672,
          "position": 7,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "What State/Region are you located in?",
          "kind": "string",
          "translations": {
            "en": {
              "body": "What State/Region are you located in?"
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039671,
          "position": 8,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "What City are you located in?",
          "kind": "string",
          "translations": {
            "en": {
              "body": "What City are you located in?"
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039669,
          "position": 9,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "Are you proficient in English?",
          "kind": "boolean",
          "translations": {
            "en": {
              "body": "Are you proficient in English?"
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039670,
          "position": 10,
          "options": {
            "length": 120
          },
          "required": false,
          "body": "Do you speak any other languages? (If so, please list).",
          "kind": "string",
          "translations": {
            "en": {
              "body": "Do you speak any other languages? (If so, please list)."
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039666,
          "position": 11,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "How many weeks would you need between receiving a job offer and starting the job?",
          "kind": "string",
          "translations": {
            "en": {
              "body": "How many weeks would you need between receiving a job offer and starting the job?"
            }
          },
          "open_question_options": []
        },
        {
          "id": 2039667,
          "position": 12,
          "options": {
            "length": 120
          },
          "required": true,
          "body": "How did you hear about Radish?",
          "kind": "string",
          "translations": {
            "en": {
              "body": "How did you hear about Radish?"
            }
          },
          "open_question_options": []
        }
      ],
      "status": "published",
      "close_at": null,
      "cover_image": null,
      "requirements": "<ul><li dir=\"ltr\"><p dir=\"ltr\">Proven experience as a copywriter with a portfolio of relevant work samples</p></li><li dir=\"ltr\"><p dir=\"ltr\">Experience writing SEO-friendly copy for the web is a must</p></li><li dir=\"ltr\"><p dir=\"ltr\">Strong writing, editing, and proofreading skills with an attention to detail</p></li><li dir=\"ltr\"><p dir=\"ltr\">Ability to work efficiently and meet deadlines in a fast-paced environment</p></li><li dir=\"ltr\"><p dir=\"ltr\">Nice to have experience writing for social impact organizations, philanthropy, and fundraising</p></li></ul>\n<p dir=\"ltr\">If you're a talented Copywriter with a passion for storytelling and creating meaningful content, we want to hear from you! Please submit your resume, portfolio, and any relevant writing samples to be considered for the role and share your hourly rate.</p>",
      "min_hours_per_week": "30.0",
      "country_code": "US",
      "min_hours": null,
      "location": "Remote job",
      "category_code": "design",
      "translations": {
        "en": {
          "description": "<p dir=\"ltr\">Radish Lab, a creative agency based in Brooklyn, NY, is always accepting applications for Freelance Copywriters to join our team for various projects for our nonprofit clients. </p>\n<p dir=\"ltr\"><br /></p>\n<p dir=\"ltr\">The ideal candidate will have experience writing copy specifically for the web and can produce high-quality work within tight deadlines. </p>\n<p dir=\"ltr\"><br /></p>\n<p dir=\"ltr\"><strong>Responsibilities:</strong><br /></p>\n<ul><li dir=\"ltr\"><p dir=\"ltr\">Ensure all content is on-brand, consistent in tone, and optimized for SEO</p></li><li dir=\"ltr\"><p dir=\"ltr\">Work closely with our team to ensure that all content is aligned with the client’s brand and voice</p></li><li dir=\"ltr\"><p dir=\"ltr\">Meet all deadlines and deliverables</p></li><li dir=\"ltr\"><p dir=\"ltr\">Incorporate client feedback and make revisions through 2 rounds of revisions</p></li></ul>",
          "title": "Copywriter Talent Pool",
          "locations_question": "What is your preferred work location?",
          "requirements": "<ul><li dir=\"ltr\"><p dir=\"ltr\">Proven experience as a copywriter with a portfolio of relevant work samples</p></li><li dir=\"ltr\"><p dir=\"ltr\">Experience writing SEO-friendly copy for the web is a must</p></li><li dir=\"ltr\"><p dir=\"ltr\">Strong writing, editing, and proofreading skills with an attention to detail</p></li><li dir=\"ltr\"><p dir=\"ltr\">Ability to work efficiently and meet deadlines in a fast-paced environment</p></li><li dir=\"ltr\"><p dir=\"ltr\">Nice to have experience writing for social impact organizations, philanthropy, and fundraising</p></li></ul>\n<p dir=\"ltr\">If you're a talented Copywriter with a passion for storytelling and creating meaningful content, we want to hear from you! Please submit your resume, portfolio, and any relevant writing samples to be considered for the role and share your hourly rate.</p>",
          "sharing_description": "Radish Lab, a creative agency based in Brooklyn, NY, is always accepting applications for Freelance Copywriters to join our team for various projects for our nonprofit clients. \n\nThe ideal candidate w",
          "sharing_image": null,
          "sharing_title": "Copywriter Talent Pool"
        }
      },
      "options_photo": "optional",
      "salary": {
        "max": null,
        "min": null,
        "period": null,
        "currency": null
      },
      "options_cv": "required",
      "max_hours_per_week": "40.0",
      "education_code": "bachelor_degree",
      "locations_question": "What is your preferred work location?",
      "state_code": "NY",
      "max_hours": null,
      "options_phone": "required",
      "careers_apply_url": "https://radishlab.recruitee.com/o/copywriter-talen-pool/c/new",
      "description": "<p dir=\"ltr\">Radish Lab, a creative agency based in Brooklyn, NY, is always accepting applications for Freelance Copywriters to join our team for various projects for our nonprofit clients. </p>\n<p dir=\"ltr\"><br /></p>\n<p dir=\"ltr\">The ideal candidate will have experience writing copy specifically for the web and can produce high-quality work within tight deadlines. </p>\n<p dir=\"ltr\"><br /></p>\n<p dir=\"ltr\"><strong>Responsibilities:</strong><br /></p>\n<ul><li dir=\"ltr\"><p dir=\"ltr\">Ensure all content is on-brand, consistent in tone, and optimized for SEO</p></li><li dir=\"ltr\"><p dir=\"ltr\">Work closely with our team to ensure that all content is aligned with the client’s brand and voice</p></li><li dir=\"ltr\"><p dir=\"ltr\">Meet all deadlines and deliverables</p></li><li dir=\"ltr\"><p dir=\"ltr\">Incorporate client feedback and make revisions through 2 rounds of revisions</p></li></ul>",
      "mailbox_email": "job.56ucy@radishlab.recruitee.com"
    }
  },
  'Workable' => {
    endpoint: "https://apply.workable.com/api/v1/jobs/#{job_id}/form",
    request_type: :get,
    example_response: [
      {
        "name": "Personal information",
        "fields": [
          {
            "id": "firstname",
            "required": true,
            "label": "First name",
            "type": "text",
            "maxLength": 127
          },
          {
            "id": "lastname",
            "required": true,
            "label": "Last name",
            "type": "text",
            "maxLength": 127
          },
          {
            "id": "email",
            "required": true,
            "label": "Email",
            "type": "email",
            "maxLength": 255
          },
          {
            "id": "phone",
            "required": true,
            "label": "Phone",
            "type": "phone",
            "helper": "The hiring team may use this number to contact you about this job.",
            "maxLength": 255
          }
        ]
      },
      {
        "name": "Profile",
        "fields": [
          {
            "id": "resume",
            "required": true,
            "label": "Resume",
            "type": "file",
            "supportedFileTypes": [
              ".pdf",
              ".doc",
              ".docx",
              ".odt",
              ".rtf"
            ],
            "supportedMimeTypes": [
              "application/pdf",
              "application/msword",
              "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
              "application/vnd.oasis.opendocument.text",
              "application/rtf"
            ],
            "maxFileSize": 12000000
          }
        ]
      },
      {
        "name": "Details",
        "fields": [
          {
            "id": "QA_5947083",
            "required": true,
            "label": "Do you have at least 3 years of experience in system, network or application security?",
            "type": "boolean"
          },
          {
            "id": "QA_7692993",
            "required": true,
            "label": "What is your current (or most recent) salary?",
            "type": "text",
            "maxLength": 127
          },
          {
            "id": "QA_7692994",
            "required": true,
            "label": "What are your salary requirements for this role?",
            "type": "text",
            "maxLength": 127
          },
          {
            "id": "QA_7692995",
            "required": true,
            "label": "What is your current notice period?",
            "type": "text",
            "maxLength": 127
          },
          {
            "id": "QA_7692996",
            "required": true,
            "label": "What is your right to work in the UK please?  \n(For example: British Citizenship, Indefinite Leave to Remain, Settlement Status, Student Visa, Tier 1 or 2 visa etc)",
            "type": "text",
            "maxLength": 127
          },
          {
            "id": "QA_5947034",
            "required": true,
            "label": "Do you have demonstrable experience in security operations, network security or applications security?",
            "type": "paragraph"
          },
          {
            "id": "QA_5947035",
            "required": true,
            "label": "Do you have any experience of working in a Fintech or a regulated environment?",
            "type": "paragraph"
          },
          {
            "id": "QA_5947036",
            "required": true,
            "label": "Do you have working knowledge of SAST, DAST, RASP, and IAST tools and building security into existing SDLC processes?",
            "type": "paragraph"
          },
          {
            "id": "QA_6302137",
            "required": true,
            "label": "Please select your preferred pronoun?",
            "type": "dropdown",
            "options": [
              {
                "name": "2998915",
                "value": "She/her"
              },
              {
                "name": "2998916",
                "value": "He/him"
              },
              {
                "name": "2998917",
                "value": "They/Them"
              },
              {
                "name": "2998918",
                "value": "Prefer not to say"
              }
            ],
            "singleOption": true
          },
          {
            "id": "QA_6302138",
            "required": true,
            "label": "If the above does not capture your preferred pronoun, please could you state what it is?",
            "type": "paragraph"
          },
          {
            "id": "QA_7694028",
            "required": true,
            "label": "If a current Kroo Bank employee referred you, please share their name. If not, just write \"no.\"",
            "type": "text",
            "maxLength": 127
          }
        ]
      }
    ]
  }
}
# rubocop:enable Lint/SymbolConversion
# rubocop:enable Style/NumericLiterals
# rubocop:enable Style/QuotedSymbols
