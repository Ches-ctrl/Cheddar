import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-by-job-type"
export default class extends Controller {
  static targets = [ 'jobRow', 'search', 'cheddar', 'posted', 'role', 'company', 'location', 'seniority', 'employment' ]

  connect() {
    this.searchTarget.addEventListener('input', this.checkEmptySearch.bind(this));
  }

  combinedSearch(event) {
    event.preventDefault()

    // TODO: Speed up search (fewer atributes? check process in query params)
    // TODO: add autocomplete to search bar

    const searchQuery = this.searchTarget.value.trim();

    const filterTerms = {
      cheddar: this.cheddarTargets,
      posted: this.postedTargets,
      seniority: this.seniorityTargets,
      location: this.locationTargets,
      role: this.roleTargets,
      type: this.employmentTargets,
      company: this.companyTargets
    }

    const searchTerms = {}

    if (searchQuery.length > 0) {
      searchTerms['query'] = searchQuery.split(' ');
    }

    for (let key in filterTerms) {
      const checkedTargets = filterTerms[key]
        .filter(target => target.checked)
        .map(target => target.id);
      if (checkedTargets.length > 0) {
        searchTerms[key] = checkedTargets
      }
    }

    const filterQueryString = this.buildQueryString(searchTerms);
    window.location.href = `/jobs${filterQueryString}`;
  }

  checkEmptySearch() {
    if (this.searchTarget.value.trim() === '') {
      window.location.href = `/jobs`;
    }
  }

  buildQueryString(searchTerms) {
    const queryStringParams = []

    for (let key in searchTerms) {
      queryStringParams.push(`${key}=${searchTerms[key].join('+')}`);
    }

    return queryStringParams.length > 0 ? "?" + queryStringParams.join("&") : "";
  }
}
