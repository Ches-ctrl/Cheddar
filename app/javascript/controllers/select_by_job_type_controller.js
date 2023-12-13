import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-by-job-type"
export default class extends Controller {
  static targets = [ 'role', 'jobRow', 'company' ]

  connect() {
  }

  combinedSearch() {
    const checkedRoles = this.roleTargets.filter(role => role.checked)
      .map(role => role.id)
      console.log(checkedRoles);
    const checkedCompanies = this.companyTargets.filter(company => company.checked)
    .map(company => company.attributes.id.value)

    const patternStrings = []

    checkedRoles.forEach((query) => {
      const regexd_query = '(' + query.replace(' ', '(-| )?') + ')'
      // console.log(regexd_query)
      patternStrings.push(regexd_query)
    })

    const pattern = new RegExp(patternStrings.join('|'), 'i');

    this.jobRowTargets.forEach((jobRow) => {
      const jobTitle = jobRow.querySelector(".role").dataset.role;
      // console.log(jobRow.querySelector(".role"))
      // console.log(jobRow.querySelector(".role").dataset)
      // console.log(pattern);
      // console.log(checkedCompanies);
      if (pattern.test(jobTitle)) {
        if (checkedCompanies.length > 0) {
          if (checkedCompanies.includes(jobRow.querySelector(".companyname").dataset.name)) {
            jobRow.classList.remove('d-none')
          } else {
            jobRow.classList.add('d-none')
          }
        } else {
          jobRow.classList.remove('d-none')
        }
      } else {
        jobRow.classList.add('d-none')
      }
    })
  }
}
