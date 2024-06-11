import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // static targets = ["whiteLogo", "blackLogo"];

  connect() {
    // this.toggleLogo();
  }

  toggleTheme() {
    const html = document.querySelector("html");
    const currentScheme = html.style.colorScheme;
    const newScheme = currentScheme === 'light' ? 'dark' : 'light';

    html.style.colorScheme = newScheme;
    html.classList.toggle("dark");
    // this.toggleLogo();
  }

  // toggleLogo() {
  //   const html = document.querySelector("html");
  //   const currentScheme = html.style.colorScheme;
  //   const isDarkMode = currentScheme === 'dark';

  //   this.whiteLogoTarget.classList.toggle("hidden", !isDarkMode);
  //   this.blackLogoTarget.classList.toggle("hidden", isDarkMode);
  // }
}