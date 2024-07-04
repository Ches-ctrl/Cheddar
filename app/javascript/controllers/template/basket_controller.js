import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "mainCheckbox", "applyButton", "checkbox"];

  connect() {
    if (this.hasMainCheckboxTarget) {
      // Set up event listener for the main checkbox
      this.mainCheckboxTarget.addEventListener("change", (event) => {
          this.handleMainCheckboxChange(event);
      });

      // Set up event listeners on all checkboxes (including main checkbox)
      this.checkboxTargets.forEach(checkbox => {
          checkbox.addEventListener("change", (event) => {
              this.handleCheckboxChange(event);
          });
      });
    }
  }
  
  handleCheckboxChange(event) {
    const isChecked = event.target.checked;

    // Update apply button state based on selection
    this.updateApplyButtonState();

    // Update main checkbox state based on all checkboxes
    const anyChecked = this.checkboxTargets.some(checkbox => checkbox.checked);
    this.mainCheckboxTarget.checked = anyChecked;
  }

  handleMainCheckboxChange(event) {
    const isChecked = event.target.checked;

    // Update state of all checkboxes based on main checkbox
    this.checkboxTargets.forEach(checkbox => checkbox.checked = isChecked);

    // Update apply button state based on checkbox selection
    this.updateApplyButtonState();
  }

  submit(event) {
    event.preventDefault();
    this.formTarget.submit();
  }

  updateApplyButtonState() {
    // Check if any checkboxes are selected
    const anyChecked = this.checkboxTargets.some(checkbox => checkbox.checked);

    // Enable/disable apply button based on selection
    this.applyButtonTarget.classList.toggle("opacity-50", !anyChecked);
    this.applyButtonTarget.classList.toggle("cursor-not-allowed", !anyChecked);
  }
}