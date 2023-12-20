import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="placeholder"
export default class extends Controller {
  static targets = ["placeholder"]

  connect() {
    console.log("Placeholder controller connected");
    this.hidePlaceholders();
  }

  hidePlaceholders() {
    this.placeholderTargets.forEach((el) => {
      el.style.display = 'none'; // This hides the placeholder
    });
  }
}
