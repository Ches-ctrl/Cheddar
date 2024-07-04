import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdownContainer", "dropdown"];

  connect() {
    document.addEventListener('click', this.handleClickOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside.bind(this));
  }

  toggle(event) {
    event.preventDefault();
    event.stopPropagation();
    this.toggleVisibility();
  }

  toggleVisibility() {
    const isHidden = this.dropdownTarget.classList.contains("hidden");

    if (isHidden) {
      this.showMenu();
    } else {
      this.hideMenu();
    }
  }

  showMenu() {
    this.dropdownTarget.classList.remove("hidden");
    this.dropdownTarget.classList.remove("ease-in", "duration-75", "transform", "opacity-0", "scale-95");
    this.dropdownTarget.classList.add("ease-out", "duration-100", "transform", "opacity-100", "scale-100");
  }

  hideMenu() {
    this.dropdownTarget.classList.remove("ease-out", "duration-100", "transform", "opacity-100", "scale-100");
    this.dropdownTarget.classList.add("ease-in", "duration-75", "transform", "opacity-0", "scale-95");
    setTimeout(() => {
      this.dropdownTarget.classList.add("hidden");
    }, 75); // Duration matches the 'ease-in duration-75'
  }

  handleClickOutside(event) {
    if (!this.dropdownContainerTarget.contains(event.target) && !this.dropdownTarget.classList.contains("hidden")) {
      this.hideMenu();
    }
  }
}
