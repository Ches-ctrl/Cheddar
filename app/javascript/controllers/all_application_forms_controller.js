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
    this.failedCount = 0;
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
    const isValid = this.validateForms();

    if ( !isValid ) {
      return;
    }

    this.buttonTarget.disabled = true;
    this.overlayTarget.classList.remove("d-none");

    const submissions = this.formTargets.map(async (form, index) => {
      this.updateCoverLetterContent(index);

      const formData = new FormData(form);
      return fetch(form.action, {
        method: 'POST',
        body: formData
      }).then(response => response.json())
        .then(data => {
          if ( !response.ok) {
            this.handleServerSideErrors(form, data.errors);
          }
        })
    });
  }

  validateForms() {
    let firstInvalidField = null;

    this.formTargets.forEach((form) => {
      if ( !form.checkValidity()) {
        const invalidFields = form.querySelectorAll(":invalid");
        invalidFields.forEach(field => {
          field.classList.add("is-invalid");
          if ( !firstInvalidField) {
            firstInvalidField = field;
          }
        });
      }
    });

    if (firstInvalidField) {
      firstInvalidField.focus();
      firstInvalidField.scrollIntoView({ behavior: "smooth", block: "center" });
      return false
    }

    return true;
  }

  handleServerSideErrors(form, errors) {
    for (const [field, messages] of Object.entries(errors)) {
      const input = form.querySelector(`[name="${field}"]`);
      const errorElement = input.nextElementSibling;
      errorElement.textContent = messages.join(", ");
      input.classList.add("is-invalid");
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
            const crossmark = document.querySelector(`[data-all-application-forms-id="${jobId}-failed"]`);

            if (spinner && checkmark && crossmark) {
              if (status === "Applied") {
                spinner.classList.add("d-none");
                checkmark.classList.remove("d-none");

                this.appliedJobCount++;

              } else if (status === "Submission failed") {
                spinner.classList.add("d-none");
                crossmark.classList.remove("d-none");

                this.failedCount++;
              }

              if (this.appliedJobCount + this.failedCount === this.jobsCount) {
                if (this.failedCount > 0) {
                  alert("Some applications failed to submit. Please submit them manually.");
                  this.redirectToApplicationsPage();
                } else {
                  this.redirectToSuccessPage();s
                }
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

  redirectToApplicationsPage() {
    window.location.href = "/job_applications";
  }

  disconnect() {
    console.log("Disconnecting from JobApplicationsChannel");
    this.channel.unsubscribe();
    this.consumer.disconnect();
  }
}
