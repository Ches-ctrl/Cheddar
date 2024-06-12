import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content"];

  toggle() {
    const isHidden = this.contentTarget.classList.contains("hidden");
    if (isHidden) {
      this.contentTarget.classList.toggle("hidden");
      const { width } = this.contentTarget.getBoundingClientRect();
      this.contentTarget.animate(
        [
          { transform: "translateX(0px)" },
          { transform: `translate(-${width}px)` },
        ],
        {
          duration: 300,
          direction: "reverse",
          easing: "linear",
        }
      );
    } else {
      const { width } = this.contentTarget.getBoundingClientRect();

      const outroAnimation = this.contentTarget.animate(
        [
          { transform: "translateX(0px)" },
          { transform: `translate(-${width}px)` },
        ],
        {
          duration: 300,
          direction: "normal",
          easing: "linear",
        }
      );
      outroAnimation.finished.then((res) => {
        this.contentTarget.classList.toggle("hidden");
      });
    }
  }
}
