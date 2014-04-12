  # Synthesized from:
# http://railscasts.com/episodes/340-datatables
# http://technpol.wordpress.com/2013/06/10/rails-and-datatables-lazy-loading-and-using-a-single-controller/


jQuery ->
  $('#segments').dataTable
    sDom: 'ilrptf'  # http://www.datatables.net/ref#sDom
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#segments').data('source')
    bStateSave: true
    bDeferRender: true