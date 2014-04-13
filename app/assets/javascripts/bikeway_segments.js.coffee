# # Synthesized from:
# # http://railscasts.com/episodes/340-datatables
# # http://technpol.wordpress.com/2013/06/10/rails-and-datatables-lazy-loading-and-using-a-single-controller/


# jQuery ->
#   $('#segments').dataTable
#     sDom: 'ilrptf'  # http://www.datatables.net/ref#sDom
#     bProcessing: true
#     bServerSide: true
#     sAjaxSource: $('#segments').data('source')
#     bStateSave: true
#     bDeferRender: true

#   # XXX: complains about undefined google if we're not on the right page
#   # Need to organize JS better.

#   handler = Gmaps.build('Google')
#   opts =
#     provider: {}
#     internal: { id: 'map' }
#   handler.buildMap(opts, ->
#     markers = handler.addMarkers([
#       lat: 0
#       lng: 0
#       picture:
#         url: "http://placekitten.com/36/36"
#         width: 36
#         height: 36
#       ,
#       infowindow: "hello!"
#     ])
#     handler.bounds.extendWith(markers)
#     handler.fitMapToBounds()
#   )