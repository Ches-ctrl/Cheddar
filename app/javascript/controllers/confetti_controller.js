import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti"
// Connects to data-controller="confetti"

export default class extends Controller {

  connect() {
    console.log("Hello, Stimulus Confetti!")
    // this.end = Date.now() + (3 * 1000);
    this.colors = ["#bb0000", "#ffffff"]
    this.click();
  }

  click() {
    // this.end = Date.now() + (3 * 1000);
    // console.log(this.end)
    this.frame();
  }

  frame() {
    console.log(this.end)
    confetti({
      particleCount: 200,
      angle: 60,
      spread: 55,
      origin: { x: 0 },
      colors: this.colors
    });
    confetti({
      particleCount: 200,
      angle: 120,
      spread: 55,
      origin: { x: 1 },
      colors: this.colors
    });
    // console.log(Date.now() < this.end)
    // if (Date.now() < this.end) {
    //   setInterval(() => {
    //     requestAnimationFrame(this.frame());
    //   }, 750);
    // }
  }
}

// document.addEventListener('DOMContentLoaded', (event) => {
//   const btn = document.getElementById("confetti-btn");
//   btn.addEventListener("click", makeConfetti);
// });
