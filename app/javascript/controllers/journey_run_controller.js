import { Controller } from "@hotwired/stimulus"
import { tileLayerConfig } from "../leaflet_config"

export default class extends Controller {
    static values = {
        line: Array,
    }

    connect() {
        this.initializeMap()
    }

    initializeMap() {
        console.log("Initializing map...")
        this.map = L.map(this.element)
        const pnts = this.lineValue.map((pnt) => new L.LatLng(pnt[1], pnt[0]))
        const pline = new L.Polyline(pnts, {
            color: 'green',
            weight: 4,
            opacity: 0.6,
        })
        pline.addTo(this.map);
        this.map.fitBounds(pline.getBounds().pad(0.5))
        L.tileLayer(tileLayerConfig.url, tileLayerConfig.options).addTo(this.map)
    }

    disconnect() {
        this.map?.remove()
    }
}
