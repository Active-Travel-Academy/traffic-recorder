# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@rails/ujs', to: 'https://cdn.skypack.dev/@rails/ujs', preload: true
pin 'leaflet', to: "https://unpkg.com/leaflet@#{Leaflet::VERSION}/dist/leaflet.js", preload: true
pin 'leaflet-draw', to: "https://unpkg.com/leaflet-draw@#{Leaflet::DRAW_VERSION}/dist/leaflet.draw.js", preload: true
pin 'choices.js', to: 'https://cdn.jsdelivr.net/npm/choices.js@11.0.2/public/assets/scripts/choices.mjs'
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin 'popper', to: 'popper.js', preload: true
pin 'bootstrap', to: 'bootstrap.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
