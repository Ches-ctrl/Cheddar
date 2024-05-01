import { Controller } from "@hotwired/stimulus";
import { createConsumer } from "@rails/actioncable";

export default class extends Controller {
  static targets = ["form", "button", "overlay", "editor", "content", "logo"];
  static values = { user: Number };

  // RESET POINT

  connect() {
    console.log("All forms controller connected");
    this.consumer = createConsumer();
    this.jobsCount = parseInt(this.data.get("jobsCount"), 10);
    this.appliedJobCount = 0;
    this.createWebSocketChannel(this.userValue);
  }

  updateCoverLetterContent(i) {
    console.log("Updating cover letter content");
    const editor = tinymce.get(this.editorTargets[i].id);
    if (editor !== null) {
      const editorContent = editor.getContent();
      // const form = editor.targetElm.closest("form");
      const hiddenField = document.getElementById(this.contentTargets[i].id);
      if (hiddenField) {
        hiddenField.value = editorContent;
      }
    }
  }

  async submitAllForms(event) {
    event.preventDefault();
    this.buttonTarget.disabled = true;
    this.overlayTarget.classList.remove("d-none");

    const submissions = this.formTargets.map(async (form, index) => {
      this.updateCoverLetterContent(index);

      const formData = new FormData(form);
      return fetch(form.action, {
        method: 'POST',
        body: formData
      });
    });
  }



  createWebSocketChannel(userValue) {
    // console.log("Creating websocket channel");

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

            const spinner = document.querySelector(`[data-all-application-forms-id="${jobId}"]`);
            const checkmark = document.querySelector(`[data-all-application-forms-id="${jobId}-success"]`);

            if (spinner && checkmark) {
              if (status === "Applied") {
                spinner.classList.add("d-none");
                checkmark.classList.remove("d-none");

                this.appliedJobCount++;

                if (this.appliedJobCount === this.jobsCount) {
                  this.redirectToSuccessPage();
                  window.location.href = "/job_applications/success"; // this line redundant?
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
