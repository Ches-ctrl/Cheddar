import { Controller } from "@hotwired/stimulus";
import { createConsumer } from "@rails/actioncable";

export default class extends Controller {
  static targets = ["form", "button", "overlay"];
  static values = { user: Number };

  // RESET POINT

  connect() {
    console.log("All forms controller connected");
    this.consumer = createConsumer();
    // console.log(this)
    // console.log(`this user value: ${this.userValue}`);
    this.jobsCount = this.data.get("jobsCount");
    console.log(`Jobs count: ${this.jobsCount}`);
    this.jobStatusMap = new Map();
    console.log(this.jobStatusMap);
    this.createWebSocketChannel(this.userValue);
    // debugger;
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
    } catch (error) {
      console.error("Error submitting forms:", error);
    }
  }

  createWebSocketChannel(userValue) {
    // console.log("Creating websocket channel");
    this.channel = this.consumer.subscriptions.create(
      {
        channel: "JobApplicationsChannel",
        id: userValue, // Add the user ID if needed
      },
      {
        connected() {
          // console.log(`Connected to JobApplicationsChannel with ID: ${userValue}`);
        },
        disconnected() {
          // console.log("Disconnected from JobApplicationsChannel");
        },
        received(data) {
          // console.log("Received data from JobApplicationsChannel");
          if (data.event === "job-application-submitted") {
            // console.log("Received job-application-created event");

            const jobId = data.job_id;
            const status = data.status;

            this.trackJobApplicationStatus(jobId, status);

            // console.log(jobId);
            // console.log(status);
            // console.log(this.element);

            const spinner = document.querySelector(`[data-all-application-forms-id="${jobId}"]`);
            const checkmark = document.querySelector(`[data-all-application-forms-id="${jobId}-success"]`);

            if (spinner && checkmark) {
              // console.log("Updating UI")
              if (status === "Applied") {
                // console.log("Status is correct")
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

  trackJobApplicationStatus(jobId, status) {
    // You can use a Map to store the status of each job application
    if (!this.jobStatusMap) {
      this.jobStatusMap = new Map();
    }

    // Store the status of the job application
    this.jobStatusMap.set(jobId, status);

    // Check if all job applications have "Applied" status
    const allApplied = Array.from(this.jobStatusMap.values()).every((s) => s === "Applied");

    if (allApplied) {
      // Redirect to the success page when all job applications are applied
      this.redirectToSuccessPage();
    }
  }

  // Add this method to redirect to the success page
  redirectToSuccessPage() {
    // Replace 'YOUR_SUCCESS_PAGE_URL' with the actual URL of your success page
    window.location.href = "/job_applications/success";
  }

  disconnect() {
    console.log("Disconnecting from JobApplicationsChannel");
    this.channel.unsubscribe();
    this.consumer.disconnect();
  }
}
