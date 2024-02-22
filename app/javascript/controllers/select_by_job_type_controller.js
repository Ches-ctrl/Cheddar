import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-by-job-type"
export default class extends Controller {
  static targets = [ 'role', 'jobRow', 'company', 'location' ]

  connect() {
    console.log(this.locationTargets)
  }

  combinedSearch() {
    const checkedRoles = this.roleTargets.filter(role => role.checked)
      .map(role => role.id)
    const checkedCompanies = this.companyTargets.filter(company => company.checked)
      .map(company => company.attributes.id.value)
    const checkedLocations = this.locationTargets.filter(location => location.checked)
      .map(location => location.id)

    const filterQueryString = this.buildQueryString(checkedRoles, checkedCompanies, checkedLocations)
    window.location.href = `/jobs${filterQueryString}`;

    // The code below is unnecessary if fetching jobs using a GET request, but has the advantage of not requiring page reload
    // const patternStrings = []

    // checkedRoles.forEach((query) => {
    //   const regexd_query = '(' + query.replace(' ', '(-| )?') + ')'
    //   patternStrings.push(regexd_query)
    // })

    // const pattern = new RegExp(patternStrings.join('|'), 'i');

    // this.jobRowTargets.forEach((jobRow) => {
    //   const jobTitle = jobRow.querySelector(".role").dataset.role;
    //   if (pattern.test(jobTitle)) {
    //     if (checkedCompanies.length > 0) {
    //       if (checkedCompanies.includes(jobRow.querySelector(".companyname").dataset.name)) {
    //         jobRow.classList.remove('d-none')
    //       } else {
    //         jobRow.classList.add('d-none')
    //       }
    //     } else {
    //       jobRow.classList.remove('d-none')
    //     }
    //   } else {
    //     jobRow.classList.add('d-none')
    //   }
    // })
  }

  buildQueryString(checkedRoles, checkedCompanies, checkedLocations) {
    let queryString = "";

    if (checkedRoles.length + checkedCompanies.length + checkedLocations.length > 0) {
      queryString += "?";

      if (checkedRoles.length > 0) {
        queryString += "roles=" + checkedRoles.join("+");
      }

      if (checkedCompanies.length > 0) {
        if (checkedRoles.length > 0) {
          queryString += "&";
        }
        queryString += "companies=" + checkedCompanies.join("+");
      }

      if (checkedLocations.length > 0) {
        if (checkedRoles.length + checkedCompanies.length > 0) {
          queryString += "&";
        }
        queryString += "locations=" + checkedLocations.join("+");
      }
    }

    return queryString
  }
}
