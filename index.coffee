#!/usr/bin/env coffee
debug = require('debug')('feline')
app = require('./app')

path = require 'path'
CSON = require 'season'
CONFIG = CSON.readFileSync path.join(__dirname ,'config.cson')

console.log "Mode: #{app.get('env')}"
app.set 'port', process.env.PORT || 8001
app.set 'hostname', process.env.HOSTNAME || 'localhost'

#TODO: db config, maybe create a config/db.coffee?
mongoose = require 'mongoose'
mongoose.Promise = require 'bluebird'
mongoose.connect "mongodb://localhost/#{CONFIG.dbname}-#{app.get('env')}"

server = app.listen app.get('port'), app.get('hostname'), ->
  console.log 'Express server listening on port ' + server.address().port
