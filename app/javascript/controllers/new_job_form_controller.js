import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-job-form"
export default class extends Controller {
  static targets = [ 'button', 'form' ]

  displayForm(event) {
    event.preventDefault()
    this.formTarget.classList.toggle('d-none')
  }
}
