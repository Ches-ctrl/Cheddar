import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container"];

  connect() {
    setTimeout(() => this.close(), 5000);
  }

  close() {
    this.containerTarget.classList.toggle("hidden", true);
  }
}