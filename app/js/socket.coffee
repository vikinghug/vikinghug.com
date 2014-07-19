socket = io.connect "http://" + window.location.host
socket.emit 'HANDSHAKE'

socket.on 'HELLO', ->
  socket.emit 'all repos please'

socket.on 'all repos', (data) ->
  console.log data

socket.on "update", (data) ->
  console.log "hello", data