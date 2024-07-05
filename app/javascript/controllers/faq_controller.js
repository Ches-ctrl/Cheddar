// app/javascript/controllers/dark_mode_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "content", "collapsedIcon", "expandedIcon"]

  connect() {
    this.content = this.element.querySelector("dd")
    this.collapsedIcon = this.element.querySelector(".icon-collapsed")
    this.expandedIcon = this.element.querySelector(".icon-expanded")
  }

  toggle(event) {
    const isExpanded = this.button.getAttribute("aria-expanded") === "true"

    this.button.setAttribute("aria-expanded", !isExpanded)
    this.content.classList.toggle("hidden", isExpanded)
    this.collapsedIcon.classList.toggle("hidden", !isExpanded)
    this.expandedIcon.classList.toggle("hidden", isExpanded)
  }

  get button() {
    return this.element.querySelector("button")
  }
}
