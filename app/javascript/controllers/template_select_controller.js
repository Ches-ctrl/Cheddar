import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log("Template Select Controller Active")
  }

  editor_content(data) {
    const editor = tinymce.get("coverLetterEditor")

    if (editor) {
      editor.setContent(data);
    } else {
      tinymce.init({
        selector: '#coverLetterEditor',
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
          const formattedContent = data["template"].replace(/ /g, '&nbsp;').replace(/\t/g, '&emsp;').replace(/\r\n|\n|\r/g, '<br>')
          this.editor_content(formattedContent)
      })
    } else {
      this.editor_content("")
      }
    const editor = document.getElementById("coverLetterEditor")
    editor.classList.remove("d-none")

  }
}
