import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="response-input"
export default class extends Controller {
  static targets = ["input"]
  connect() {
    console.log(this.inputTargets);
  }

  handleChange(event) {
    console.log(event.target.value)
    console.log(event.target)
    // Get the dataset label of the event target

    console.log(this.inputTargets.indexOf(event.target))
    // iterate over the input targets
    // If the dataset.label of the input target matches the dataset.label of the event target
    // set the value of the input target to the value of the event target
    // else do nothing
  }
}
