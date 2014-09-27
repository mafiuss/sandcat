coffee = require 'coffee-script'
express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
CSON = require 'season'

CONFIG = CSON.readFileSync path.join(__dirname ,'config.cson')
console.log CONFIG

routes = require './app/routes/index'
users = require './app/routes/users'

kittensApp = require(path.join(__dirname, CONFIG.subappsDir, CONFIG.subapps[0], 'app'))(express(), CONFIG)

app = express()

# view engine setup
app.set 'views', path.join(__dirname, CONFIG.viewsDir)
app.set 'view engine', CONFIG.viewEngine

# pluginable modules
# subapps = ['kittens']

# uncomment after placing your favicon in /public
# app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use require('stylus').middleware(path.join(__dirname, 'public'))

# context path

base = CONFIG.mountPath

# dev only middleware
if app.get('env') is 'development'
  app.use "#{base}", express.static(path.join(__dirname, 'bower_components'))

  # the following will try to find the coffeescript file that matches file.js
  # compile it and serve the js result on the fly
  app.use "#{base}/javascripts", (request, response, next) ->
    coffeeFile = path.join __dirname, "/clientapp", request.path
    coffeeFile = coffeeFile.substring(0, coffeeFile.lastIndexOf('.'))
    coffeeFile += '.coffee'
    fs = require 'fs'
    file = fs.readFile coffeeFile, "utf-8", (err, data) ->
      return next() if err?
      response
        .contentType('text/javascript')
        .send coffee.compile data, bare: on

# routers and static assets
app.use "#{base}/", routes
app.use "#{base}/users", users

# pluginable app
app.use "#{base}/kittens", kittensApp
app.use "#{base}", express.static(path.join(__dirname, 'public'))
# the following enables serving view files
# which allows client code routers to find partials
app.use "#{base}/partials", (req, res) ->
  res.render "partials/#{req.path}"

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next err

#error handlers
#development error handler
# will print stacktrace
if app.get('env') is 'development'
    app.use (err, req, res, next) ->
        res.status err.status || 500
        res.render 'error',
            message: err.message
            error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    res.status err.status || 500
    res.render 'error',
        message: err.message
        error: {}

module.exports = app;
