// app/javascript/controllers/dark_mode_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["html"]; // Target the HTML element for dark mode class

  connect() {
    console.log("here");
  }

  toggleDarkMode() {
    // Toggle the "dark" class on the HTML element
    this.htmlTarget.classList.toggle("dark");
  }
}