import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleButton1", "toggleButton2", "newColumn1", "newColumn2", "leftSection", "rightSection", "jobCheckbox", "applyButton"];

  connect() {
    console.log("connected to job index controller");
    console.log(this.applyButtonTarget);
  }

  updateApplyButton() {
    const selectedCount = this.jobCheckboxTargets.filter(checkbox => checkbox.querySelector("input").checked).length;
    console.log(selectedCount);
    console.log(this.applyButtonTarget)
    this.applyButtonTarget.value = `Shortlist ${selectedCount} Job${selectedCount > 1 ? "s" : ""}`;
    this.applyButtonTarget.value = `Shortlist ${selectedCount} Job${selectedCount === 0 ? "s" : ""}`;
  }
}
