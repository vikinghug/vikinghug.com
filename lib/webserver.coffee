
express = require('express')
favicon = require('serve-favicon')
fs      = require('fs')
http    = require('http')
path    = require('path')
request = require('superagent')
yaml    = require('js-yaml')

basePath      = path.join(__dirname, '..')
generatedPath = path.join(basePath, '.generated')
vendorPath    = path.join(basePath, 'bower_components')
faviconPath   = path.join(basePath, 'app', 'favicon.ico')

class WebServer

  repos: null

  constructor: ->
    @app    = express()
    @server = http.createServer(@app)
    @configureServer()
    @setupRoutes()

    @getRepos()
    setInterval =>
      @getRepos()
    , 1000

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

  getRepos: ->
    self = this
    request
    .get('http://api.vikinghug.com/repos')
    .end (res) => self.repos = res.body

  setupRoutes: ->
    contributors = @getDataFile('contributors')
    screenshots  = @getDataFile('screenshots')

    @app.get '/', (req, res) =>
      res.render(path.join(generatedPath, 'index.html'), {contributors: contributors, screenshots: screenshots, repos: @repos})

    @app.get '/repos', (req, res) =>
      res.render(path.join(generatedPath, 'repos.html'))

    @app.get '/api/repos', (req, res) => res.send(@repos)




module.exports = new WebServer()
