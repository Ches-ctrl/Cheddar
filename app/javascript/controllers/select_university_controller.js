import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="select-university"
export default class extends Controller {
  static targets = [ "button" ]

  connect() {
    console.log(this.buttonTarget)
    new TomSelect(this.buttonTarget, {
      plugins: ["remove_button"],
      create: true,
      sortField: {
        field: "text",
        direction: "asc"
      }
    })
  }
}
