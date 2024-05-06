// company_jobs_filter_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  async submit(event) {
    event.preventDefault();
    
    const form = event.target.closest('form');
    if (!form) {
      console.error("Cannot find parent form element");
      return;
    }

    try {
      const formData = new FormData(form);
      const method = form.method.toUpperCase();
      const url = new URL(form.action);

      if (method === 'GET') {
        formData.forEach((value, key) => {
          if (!value) formData.delete(key);
        });
        url.search = new URLSearchParams(formData).toString();
      }

      const response = await fetch(url, {
        method,
        headers: {
          'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
        },
        body: method !== 'GET' ? formData : undefined
      });

      if (!response.ok) {
        throw new Error('Network response was not ok');
      }

      const turboStreamHTML = await response.text();
      document.getElementById('jobs').innerHTML = turboStreamHTML;
    } catch (error) {
      console.error('Error:', error);
    }
  }
}
