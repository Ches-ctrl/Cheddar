import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['editor']

  connect() {
    console.log("Template Select Controller Active")
  }

  editor_content(data) {
    const editor = tinymce.get(this.editorTarget.id)

    if (editor) {
      editor.setContent(data);
    } else {
      tinymce.init({
        selector: `#${this.editorTarget.id}`,
        setup: function (editor) {
          editor.on('init', function () {
            editor.setContent(data);
          });
        }
      });
    }
  }

  select(event) {
    const filename = event.target.options[event.target.selectedIndex].text
    if (filename !== "Write from Scratch") {
      fetch('/users/fetch_template', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
        },
        body: JSON.stringify({
          filename: filename
        }),
      }).then((response) => response.json())
        .then((data) => {
          const formattedContent = data["template"].replace(/ /g, '&nbsp;').replace(/\t/g, '&emsp;').replace(/\r\n|\n|\r/g, '<br>').replace(/-/g, '&#8209;')
          this.editor_content(formattedContent)
      })
    } else {
      this.editor_content("")
      }
    const editor = this.editorTarget
    editor.classList.remove("d-none")

  }
}
