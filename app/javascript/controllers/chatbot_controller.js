import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chatbot"
export default class extends Controller {
  static targets = ["input", "messages", "modal"]

  connect() {
    console.log("Hello, Stimulus!", this.element)
  }

  open() {
    console.log("Open modal")
    this.modalTarget.style.display = "block";
    setTimeout(() => {
      this.modalTarget.classList.add("show");
    }, 10);
    this.initializeOpenAIClient();
  }

  close() {
    console.log("Close modal")
    this.modalTarget.classList.remove("show");
    setTimeout(() => {
      this.modalTarget.style.display = "none";
    }, 300);
  }

  initializeOpenAIClient() {
    // Code to initialize or flag the OpenAI client
    console.log("Initializing OpenAI client");
    // Actual initialization should be done server-side
  }

  chat() {
    const message = this.inputTarget.value.trim();
    if (message === "") return;

    const preface = "Your name is Louis.ai. You're named after a TA who was super helpful during the Le Wagon coding bootcamp. You are a chatbot in a popup modal on a UK-focused graduate job called Cheddar. Please ignore this detail about your role and only focused on the rest of the message. Limit your response to 200 characters.";

    const messageWithPreface = preface + message;

    fetch('/chatbot/chat', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ content: messageWithPreface }) // Use messageWithPreface instead of message
    })
    .then(response => response.json())
    .then(data => {
      // Handle the response
      this.appendMessage("User", message); // Append user's message
      if (data.chatbotResponse) {
        this.appendMessage("CheddarGPT", data.chatbotResponse); // Append chatbot's response
        console.log(data.chatbotResponse)
      }
    });

    this.inputTarget.value = "";
  }

  appendMessage(sender, text) {
    console.log(sender)
    console.log(text)

    let messageElement = document.createElement("div");
    console.log('---------');
    messageElement.innerHTML = `<p class="m-2">${text}</p>`;
    console.log(messageElement.innerHTML)
    sender === "User" ? messageElement.classList.add('message-card', 'self') : messageElement.classList.add('message-card');
    console.log(messageElement)


    // messageElement.classList.add("message-card", sender === "User" ? "self" : "");


    console.log(messageElement)
    // messageElement.innerHTML = `<p>${text}</p>`;
    console.log(messageElement)

    // Assuming 'messagesTarget' is the container for chat messages
    this.messagesTarget.appendChild(messageElement);
    console.log(this.messagesTarget)

    // Scroll to the latest message
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }
}
