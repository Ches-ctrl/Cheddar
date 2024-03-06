import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['triangle']

  connect() {
    this.triangleTargets.forEach(triangle => {
      const position = triangle.getAttribute("data-position")
      triangle.style.left = position + '%'
    })
  }
}
