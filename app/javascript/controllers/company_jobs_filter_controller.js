import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
      this.element.dataset.action = "change->company-jobs-filter#submit";
    }

  async submit() {
    const value = this.element.value;
    const url = this.element.dataset.url;
    const turboType = this.element.dataset.turboType;
    this.url = (`${url}?department=${value}`)

    let frame = document.querySelector(`turbo-frame#${turboType}`)
    frame.src = this.url
    frame.reload();
  }
}
