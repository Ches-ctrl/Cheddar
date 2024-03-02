import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-by-job-type"
export default class extends Controller {
  static targets = [ 'jobRow', 'search', 'role', 'company', 'location', 'seniority', 'employment' ]

  connect() {
  }

  combinedSearch(event) {
    event.preventDefault()
    const searchQuery = this.searchTarget.value.split(' ')
    const checkedRoles = this.roleTargets.filter(role => role.checked)
      .map(role => role.id)
    const checkedCompanies = this.companyTargets.filter(company => company.checked)
      .map(company => company.attributes.id.value)
    const checkedLocations = this.locationTargets.filter(location => location.checked)
      .map(location => location.id)
    const checkedSeniorities = this.seniorityTargets.filter(seniority => seniority.checked)
      .map(seniority => seniority.id)
    const checkedEmployments = this.employmentTargets.filter(employment => employment.checked)
      .map(employment => employment.id)

    const filterQueryString = this.buildQueryString(searchQuery, checkedRoles, checkedCompanies, checkedLocations, checkedSeniorities, checkedEmployments)
    window.location.href = `/jobs${filterQueryString}`;
  }

  buildQueryString(searchQuery, checkedRoles, checkedCompanies, checkedLocations, checkedSeniorities, checkedEmployments) {
    const queryStringParams = [];

    if (searchQuery.length > 0) {
      queryStringParams.push("query=" + searchQuery.join("+"));
    }

    if (checkedRoles.length > 0) {
      queryStringParams.push("role=" + checkedRoles.join("+"));
    }

    if (checkedCompanies.length > 0) {
      queryStringParams.push("company=" + checkedCompanies.join("+"));
    }

    if (checkedLocations.length > 0) {
      queryStringParams.push("location=" + checkedLocations.join("+"));
    }

    if (checkedSeniorities.length > 0) {
      queryStringParams.push("seniority=" + checkedSeniorities.join("+"));
    }

    if (checkedEmployments.length > 0) {
      queryStringParams.push("employment=" + checkedEmployments.join("+"));
    }

    return queryStringParams.length > 0 ? "?" + queryStringParams.join("&") : "";
  }
}
