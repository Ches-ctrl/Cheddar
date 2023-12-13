import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="load-more"
export default class extends Controller {
  static targets = ["remaining", "button"];

  connect() {
  }

  showMore(event) {
    event.preventDefault();
    this.remainingTarget.classList.remove('d-none');
    this.buttonTarget.classList.add('d-none');
  }
}
