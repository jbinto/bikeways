# This file uses the Garber-Irish method for allowing "per-page Javascript."
# I'm using the `gistyle` gem to handle the actual implementation of the pattern.

APP.init = ->
  console.log "application"

APP.init_map = ->
  console.log "APP.init_map"
  kmlUrl = $('#map').data('kml-url')
  handler = Gmaps.build('Google')
  opts =
    # see https://developers.google.com/maps/documentation/javascript/reference?hl=fr#MapOptions
    provider: {
      scrollwheel: false,
      zoom: 16
    }
    internal: { id: 'map' }
  handler.buildMap(opts, ->
    kmls = handler.addKml(
      { url: kmlUrl }
    )
    # handler.bounds.extendWith(markers)
    # handler.fitMapToBounds()
  )

APP.bikeway_segments =
  init: ->
    $ ->
      console.log "bikeway_segments (controller)"

  index: ->
    $ ->
      console.log "enter bikeway_segments#index"
      $('#segments').dataTable
        sDom: 'ilrptf'  # http://www.datatables.net/ref#sDom
        bProcessing: true
        bServerSide: true
        sAjaxSource: $('#segments').data('source')
        bStateSave: true
        bDeferRender: true
      console.log "exit bikeway_segments#index"

  show: ->
    $ ->
      console.log "enter bikeway_segments#show"
      APP.init_map()
      console.log "exit bikeway_segments#show"

APP.bikeways =
  init: ->
    $ ->
      console.log "bikeways (controller)"

  show: ->
    $ ->
      console.log "enter bikeways#show"
      APP.init_map()
      console.log "exit bikeways#show"

  all: ->
    $ ->
      console.log "enter bikeways#show"
      APP.init_map()
      console.log "exit bikeways#show"