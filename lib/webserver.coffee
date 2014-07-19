
http    = require('http')
express = require('express')
path    = require('path')
favicon = require('serve-favicon')
fs      = require('fs')
yaml    = require('js-yaml')

basePath      = path.join(__dirname, '..')
generatedPath = path.join(basePath, '.generated')
vendorPath    = path.join(basePath, 'bower_components')
faviconPath   = path.join(basePath, 'app', 'favicon.ico')

class WebServer

  constructor: (github) ->
    @app    = express()
    @server = http.createServer(@app)
    @configureServer()
    @setupRoutes()

    @gh = github
    @gh.getRepos()
    setInterval =>
      @gh.getRepos()
    , 20000

  configureServer: ->
    @app.engine('.html', require('hbs').__express)

    @app.use(favicon(faviconPath))
    @app.use('/assets', express.static(generatedPath))
    @app.use('/vendor', express.static(vendorPath))

    port = process.env.PORT || 3002
    @server.listen(port)

  getDataFile: (file) ->
    try
      filepath = path.join(basePath, 'data', file + '.yaml')
      doc = yaml.safeLoad(fs.readFileSync(filepath, 'utf8'))
    catch err
      console.log(err)

  setupRoutes: ->
    contributors = @getDataFile('contributors')
    screenshots  = @getDataFile('screenshots')

    @app.get '/', (req, res) =>
      res.render(path.join(generatedPath, 'index.html'), {contributors: contributors, screenshots: screenshots, repos: @gh.repos})

    @app.get '/repos', (req, res) =>
      res.render(path.join(generatedPath, 'repos.html'))
    # @app.get /^\/(\w+)(?:\.)?(\w+)?/, (req, res) ->
    #   path = req.params[0]
    #   ext  = req.params[1] ? "html"
    #   res.render(path.join(generatedPath, "#{path}.#{ext}"))

    @app.get '/api/repos', (req, res) -> res.send(gh.repos)




module.exports = WebServer
