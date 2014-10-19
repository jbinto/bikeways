# This file uses the Garber-Irish method for allowing "per-page Javascript."
# I'm using the `gistyle` gem to handle the actual implementation of the pattern.

APP.init = ->
  console.log "application"

APP.segments =
  init: ->
    $ ->
      console.log "segments (controller)"

  index: ->
    $ ->
      console.log "enter segments#index"
      APP._initGoogleMaps()
      APP._initDataTables()
      console.log "exit segments#index"

  show: ->
    $ ->
      console.log "enter segments#show"
      console.log "exit segments#show"

APP._initGoogleMaps = ->
  kmlUrl = $('#map').data('kml-url')
  handler = Gmaps.build('Google')
  opts =
    # see https://developers.google.com/maps/documentation/javascript/reference?hl=fr#MapOptions
    provider: {
      scrollwheel: false,
      zoom: 16,
      mapTypeId: google.maps.MapTypeId.TERRAIN
    }
    internal: { id: 'map' }
  handler.buildMap(opts, ->
    kmls = handler.addKml(
      { url: kmlUrl }
    )
    # handler.bounds.extendWith(markers)
    # handler.fitMapToBounds()
  )

APP._initDataTables = ->
  $('#segments').dataTable
    dom: 'iflrpt'  # http://www.datatables.net/ref#sDom
    processing: true
    serverSide: true
    ajax: $('#segments').data('source')
    stateSave: false
    deferRender: true