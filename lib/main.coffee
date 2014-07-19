io        = require('socket.io')
Github    = require('./github.coffee')
WebServer = require('./webserver.coffee')
cs        = require('calmsoul')

gh        = new Github("vikinghug")
webserver = new WebServer(gh)

class Main

  constructor: ->
    cs.set "info", false
    cs.info "\n\n@@Main::constructor ->"

    socketServer = io.listen(webserver.server, {log: true})

    socketServer.sockets.on 'connection', (socket) =>
      cs.info " >> <HELLO> "
      socket.emit("HELLO")

      cs.info " << <connection> "

      socket.on 'all repos please', => socket.emit('update all repos', gh.repos)

      gh.on "repos", (payload) => socket.emit("repos", payload)



module.exports = new Main()
