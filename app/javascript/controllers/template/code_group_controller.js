import { Controller } from "@hotwired/stimulus";
// import { getHighlighter } from "shiki";

export default class extends Controller {
  static targets = [
    "content",
    "contentDisplay",
    "languageSelectorContainer",
    "copyContent",
    "copiedContent",
    "copyButton",
  ];
  // async connect() {
  //   const highlighter = await getHighlighter({
  //     themes: ["ayu-dark"],
  //     langs: [
  //       "javascript",
  //       "typescript",
  //       "ruby",
  //       "c#",
  //       "go",
  //       "bash",
  //       "jsx",
  //       "python",
  //       "php",
  //     ],
  //   });
  //   this.highlighter = highlighter;
  //   this.initializeValue();
  // }

  initializeValue() {
    const contentContainer = this.element.querySelector("[data-code-content]");
    if (contentContainer) {
      this.contentDisplayTarget.innerHTML = this.highlighter.codeToHtml(
        contentContainer.innerText,
        {
          lang: contentContainer.dataset.language,
          theme: "ayu-dark",
        }
      );
    } else {
      this.languageSelectorContainerTarget.querySelector("button")?.click();
    }
  }

  changeLanguage(ev) {
    const selectedLanguage = ev.target.dataset.language;
    const displayAs = ev.target.dataset.displayAs;
    const currContent = this.getLanguageContent(selectedLanguage);
    this.setSelectedButtonStyle(selectedLanguage);
    this.displayContent(currContent, displayAs);
  }

  setSelectedButtonStyle(selectedLanguage) {
    const languageSelectors =
      this.languageSelectorContainerTarget.querySelectorAll("button");
    languageSelectors.forEach((el) => {
      if (el.dataset.language !== selectedLanguage)
        el.classList.remove("border-b", "border-mauve-500", "text-mauve-400");
      else el.classList.add("border-b", "border-mauve-500", "text-mauve-400");
    });
  }

  getLanguageContent(language) {
    const data = this.contentTarget.querySelector(
      `[data-content-for=${language}]`
    ).innerText;
    return data;
  }

  displayContent(content, language) {
    this.contentDisplayTarget.innerHTML = this.highlighter.codeToHtml(content, {
      lang: language,
      theme: "ayu-dark",
    });
    this.contentDisplayTarget
      .querySelector("pre")
      .classList.add("!bg-transparent");
  }

  copyContent(ev) {
    window.navigator.clipboard.writeText(this.contentDisplayTarget.innerText);

    this.copyButtonTarget.classList.add(
      "bg-mauve-400/10",
      "ring-1",
      "ring-inset",
      "ring-mauve-400/20"
    );
    this.copyContentTarget.classList.add("opacity-0", "-translate-y-1.5");
    this.copiedContentTarget.classList.remove("translate-y-1.5", "opacity-0");

    setTimeout(() => {
      this.copyButtonTarget.classList.remove(
        "bg-mauve-400/10",
        "ring-1",
        "ring-inset",
        "ring-mauve-400/20"
      );
      this.copyContentTarget.classList.remove("opacity-0", "-translate-y-1.5");
      this.copiedContentTarget.classList.add("translate-y-1.5", "opacity-0");
    }, 1000);
  }
}
