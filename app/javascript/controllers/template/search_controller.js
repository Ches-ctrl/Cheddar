import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const searchDisplay = this.getSearchDisplay();

    searchDisplay.addEventListener("click", (ev) => {
      const isTargetInput = ev.target.tagName.toLowerCase() === "input";
      if (!isTargetInput) searchDisplay.classList.add("hidden");
    });

    window.addEventListener("keydown", this.onKeyDown.bind(this));

    return () => {
      window.removeEventListener("keydown", this.onKeyDown.bind(this));
    };
  }

  getSearchDisplay() {
    return document.querySelector('[data-target="search-display"]');
  }

  displaySearch() {
    const searchDisplay = document.querySelector(
      '[data-target="search-display"]'
    );
    searchDisplay.classList.remove("hidden");
  }
  onKeyDown(event) {
    if (event.key === "k" && (event.metaKey || event.ctrlKey)) {
      event.preventDefault();
      this.getSearchDisplay().classList.remove("hidden");
    } else if (event.key === "Escape") {
      event.preventDefault();
      this.getSearchDisplay().classList.add("hidden");
    }
  }
}
