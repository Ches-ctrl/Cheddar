import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['group', 'template', 'placeholder'];

  connect() {
    console.log("Hello from Group Controller!");
  }

  increment_ids(fields, labels, nextId) {
    fields.forEach(field => {
      const id = field.id
      field.id = id + `[${nextId}]`
    })
    labels.forEach(label => {
      const forId = label.htmlFor
      label.htmlFor = forId + `[${nextId}]`
    })
  }

  addGroup() {
    const newGroup = this.templateTarget.content.cloneNode(true)
    const labels = newGroup.querySelectorAll('label')
    const fields = newGroup.querySelectorAll('input')
    const nextId = this.groupTarget.querySelectorAll('.question-group').length
    this.increment_ids(fields, labels, nextId)
    this.placeholderTarget.appendChild(newGroup)
  }
}
