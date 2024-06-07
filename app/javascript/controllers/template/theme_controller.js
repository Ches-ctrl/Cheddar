import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  toggleTheme() {
    const doc = document.querySelector("html");
    doc.classList.toggle("dark");
  }
}
