import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleButton1", "toggleButton2", "newColumn1", "newColumn2", "leftSection", "rightSection", "jobCheckbox", "applyButton"];

  connect() {
    console.log("connected to job index toggle controller");
    console.log(this.applyButtonTarget);
  }

  toggleView() {
    // Toggle the visibility of the new columns
    this.newColumn1Target.classList.toggle('d-none');
    this.newColumn2Targets.forEach((column) => {
      column.classList.toggle('d-none');
    });
    // this.newColumn2Target.classList.toggle('d-none');
    // console.log(this.element);

    // Adjust the width of the right section
    if (this.leftSectionTarget.classList.contains('d-none')) {
      this.leftSectionTarget.classList.remove('d-none');
      this.leftSectionTarget.classList.add('col-sm-3');
      this.rightSectionTarget.classList.remove('col-sm-12');
      this.rightSectionTarget.classList.add('col-sm-9');
    } else {
      this.leftSectionTarget.classList.add('d-none');
      this.leftSectionTarget.classList.remove('col-sm-3');
      this.rightSectionTarget.classList.add('col-sm-12');
      this.rightSectionTarget.classList.remove('col-sm-9');
    }

    this.toggleButton1Target.classList.toggle('d-none');
    this.toggleButton2Target.classList.toggle('d-none');
  }

  updateApplyButton() {
    const selectedCount = this.jobCheckboxTargets.filter(checkbox => checkbox.querySelector("input").checked).length;
    console.log(selectedCount);
    console.log(this.applyButtonTarget)
    this.applyButtonTarget.value = `Apply to ${selectedCount} Job${selectedCount > 1 ? "s" : ""}`;
  }
}
