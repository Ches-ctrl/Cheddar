import { Controller } from "@hotwired/stimulus";
import { autocomplete } from "@algolia/autocomplete-js";

export default class extends Controller {
  static values = { hasAutocomplete: { type: Boolean, defaultValue: false } };
  connect() {
    this.initializeAutocomplete();

    const searchDisplay = this.getSearchDisplay();

    searchDisplay.addEventListener("click", (ev) => {
      const isTargetInput = ev.target.tagName.toLowerCase() === "input";
      if (!isTargetInput) searchDisplay.classList.add("hidden");
    });

    window.addEventListener("keydown", this.onKeyDown.bind(this));

    return () => {
      window.removeEventListener("keydown", this.onKeyDown.bind(this));
    };
  }

  initializeAutocomplete() {
    if (this.hasAutocompleteValue) return;
    autocomplete({
      container: "#autocomplete",
      debug: true,
      placeholder: "Find something...",
      getSources() {
        return [
          {
            sourceId: "links",
            getItems({ query }) {
              const items = [
                {
                  label:
                    "Senior Developer Advocate Manager, Grafana Developer Advocacy (Remote, Canada EST)",
                  value: 2800,
                },
                {
                  label:
                    "Senior Developer Advocate Manager, Grafana Developer Advocacy (Remote, US EST)",
                  value: 5712,
                },
                { label: "Lead Engine Developer", value: 1132 },
                { label: "Senior Developer, Launcher Team", value: 1135 },
                { label: "Salesforce Developer, GTM Systems", value: 1182 },
                { label: "Lead Game Developer", value: 1194 },
                { label: "Senior Game Developer", value: 1196 },
                { label: "Senior Game Backend Developer (LATAM)", value: 1197 },
                { label: "Senior Game Backend Developer (US)", value: 1198 },
                { label: "Senior Game Developer (APAC)", value: 1200 },
              ];

              return items
                .filter(({ label }) =>
                  label.toLowerCase().includes(query.toLowerCase())
                )
                .slice(0, 5);
            },
            getItemUrl({ item }) {
              return item.url;
            },
            templates: {
              item({ item, components, html }) {
                return html`<div
                  class="flex group block cursor-default px-4 py-3 hover:bg-zinc-50 dark:hover:bg-zinc-800/50 border-t border-zinc-100 dark:border-zinc-800"
                >
                  <a
                    href="/#resources"
                    class="flex flex-col text-sm font-medium text-zinc-900 group-hover:text-emerald-500 dark:text-white"
                  >
                    <span>
                      ${components.Highlight({
                        hit: item,
                        attribute: ["label"],
                        tagName: "em",
                      })}
                    </span>
                    <span
                      class="mt-1 truncate whitespace-nowrap text-2xs text-zinc-500"
                    >
                      Resources / Attachments
                    </span>
                  </a>
                </div>`;
              },
            },
          },
        ];
      },
    });
    this.hasAutocompleteValue = true;
  }

  getSearchDisplay() {
    return document.querySelector('[data-target="search-display"]');
  }

  displaySearch() {
    const searchDisplay = document.querySelector(
      '[data-target="search-display"]'
    );
    searchDisplay.classList.remove("hidden");
  }

  // displaySearch() {
  //   const searchToggle = document.querySelector(".aa-DetachedSearchButton");
  //   searchToggle.click();
  //   const submitButton = document.querySelector(".aa-SubmitButton");
  //   submitButton.innerHTML = `
  //   <svg viewBox="0 0 20 20" fill="none" aria-hidden="true" class="h-5 w-5 stroke-current pointer-events-none absolute left-3 top-0 h-full w-5 stroke-zinc-500"><path stroke-linecap="round" stroke-linejoin="round" d="M12.01 12a4.25 4.25 0 1 0-6.02-6 4.25 4.25 0 0 0 6.02 6Zm0 0 3.24 3.25"></path></svg>
  //   `;
  // }
  onKeyDown(event) {
    // if (event.key === "k" && (event.metaKey || event.ctrlKey)) {
    //   event.preventDefault();
    //   this.displaySearch();
    // } else if (event.key === "Escape") {
    //   event.preventDefault();
    //   const background = document.querySelector(".aa-DetachedCancelButton");
    //   background.click();
    //   // this.getSearchDisplay().classList.add("hidden");
    // }
  }
}













// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {
//   connect() {
//     const searchDisplay = this.getSearchDisplay();

//     searchDisplay.addEventListener("click", (ev) => {
//       const isTargetInput = ev.target.tagName.toLowerCase() === "input";
//       if (!isTargetInput) searchDisplay.classList.add("hidden");
//     });

//     window.addEventListener("keydown", this.onKeyDown.bind(this));

//     return () => {
//       window.removeEventListener("keydown", this.onKeyDown.bind(this));
//     };
//   }

//   getSearchDisplay() {
//     return document.querySelector('[data-target="search-display"]');
//   }

//   displaySearch() {
//     const searchDisplay = document.querySelector(
//       '[data-target="search-display"]'
//     );
//     searchDisplay.classList.remove("hidden");
//   }
//   onKeyDown(event) {
//     if (event.key === "k" && (event.metaKey || event.ctrlKey)) {
//       event.preventDefault();
//       this.getSearchDisplay().classList.remove("hidden");
//     } else if (event.key === "Escape") {
//       event.preventDefault();
//       this.getSearchDisplay().classList.add("hidden");
//     }
//   }
// }
