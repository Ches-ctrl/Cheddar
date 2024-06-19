import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdownContainer", "dropdown"];

  connect() {
    var dropdownContainer = this.dropdownContainerTarget;

    document.body.addEventListener('click', (event) => {
        // Check if clicked element is contained by the dropdownContainer
        if (dropdownContainer.contains(event.target)) {
            this.toggleVisibility();
        }
        // Check if clicked element contained the dropdownContainer and check if dropdownTarget is visible
        if (event.target.contains(dropdownContainer) && !this.dropdownTarget.classList.contains("hidden")) {
            this.toggleVisibility();
        }
    });
  }

  toggleVisibility() {
    const isHidden = this.dropdownTarget.classList.contains("hidden");
    this.dropdownTarget.classList.toggle("hidden", !isHidden);
  };
}