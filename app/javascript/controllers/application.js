import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application
window.process = { env: { NODE_ENV: "PRODUCTION" } }; // otherwise autocomplete.js doesn't load

export { application }
