import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "button", "overlay", "modal"]

  connect() {
    // console.log('Parent controller connected');
    // console.log(this.formTargets);
    console.log("All forms controller connected")
  }

  async submitAllForms(event) {
    event.preventDefault();
    this.buttonTarget.disabled = true;
    this.overlayTarget.classList.remove("d-none");
    this.modalTarget.classList.remove("d-none");

    try {
      await new Promise((resolve) => {
        setTimeout(() => {
          resolve();
        }, 1000);
      });

      await Promise.all(
        this.formTargets.map(async (form) => {
          await new Promise((resolve) => {
            setTimeout(() => {
              form.requestSubmit();
              // You can render a modal here to show that the form has been submitted
              resolve();
            }, 1000);
          });
        })
      );

      // TODO: Link with the job application so that the page only redirects after all forms have been submitted successfully

      console.log("All forms submitted");
      window.location.href = "/job_applications/success";
    } catch (error) {
      console.error("Error submitting forms:", error);
      // Handle any errors here
    }
  }
}
