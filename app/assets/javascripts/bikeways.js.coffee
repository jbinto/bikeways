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
      handler = Gmaps.build('Google')
      opts =
        provider: {}
        internal: { id: 'map' }
      handler.buildMap(opts, ->
        markers = handler.addMarkers([
          lat: 0
          lng: 0
          picture:
            url: "http://placekitten.com/36/36"
            width: 36
            height: 36
          ,
          infowindow: "hello!"
        ])
        handler.bounds.extendWith(markers)
        handler.fitMapToBounds()
      )
      console.log "exit bikeway_segments#show"
