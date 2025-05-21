import { Controller } from "@hotwired/stimulus"
import 'leaflet-draw'
import { tileLayerConfig } from "../leaflet_config"

export default class extends Controller {
  static values = {
    lat: Number,
    lng: Number,
    name: String,
    destLat: Number,
    destLng: Number,
    originOrPoi: String,
    destName: String,
    formPrefix: String,
    editMode: Boolean,
    persisted: Boolean
  }

  connect() {
    this.initializeMap()
    if (this.editModeValue) {
      this.addDrawingTools()
    }

    if (this.persistedValue) {
      this.addExistingMarker()
    }
  }

  initializeMap() {
    this.map = L.map(this.element).setView([this.latValue, this.lngValue], 13)
    document.addEventListener("choices:categorySelected", (event) => {
      this.category = event.detail.category
      this.loadCategory()
      if (!this.mapMoveCategoryLoad) {
        this.map.on("moveend", () => {
          if (this.category) {
            this.debounce(this.loadCategory.bind(this), 300)
          }
        })
        this.mapMoveCategoryLoad = true
      }
    })
    L.tileLayer(tileLayerConfig.url, tileLayerConfig.options).addTo(this.map)
  }

  debounce(fn, delay = 300) {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => fn.apply(this), delay)
  }

  async loadCategory() {
    const center = this.map.getCenter()
    const url = new URL("/ltns/3/point_of_interests/search", window.location.origin)

    url.searchParams.append("cat", this.category)
    url.searchParams.append("lat", center.lat)
    url.searchParams.append("lng", center.lng)

    const response = await fetch(url)
    if (!response.ok) return

    const geojson = await response.json()
    this.removeFeatureLayer()
    this.featureLayer = L.geoJSON(geojson, {
      pointToLayer: (feature, latlng) => {
        return L.circleMarker(latlng, {
          fillColor: "#888",
          color: "#666",
          fillOpacity: 0.7
        })
      },
      onEachFeature: (feature, layer) => {
        const name = feature.properties.name || "Unnamed"
        const address = feature.properties.address || "No address"
        const website = feature.properties.metadata.website
        const featureId = feature.properties.id

        let popupContent = `<div><strong>${name}</strong></br>${address}`
        if (website) {
          popupContent = `${popupContent}</br>${website}`
        }
        popupContent = `${popupContent}
          </br>
          <a href="#"
               data-action="location#selectFeature"
               data-lat="${feature.geometry.coordinates[1]}"
               data-lng="${feature.geometry.coordinates[0]}"
               data-name="${name}">Select</a>
        </div>`
        layer.bindPopup(popupContent)
      }
    }).addTo(this.map)

  }

  removeFeatureLayer() {
    if (this.featureLayer) {
      this.map.removeLayer(this.featureLayer)
      this.featureLayer = null
    }
  }

  selectFeature(event) {
    event.preventDefault()
    this.category = null

    const lat = parseFloat(event.target.dataset.lat)
    const lng = parseFloat(event.target.dataset.lng)

    this.removeFeatureLayer()
    const marker = L.marker([lat, lng], { draggable: true, title: event.target.dataset.name })
    this.drawnItems.addLayer(marker)
    this.handleDrawCreated({ layer: marker, name: event.target.dataset.name })
  }

  addDrawingTools() {
    this.drawnItems = new L.FeatureGroup().addTo(this.map)
    this.drawControl = new L.Control.Draw({
      draw: {
        polyline: false,
        polygon: false,
        rectangle: false,
        circle: false,
        circlemarker: false,
      },
      edit: { featureGroup: this.drawnItems },
    }).addTo(this.map)

    this.map.on(L.Draw.Event.CREATED, (e) => this.handleDrawCreated(e))
  }

  handleDrawCreated(e) {
    const layer = e.layer
    const latlng = layer.getLatLng()

    this.setFormValues(latlng, e.name)
    this.clearExistingMarkers()

    this.marker = layer.addTo(this.map)
    if (this.originOrPoiValue) {
      this.colourMarker(this.marker, this.originOrPoiValue)
    }

    this.makeMarkerDraggable()
  }

  addExistingMarker() {
    this.marker = L.marker([this.latValue, this.lngValue], { title: this.nameValue })
      .addTo(this.map)

    if (this.editModeValue) this.makeMarkerDraggable()

    if (this.destLatValue && this.destLngValue) {
      this.destinationMarker = L.marker([this.destLatValue, this.destLngValue], { title: this.destNameValue })
        .addTo(this.map)
      this.colourMarker(this.destinationMarker, "point_of_interest")
      this.colourMarker(this.marker, "origin")
    } else if (this.originOrPoiValue) {
      this.colourMarker(this.marker, this.originOrPoiValue)
    }
  }

  colourMarker(marker, type) {
    if (type === "origin") {
      marker._icon.style.filter = "hue-rotate(250deg)"
    } else if (type === "point_of_interest") {
      marker._icon.style.filter = "hue-rotate(140deg)"
    }
  }

  makeMarkerDraggable() {
    this.marker.dragging?.enable()
    this.marker.on('dragend', (e) => {
      this.setFormValues(e.target.getLatLng())
    })
  }

  setFormValues(latlng, name) {
    document.getElementById(`${this.formPrefixValue}_lat`).value = latlng.lat.toFixed(6)
    document.getElementById(`${this.formPrefixValue}_lng`).value = latlng.lng.toFixed(6)
    if (name) {
      document.getElementById(`${this.formPrefixValue}_name`).value = name
    }
  }

  clearExistingMarkers() {
    if (this.marker) this.map.removeLayer(this.marker)
  }

  disconnect() {
    this.map?.remove()
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}
