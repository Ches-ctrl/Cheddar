// app/javascript/controllers/toggle_navigation_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["navigation", "html"]; // Target the HTML element for dark mode class

  connect() {
    console.log("toggle_navigation_controller");
    this.isOpen = false;
  }

  toggleNavigation() {
    this.isOpen = !this.isOpen;

    this.navigationTarget.classList.toggle("hidden");  // Hide/show navigation based on state
    if(this.isOpen) {
        this.htmlTarget.style.overflow = 'hidden';
        this.htmlTarget.style.paddingRight = '15px';
    } else {
        console.log('delete');
        delete this.htmlTarget.style.removeProperty('overflow');
        delete this.htmlTarget.style.removeProperty('padding-right');
    }
  }
}