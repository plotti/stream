@SongPoller =
  poll: ->
    setTimeout @request, 2000

  request: ->
    $.get($('#current_song').data('url'))

jQuery ->
  if $('#current_song').length > 0
    SongPoller.poll()