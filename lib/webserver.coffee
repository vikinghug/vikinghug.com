
http    = require('http')
express = require('express')
path    = require('path')
favicon = require('serve-favicon')
fs      = require('fs')
yaml    = require('js-yaml')


app           = express()
webserver     = http.createServer(app)
basePath      = path.join(__dirname, '..')
generatedPath = path.join(basePath, '.generated')
vendorPath    = path.join(basePath, 'bower_components')
faviconPath   = path.join(basePath, 'app', 'favicon.ico')

app.engine('.html', require('hbs').__express)

app.use(favicon(faviconPath))
app.use('/assets', express.static(generatedPath))
app.use('/vendor', express.static(vendorPath))

port = process.env.PORT || 3002
webserver.listen(port)

Github = require('./github.coffee')
gh = new Github("vikinghug")
gh.getRepos()
setInterval ->
  gh.getRepos()
, 20000

getDataFile = (file) ->
  try
    filepath = path.join(basePath, 'data', file + '.yaml')
    doc = yaml.safeLoad(fs.readFileSync(filepath, 'utf8'))
  catch err
    console.log(err)

contributors = getDataFile('contributors')
screenshots  = getDataFile('screenshots')

app.get '/', (req, res) ->
  res.render(path.join(generatedPath, 'index.html'), {contributors: contributors, screenshots: screenshots, repos: gh.repos})
app.get /^\/(\w+)(?:\.)?(\w+)?/, (req, res) ->
  path = req.params[0]
  ext  = req.params[1] ? "html"
  res.render(path.join(basePath, ".generated", "#{path}.#{ext}"))

app.get '/api/repos', (req, res) ->




module.exports = webserver
