import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "button", "overlay", "success"]

  connect() {
    console.log("All forms controller connected");
    this.completedJobApplications = new Set();
    this.startStatusChecks();
  }

  async submitAllForms(event) {
    event.preventDefault();
    this.buttonTarget.disabled = true;
    this.overlayTarget.classList.remove("d-none");

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
              resolve();
            }, 1000);
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

  startStatusChecks() {
    const interval = 1000;

    const statusCheck = () => {
      document.querySelectorAll("[data-all-application-forms-target='overlay'] [data-all-application-forms-id]").forEach(async (spinner) => {
        const jobId = spinner.getAttribute("data-all-application-forms-id");
        console.log("Job application ID:", jobId);
        if (jobId && !this.completedJobApplications.has(jobId)) {
          try {
            const response = await fetch(`/job_applications/${jobId}/status`);
            if (response.ok) {
              const data = await response.json();
              this.updateStatus(jobId, data.status);
              // Add the completed job application to the set
              if (data.status === "applied") {
                this.completedJobApplications.add(jobId);
                console.log("Completed job applications:", this.completedJobApplications);
              }
              // Check if all job applications are completed
              const totalSpiners = document.querySelectorAll("[data-all-application-forms-target='overlay'] [data-all-application-forms-id]").length;
              if (this.completedJobApplications.size === totalSpiners) {
                // Redirect only when all are done
                console.log("All job applications completed");
                window.location.href = "/job_applications/success";
              }
            }
          } catch (error) {
            console.error("Error fetching status:", error);
          }
        }
      });
    };

    // Start status checks at regular intervals
    const statusInterval = setInterval(statusCheck, interval);
  }


  updateStatus(jobId, status) {
    // Update the loading modal with the received status data for the corresponding job application
    // You can implement the logic to update individual modals here
    // This could include showing a loading icon for each job application and updating it based on the status
    const spinner = document.querySelector(`[data-job-application-id="${jobId}"]`);
    if (spinner) {
      spinner.classList.add("d-none");
      const tickIcon = document.createElement("i");
      tickIcon.classList.add("fa", "fa-check"); // Assuming you're using Font Awesome for icons
      spinner.parentNode.replaceChild(tickIcon, spinner);
    }
  }
}
