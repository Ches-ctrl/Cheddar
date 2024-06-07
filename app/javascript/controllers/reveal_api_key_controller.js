// app/javascript/controllers/reveal_api_key_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleVisibility(event) {
    // Get the element containing the masked key (assuming it's the previous sibling)
    const keyContainer = event.currentTarget.previousElementSibling;

    // Check if the current content is masked (includes asterisks)
    const isMasked = keyContainer.textContent.includes('****');

    // Retrieve the full key from the button's data attribute
    const fullKey = event.currentTarget.dataset.fullKey;

    // Update the content of the key container:
    // - If currently masked, replace with the full key
    // - Otherwise, call the maskApiKey function to mask the key
    keyContainer.textContent = isMasked ? fullKey : this.maskApiKey(fullKey);
  }

  maskApiKey(apiKey) {
    // Extract the first 4 and last 4 characters
    const firstPart = apiKey.slice(0, 4);
    const lastPart = apiKey.slice(-4);

    // Create the mask string with asterisks
    const mask = '****-****-****-****-********';

    // Combine the masked parts back into a string
    return `${firstPart}${mask}${lastPart}`;
  }
}