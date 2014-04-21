# This file uses the Garber-Irish method for allowing "per-page Javascript."
# I'm using the `gistyle` gem to handle the actual implementation of the pattern.

APP.init = ->
  console.log "application"

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
      kmlUrl = $('#map').data('kml-url')
      handler = Gmaps.build('Google')
      opts =
        # see https://developers.google.com/maps/documentation/javascript/reference?hl=fr#MapOptions
        provider: {
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
      console.log "exit bikeway_segments#show"
