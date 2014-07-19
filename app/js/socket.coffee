socket = io.connect "http://" + window.location.host
socket.emit 'HANDSHAKE'

socket.on 'HELLO', ->
  socket.emit 'request all repos'

socket.on 'update repos manifest', (data) ->
  console.log 'update repos manifest', data

socket.on 'update all repos', (data) ->
  console.log 'update all repos', data

socket.on "update repo", (data) ->
  console.log "hello", data