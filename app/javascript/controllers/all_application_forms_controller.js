import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "button", "overlay", "success"];

  connect() {
    console.log("All forms controller connected");
  }

  async submitAllForms(event) {
    event.preventDefault();
    this.buttonTarget.disabled = true;
    this.overlayTarget.classList.remove("d-none");

    try {
      await new Promise((resolve) => {
        setTimeout(() => {
          resolve();
        }, 200);
      });

      await Promise.all(
        this.formTargets.map(async (form) => {
          await new Promise((resolve) => {
            setTimeout(() => {
              form.requestSubmit();
              resolve();
            }, 200);
          });
        })
      );

      console.log("All forms submitted");
      // Do not redirect here; it will be handled based on job application status checks
      // window.location.href = "/job_applications/success";
    } catch (error) {
      console.error("Error submitting forms:", error);
    }
  }
}

// 1. connect
// 2. Submit all forms
// 3. Get job ids based on the data attributes of the spinners
// 4. Using the job id and user id (also a data attribute), find the job application id
// 5. Periodically check the status of the job application based on the job application id
// 6. Change the spinner to a tick when the job application has status "Applied"
// 7. Redirect to the success page once all job applications have been submitted

// Statement of the problem
// - I want to update the status of my spinners in my loading modal
// - But we don't have the job application IDs
// - So we query the database with the job IDs and user IDs for the job application IDs
// - But the job applications haven't been created at the point of querying the database
// - So it returns null and we have nothing to update the spinners with
// - How do I ensure that we wait for the job applications to be created before we query the database for their IDs
// - The job applications are created off the back of multiple form submissions

// The context is a rails app with stimulus
