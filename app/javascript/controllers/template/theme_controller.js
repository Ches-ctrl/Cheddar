import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["whiteLogo", "blackLogo"];

  toggleTheme() {
    const html = document.querySelector("html");
    const currentScheme = html.style.colorScheme;

    const newScheme = currentScheme === 'light' ? 'dark' : 'light';
    html.style.colorScheme = newScheme;
    html.classList.toggle("dark");
    this.blackLogoTarget.classList.toggle("hidden");
    this.whiteLogoTarget.classList.toggle("hidden");

  }
}