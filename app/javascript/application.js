// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "tom-select"
import "canvas-confetti"
import "@rails/actioncable"

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()