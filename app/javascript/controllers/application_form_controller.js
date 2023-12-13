import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log('Individual controller connected');
  }

  submitForm(event) {
    event.preventDefault();
    console.log("reading");
    const formData = new FormData(this.formTarget);
    this.formTarget.querySelector('input[type="submit"]').disabled = true;
    fetch(this.formTarget.action, {
      method: this.formTarget.method,
      body: formData
    }).then((response) => {
      console.log(response);
      // Handle response
      // page.reload();
      // TODO: Handle response properly
      this.formTarget.innerText = "Thank you for your submission!";
      // this.formTarget.classList.add("d-none");
    }).catch(error => {
      // Handle error
    });
  }
}
