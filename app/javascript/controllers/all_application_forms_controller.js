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
    this.jobsCount = parseInt(this.data.get("jobsCount"), 10);
    this.appliedJobCount = 0;
    console.log(`Jobs count: ${this.jobsCount}`);
    console.log(`Applied job count 0: ${this.appliedJobCount}`)

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
    console.log(`Jobs count: ${this.jobsCount}`);
    console.log(`Applied job count 1: ${this.appliedJobCount}`)

    this.channel = this.consumer.subscriptions.create(
      {
        channel: "JobApplicationsChannel",
        id: userValue, // Add the user ID if needed
      },
      {
        connected: () => {
          console.log(`Connected to JobApplicationsChannel with ID: ${userValue}`);
        },
        disconnected: () => {
          console.log("Disconnected from JobApplicationsChannel");
        },
        received: (data) => {
          console.log("Received data from JobApplicationsChannel");
          if (data.event === "job-application-submitted") {
            console.log("Received job-application-created event");

            const jobId = data.job_id;
            const status = data.status;

            console.log(jobId);
            console.log(status);
            // console.log(this.element);

            const spinner = document.querySelector(`[data-all-application-forms-id="${jobId}"]`);
            const checkmark = document.querySelector(`[data-all-application-forms-id="${jobId}-success"]`);

            if (spinner && checkmark) {
              console.log("Updating UI")
              if (status === "Applied") {
                console.log("Status is correct")
                spinner.classList.add("d-none");
                checkmark.classList.remove("d-none");

                console.log(this)
                console.log(`Applied job count before increment: ${this.appliedJobCount}`)

                this.appliedJobCount++;
                console.log(`Applied job count 2: ${this.appliedJobCount}`)
                console.log(`Class of Applied Job Count: ${this.appliedJobCount.constructor.name}`);

                console.log(`Jobs count: ${this.jobsCount}`);
                console.log(`Class of Jobs Count: ${this.jobsCount.constructor.name}`);
                console.log(this.appliedJobCount === this.jobsCount)

                if (this.appliedJobCount === this.jobsCount) {
                  console.log("All jobs applied to");
                  console.log("Redirecting you...");
                  // console.log(this.redirectToSuccessPage());
                  // this.redirectToSuccessPage();
                  window.location.href = "/job_applications/success";
                }
              } else {
                // Handle other statuses if needed
              }
            }
          }
        },
      }
    );
  }

  redirectToSuccessPage() {
    window.location.href = "/job_applications/success";
  }

  disconnect() {
    console.log("Disconnecting from JobApplicationsChannel");
    this.channel.unsubscribe();
    this.consumer.disconnect();
  }
}
