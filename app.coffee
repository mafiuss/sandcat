coffee = require 'coffee-script'
express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
CSON = require 'season'
session = require 'express-session'
passport = require 'passport'
compression = require 'compression'
fs = require 'fs'

configurator = require './config/configurator'

CONFIG = CSON.readFileSync path.join(__dirname ,'config.cson')
CONFIG.rootDir = __dirname
console.log CONFIG
#
# DEFAULT VALUES
# kind of constant globals
CONFIG.defaultAppDir = 'app'

app = express()

app.set 'strict routing', on
# view engine setup
# we set views at this level so we can call res.render
app.set 'view engine', CONFIG.viewEngine
app.set 'views', path.join(__dirname, CONFIG.viewsDir)

# pluginable modules
# subapps = ['kittens']

# uncomment after placing your favicon in /public
# app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: on)
app.use cookieParser()
app.use compression()
# AUTH
# passport configuration
# required for passport
#
app.use session
  secret: 'meow!purr'
  resave: off
  saveUninitialized: off

app.use passport.initialize()
app.use passport.session()

userModel = require './app/models/user'
logModel = require './app/models/accessLog'
require('./config/passport')(passport, userModel, {logClass: logModel, config:CONFIG})

# context path / mount path
# helper to define the correct base url based on mountPath
if !String::startsWith
  String::startsWith = (searchString, position) ->
    position = position or 0
    @indexOf(searchString, position) == position

if !String::endsWith
  String::endsWith = (searchString, position) ->
    subjectString = @toString()
    if typeof position != 'number' or !isFinite(position) or Math.floor(position) != position or position > subjectString.length
      position = subjectString.length
    position -= searchString.length
    lastIndex = subjectString.indexOf(searchString, position)
    lastIndex != -1 and lastIndex == position

routePath = (fragment) ->
  mountPath = CONFIG.mountPath or '/'
  return fragment if mountPath is '/'

  if mountPath.endswith('/') and fragment.startsWith('/')
    fragment = fragment.substring 1, fragment.length

  return "#{mountPath}#{fragment}"

# config setting that defaults to '/cat'
base = CONFIG.mountPath or '/'
console.log 'mountPath', base
# since we have a mount path we redirect all request to http://example.com/
# to http://example.com/base
if base? and base isnt '' and base isnt '/'
  app.route('/').get (req, res) ->
    res.redirect "#{base}/"

baseApp = require('./app/routes/routes')(express(), CONFIG, passport)
configurator baseApp,
  config: CONFIG
  appRootDir: path.join(__dirname, '')

app.use "#{base}", baseApp

# service worker special route
app.use routePath('/sw-import'), (req, res) ->
  try
    p = path.join __dirname, 'public/javascripts/sw-import'
    if app.get('env') is 'production'
      p += ".js"
    else
      p += ".coffee"

    scriptContents = fs.readFile p, "utf-8", (err, data) ->
      return next(err) if err?
      return next() unless data?

      if app.get('env') is 'development'
        scriptContents = coffee.compile data, bare: on

      res
        .contentType('text/javascript')
        .send scriptContents

  catch error
    console.log error, path
    return ''

app.use routePath('/partials'), (req, res) ->
  res.render "partials/#{req.path}"

## bower_components route and uploads dir configuration
app.use routePath("/#{CONFIG.uploadsDir}"),
  express.static(path.join(__dirname, CONFIG.uploadsDir))

#
# subapps configuration
#
for subapp in CONFIG.subapps
  console.log "config: #{subapp}"
  initializer = require path.join(__dirname,
    CONFIG.subappsDir, subapp,CONFIG.defaultAppDir)
  subModule = null
  CONFIG.subappName = subapp
  if CONFIG.authModule? and (CONFIG.authModule.indexOf(subapp) isnt -1)
    console.log 'auth setup', subapp
    subModule = initializer(express(), CONFIG, passport)
  else
    subModule = initializer(express(), CONFIG)

  app.use routePath("/#{subapp}"), subModule

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  console.log 'not found', req.path
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

module.exports = app
