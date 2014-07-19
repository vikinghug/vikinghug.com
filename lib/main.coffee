io        = require('socket.io')
WebServer = require('./webserver.coffee')
cs        = require('calmsoul')
REPL      = require("repl")
net       = require("net")

webserver = new WebServer()



class Main

  repl: null

  constructor: ->
    cs.set "info", true
    cs.info "\n\n@@Main::constructor ->"

    socketServer = io.listen(webserver.server, {log: true})

    socketServer.on 'connection', (socket) =>
      cs.info " >> <HELLO> "
      socket.emit("HELLO")

      cs.info " << <connection> "

      socket.on 'disconnect', ->
        cs.info 'user left'

      socket.on 'request repos manifest', =>
        cs.info ' << request repos manifest'
        socket.emit('update repos manifest')

      socket.on 'request all repos info', =>
        cs.info ' << request all repos info'
        socket.emit('update all repos', gh.repos)

      gh.on "repos", (payload) =>
        cs.info " << repos "
        socket.emit("repos", payload)

    socketServer.sockets.on "hi", ->
      console.log "HI"

    @createREPL(socketServer)

  createREPL: (socketServer) ->
    connections = 0
    @repl = net.createServer (socket) ->
      connections += 1
      remote = REPL.start
        prompt    : "vikinghug.com::remote> "
        input     : socket
        output    : socket
        terminal  : true
        gh        : gh

      .on 'exit', -> socket.end()
      remote.context.gh = gh
      remote.context.webserver = webserver
      remote.context.socketServer = socketServer
    .listen('5012')



module.exports = new Main()
