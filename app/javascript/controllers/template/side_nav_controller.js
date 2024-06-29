import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["link"];
  connect() {
    document.addEventListener("turbo:load", () => {
      this.linkTargets.forEach((linkContainer) => {
        const link = linkContainer.querySelector("a");
        const isLinkActive = this.getLinkStatus(link.getAttribute("href"));
        link.className = this.setLinkClasses(isLinkActive);
        const children = linkContainer.querySelector("ul");
        children.classList.toggle("hidden", !isLinkActive);
        if (isLinkActive) {
          const refs = this.getPageRefs();
          refs.forEach((el) => {
            const anchor = this.getPageAnchor(el);
            children.insertAdjacentElement("beforeend", anchor);
          });
        }
      });
    });
  }

  getPageAnchor(anchorTo) {
    const item = document.createElement("li");
    const link = document.createElement("a");
    link.href = anchorTo.getAttribute("href");
    link.className =
      "flex justify-between gap-2 py-1 pr-3 text-sm transition pl-7 text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-white";
    const textContainer = document.createElement("span");
    textContainer.innerText = anchorTo.innerText;

    link.insertAdjacentElement("beforeend", textContainer);
    item.insertAdjacentElement("beforeend", link);
    return item;
  }

  getPageRefs() {
    const refs = document.querySelectorAll('article [data-target="anchor"]');
    return refs;
  }

  getLinkStatus(url) {
    const currPath = window.location.pathname;

    return (currPath.startsWith(url) && url != "/") || currPath == url;
  }

  setLinkClasses(isActive) {
    const base_classes =
      "flex justify-between gap-2 py-1 pr-3 text-sm transition pl-4";
    const active_classes =
      "text-zinc-900 dark:text-white border-l border-l-mauve-500";
    const inactive_classes =
      "text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-white";
    if (isActive) return `${base_classes} ${active_classes}`;
    return `${base_classes} ${inactive_classes}`;
  }
}
