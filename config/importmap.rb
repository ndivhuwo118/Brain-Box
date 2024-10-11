# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "localtunnel" # @2.0.2
pin "#lib/adapters/http.js", to: "#lib--adapters--http.js.js" # @0.21.4
pin "axios" # @0.21.4
pin "debug" # @4.3.2
pin "events" # @2.0.1
pin "fs" # @2.0.1
pin "ms" # @2.1.2
pin "net" # @2.0.1
pin "process" # @2.0.1
pin "stream" # @2.0.1
pin "tls" # @2.0.1
pin "url" # @2.0.1
