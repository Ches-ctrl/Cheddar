import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="company-modal"
export default class extends Controller {
  static targets = ["modal", "content"];

  show() {
    this.modalTarget.classList.add("active");
    // Fetch and load the company show page content into the modal
    fetch(`/companies/${this.data.get("companyId")}`)
      .then((response) => response.text())
      .then((html) => {
        this.contentTarget.innerHTML = html;
      });
  }

  hide() {
    this.modalTarget.classList.remove("active");
    this.contentTarget.innerHTML = ""; // Clear the modal content
  }
}
