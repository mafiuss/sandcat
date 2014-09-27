#!/usr/bin/env coffee
debug = require('debug')('feline')
app = require('./app')

app.set 'port', process.env.PORT || 8001

#TODO: db config, maybe create a config/db.coffee?
mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/cat-dev'

server = app.listen app.get('port'), ->
  debug 'Express server listening on port ' + server.address().port
