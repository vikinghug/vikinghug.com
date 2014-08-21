fs           = require('fs')
xml2js       = require('xml2js')
EventEmitter = require('events').EventEmitter

parser  = new xml2js.Parser()
fs.readFile 'data/toc.xml', (err, data) ->
  parser.parseString data, (err, result) ->
    console.log "toc.xml contents: "
    console.dir result
    console.log "\nVersion: ", result.Addon.$.Version
    console.log 'Done.'

class VersionManager extends EventEmitter
  constructor: ->

module.exports = VersionManager