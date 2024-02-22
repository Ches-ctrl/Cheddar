import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-by-job-type"
export default class extends Controller {
  static targets = [ 'role', 'jobRow', 'company', 'location', 'seniority' ]

  connect() {
  }

  combinedSearch() {
    const checkedRoles = this.roleTargets.filter(role => role.checked)
      .map(role => role.id)
    const checkedCompanies = this.companyTargets.filter(company => company.checked)
      .map(company => company.attributes.id.value)
    const checkedLocations = this.locationTargets.filter(location => location.checked)
      .map(location => location.id)
    const checkedSeniorities = this.seniorityTargets.filter(seniority => seniority.checked)
      .map(seniority => seniority.id)

    const filterQueryString = this.buildQueryString(checkedRoles, checkedCompanies, checkedLocations, checkedSeniorities)
    window.location.href = `/jobs${filterQueryString}`;
  }

  buildQueryString(checkedRoles, checkedCompanies, checkedLocations, checkedSeniorities) {
    const queryStringParams = [];

    if (checkedRoles.length > 0) {
      queryStringParams.push("roles=" + checkedRoles.join("+"));
    }

    if (checkedCompanies.length > 0) {
      queryStringParams.push("companies=" + checkedCompanies.join("+"));
    }

    if (checkedLocations.length > 0) {
      queryStringParams.push("locations=" + checkedLocations.join("+"));
    }

    if (checkedSeniorities.length > 0) {
      queryStringParams.push("seniorities=" + checkedSeniorities.join("+"));
    }

    return queryStringParams.length > 0 ? "?" + queryStringParams.join("&") : "";
  }
}
