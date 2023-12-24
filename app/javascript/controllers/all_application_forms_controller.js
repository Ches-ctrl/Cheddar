import { Controller } from "@hotwired/stimulus";
import { createConsumer } from "@rails/actioncable";

export default class extends Controller {
  static targets = ["form", "button", "overlay", "success"];
  static values = { user: Number }; // Add a user value if needed

  connect() {
    console.log("All forms controller connected");

    // Establish an Action Cable connection for form submissions
    this.consumer = createConsumer();

    console.log(`this consumer: ${this.consumer}`)
    console.log(`this user value: ${this.userValue}`)

    // Subscribe to the JobApplicationsChannel, providing necessary params
    this.channel = this.consumer.subscriptions.create(
      {
        channel: "JobApplicationsChannel",
        user_id: this.userValue, // Add the user ID if needed
      },
      {
        connected() {
          // Handle connection established
          console.log("Connected to JobApplicationsChannel")
        },
        disconnected() {
          // Handle connection disconnected
          console.log("Disconnected from JobApplicationsChannel")
        },
        received(data) {
          console.log("Received data from JobApplicationsChannel")
          // console.log(data)
          if (data.event === "job-application-created") {
            console.log("Received job-application-created event")
            console.log(data)

            const jobId = data.job_id;
            const status = data.status;

            console.log(jobId)
            console.log(status)

            // Find the spinner element with the corresponding job ID
            const spinner = this.element.querySelector(`[data-all-application-forms-id="${jobId}"]`);
            // Find the checkmark element
            const checkmark = this.successTarget;

            if (spinner && checkmark) {
              // Update the UI based on the job application status
              if (status === "Applied") {
                // Hide the spinner and show the checkmark
                spinner.classList.add("d-none");
                checkmark.classList.remove("d-none");
              } else {
                // Handle other statuses if needed
              }
            }
          }
        },
      }
    );
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

  disconnect() {
    console.log("Disconnecting from JobApplicationsChannel");
    this.channel.unsubscribe();
    this.consumer.disconnect();
  }
}
