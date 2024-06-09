import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  toggleTheme() {
    const html = document.querySelector("html");
    const currentScheme = html.style.colorScheme;

    const newScheme = currentScheme === 'light' ? 'dark' : 'light';
    html.style.colorScheme = newScheme;
    html.classList.toggle("dark");
  }
}