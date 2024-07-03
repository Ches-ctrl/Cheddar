import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="select-university"
export default class extends Controller {
  static targets = [ "button", "form", "field", "innerRound" ]

  toggleHidden(event) {
    const hidden = this.buttonTarget.getAttribute("aria-checked") === "false";
    this.fieldTargets.forEach((field) => {
      const isOptional = field.dataset.requiredValue === "false"; // Check for "false"

      if (isOptional) {
        field.hidden = hidden;
      }
    });

    // Update button label based on hidden state (optional)
    if (hidden) {
      this.buttonTarget.classList.remove("bg-gray-200");
      this.buttonTarget.classList.add("bg-indigo-600");
      this.innerRoundTarget.classList.remove("translate-x-0");
      this.innerRoundTarget.classList.add("translate-x-5");
      this.buttonTarget.setAttribute("aria-checked", "true");
    } else {
      this.buttonTarget.classList.remove("bg-indigo-600");
      this.buttonTarget.classList.add("bg-gray-200");
      this.innerRoundTarget.classList.remove("translate-x-5");
      this.innerRoundTarget.classList.add("translate-x-0");
      this.buttonTarget.setAttribute("aria-checked", "false");
    }
  }
}