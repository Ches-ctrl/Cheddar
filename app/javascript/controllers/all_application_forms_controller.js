import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "button"]
  connect() {
    console.log('Parent controller connected');
    console.log(this.formTargets);
  }

  async submitAllForms(event) {
    event.preventDefault();
    this.buttonTarget.disabled = true;

    try {
      await new Promise((resolve) => {
        setTimeout(() => {
          resolve();
        }, 10000);
      });

      await Promise.all(
        this.formTargets.map(async (form) => {
          await new Promise((resolve) => {
            setTimeout(() => {
              form.requestSubmit();
              // You can render a modal here to show that the form has been submitted
              resolve();
            }, 2000);
          });
        })
      );

      console.log("All forms submitted");
      window.location.href = "/job_applications/success";
    } catch (error) {
      console.error("Error submitting forms:", error);
      // Handle any errors here
    }
  }
}


// Louis Original Code:
// submitAllForms(event) {
//   event.preventDefault();
//   this.buttonTarget.disabled = true;
//   // this.triggerSubmissions();
//   // Open the modal here
//   Promise.all(
//     this.formTargets.map((form) => {
//       console.log(form);
//       new Promise((resolve, reject) => {
//         setTimeout(() => {
//           form.requestSubmit();
//           // render modal to show that the form has been submitted
//         }, 2000);
//       });
//     })
//   ).then(() => {
//     console.log("All forms submitted");
//     window.location.href = "/job_applications/success";
//   });
//   // this.application.controllers.forEach(controller => {
//   //   if (controller.identifier === "application-form") {
//   //     controller.submitForm();
//   //   }
//   // });
// }
