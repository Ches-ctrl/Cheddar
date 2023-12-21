import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
export default class extends Controller {
  static targets = ["form"];

  connect() {
    console.log("Hello, Carousel stimulus connected", this.element);
    this.currentIndex = 0;
    this.showForm(this.currentIndex);
  }

  prevForm() {
    this.currentIndex = (this.currentIndex - 1 + this.formTargets.length) % this.formTargets.length;
    this.showForm(this.currentIndex);
  }

  nextForm() {
    this.currentIndex = (this.currentIndex + 1) % this.formTargets.length;
    this.showForm(this.currentIndex);
  }

  showForm(index) {
    this.formTargets.forEach((form, i) => {
      if (i === index) {
        form.classList.add("active"); // Add an "active" class to the form
      } else {
        form.classList.remove("active"); // Remove the "active" class from other forms
      }
    });
  }
}
