import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reveal-myapplication-details"
export default class extends Controller {
  static targets = [ 'toggleReveal', 'applicationDetails' ]

  connect() {
    this.applicationDetailsTarget.style.marginBottom = `-${this.applicationDetailsTarget.clientHeight}px`;
    this.open = false;
  }

  revealApplicationDetails(event) {
    console.log(event);
    console.log(this.applicationDetailsTarget);
    this.element.classList.toggle('show');
    if (this.open) {
      this.applicationDetailsTarget.style.marginBottom = `-${this.applicationDetailsTarget.clientHeight}px`;
    } else {
      this.applicationDetailsTarget.style.marginBottom = `0px`;
    }
    this.open = !this.open;
    // this.applicationDetailsTargets.forEach((applicationDetails) => {
    //   applicationDetails.classList.toggle('d-none')
    //   // console.log(event.currentTarget)
    //   // event.currentTarget.querySelector('')
    //   // event.currentTarget.classList.toggle('d-none')
    //   // applicationDetails.querySelector("#").classList.toggle(d-none)
    // })


  }
}


document.addEventListener('click', (e) => {
  console.log(e.target);
})
