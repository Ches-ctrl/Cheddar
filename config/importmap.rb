# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "tom-select", to: "https://ga.jspm.io/npm:tom-select@2.3.1/dist/js/tom-select.complete.js"
pin "canvas-confetti", to: "https://ga.jspm.io/npm:canvas-confetti@1.9.2/dist/confetti.module.mjs"
pin "@rails/actioncable", to: "https://cdn.jsdelivr.net/npm/@rails/actioncable@7.1.2/app/assets/javascripts/actioncable.esm.js"
# pin "@algolia/autocomplete-core", to: "@algolia--autocomplete-core.js" # @1.17.2
# pin "@algolia/autocomplete-js", to: "@algolia--autocomplete-js.js" # @1.17.2
# pin "@algolia/autocomplete-plugin-algolia-insights", to: "@algolia--autocomplete-plugin-algolia-insights.js" # @1.17.2
# pin "@algolia/autocomplete-preset-algolia", to: "@algolia--autocomplete-preset-algolia.js" # @1.17.2
# pin "@algolia/autocomplete-shared", to: "@algolia--autocomplete-shared.js" # @1.17.2
# pin "@algolia/autocomplete-shared/dist/esm/core", to: "@algolia--autocomplete-shared--dist--esm--core.js" # @1.17.2
# pin "@algolia/autocomplete-shared/dist/esm/js", to: "@algolia--autocomplete-shared--dist--esm--js.js" # @1.17.2
# pin "@algolia/autocomplete-shared/dist/esm/preset-algolia/algoliasearch", to: "@algolia--autocomplete-shared--dist--esm--preset-algolia--algoliasearch.js" # @1.17.2
# pin "@algolia/autocomplete-shared/dist/esm/preset-algolia/createRequester", to: "@algolia--autocomplete-shared--dist--esm--preset-algolia--createRequester.js" # @1.17.2
# pin "htm" # @3.1.1
# pin "preact" # @10.22.0
pin "@algolia/autocomplete-js", to: "https://ga.jspm.io/npm:@algolia/autocomplete-js@1.17.2/dist/esm/index.js"
pin "@algolia/autocomplete-core", to: "https://ga.jspm.io/npm:@algolia/autocomplete-core@1.17.2/dist/esm/index.js"
pin "@algolia/autocomplete-plugin-algolia-insights", to: "https://ga.jspm.io/npm:@algolia/autocomplete-plugin-algolia-insights@1.17.2/dist/esm/index.js"
pin "@algolia/autocomplete-preset-algolia", to: "https://ga.jspm.io/npm:@algolia/autocomplete-preset-algolia@1.17.2/dist/esm/index.js"
pin "@algolia/autocomplete-shared", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.17.2/dist/esm/index.js"
pin "@algolia/autocomplete-shared/dist/esm/core", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.17.2/dist/esm/core/index.js"
pin "@algolia/autocomplete-shared/dist/esm/js", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.17.2/dist/esm/js/index.js"
pin "@algolia/autocomplete-shared/dist/esm/preset-algolia/algoliasearch", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.17.2/dist/esm/preset-algolia/algoliasearch.js"
pin "@algolia/autocomplete-shared/dist/esm/preset-algolia/createRequester", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.17.2/dist/esm/preset-algolia/createRequester.js"
pin "htm", to: "https://ga.jspm.io/npm:htm@3.1.1/dist/htm.module.js"
pin "preact", to: "https://ga.jspm.io/npm:preact@10.22.0/dist/preact.module.js"
