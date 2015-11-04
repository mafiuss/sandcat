express = require 'express'
coffee = require 'coffee-script'
path = require 'path'
fs = require 'fs'
jadeStatic = require 'connect-jade-static'
async = require 'async'
stylus = require 'stylus'

findFile = (app, request, ext, cb) ->
  try
    found = off
    d = null
    e = []
    p = request.path.substring(0, request.path.lastIndexOf('.'))
    q = async.queue (task, callback) ->
      return callback(msg: 'already-found', null) if found
      console.log 'reading', task
      fs.readFile task, "utf-8", (err, data) ->
        return callback(err) if err?
        found = on
        return callback(null, data)
  catch error
    cb error

  q.drain = ->
    return cb(e, d) unless found
    return cb(null, d)

  for dir in app.get('views')
    continue unless dir.indexOf('elements') isnt -1
    q.push "#{dir}#{p}.#{ext}", (err, data) ->
      return e.push err if err?
      d = data

publicFilePath = (request, options) ->
  try
    p = path.join options.appRootDir, options.dir, request.path
    p = p.substring 0, p.lastIndexOf '.'
    p += ".#{options.ext}"
    return p
  catch error
    console.log error, path
    return ''

module.exports = (app, options, passport) ->
  console.log options.appRootDir
  app.set 'view engine', options.config.viewEngine
  views = [
    path.join(options.appRootDir, options.config.viewsDir),
    path.join(options.appRootDir, 'public/elements')
  ]
  # add parent views visibility when the app is not the rootApp
  if isAmodule(options)
    views.push "#{options.config.rootDir}/public/elements"
  app.set 'views', views

  app.use "/public", express.static(path.join(options.appRootDir, 'public'))
  app.use "/pages", (req, res) ->
    res.render "pages/#{req.path}"

  app.use '/components',
    express.static(path.join(options.config.rootDir, 'bower_components'))
  app.use '/bower_components',
    express.static(path.join(options.config.rootDir, 'bower_components'))

  # dev only middleware
  if app.get('env') is 'development'
    # stylus middleware
    # app.use require('stylus').middleware(path.join(__dirname, 'public'))
    #
    #  COFFEESCRIPT FILES
    #
    app.use "/javascripts", (request, response, next) ->
      coffeeFile = publicFilePath request,
        dir: 'public/javascripts'
        ext: 'coffee'
        appRootDir: options.appRootDir

      file = fs.readFile coffeeFile, "utf-8", (err, data) ->
        return next(err) if err?
        return next() unless data?
        response
          .contentType('text/javascript')
          .send coffee.compile data, bare: on

    #
    #  STYLUS FILES
    #
    stylus = require 'stylus'
    app.use "/stylesheets", (request, response, next) ->
      stylFile = publicFilePath request,
        dir: 'public/stylesheets'
        ext: 'styl'
        appRootDir: options.appRootDir

      file = fs.readFile stylFile, "utf-8", (err, data) ->
        return next(err) if err?

        stylus.render data, {}, (err, css) ->
          return next(err) if err?
          return next() unless data?
          response
            .contentType('text/css')
            .end css

    #
    #  web components with using jade, stylus, coffeescript
    #
    app.use "/elements", (request, response, next) ->
      console.log 'elements request'
      fileType = request.path.substring request.path.lastIndexOf('.') + 1,
        request.path.length
      if fileType is 'js'
        findFile app, request, 'coffee', (err, data) ->
          console.log err if err?
          return next(err) if err?
          response.status(404).end() unless data?
          response
            .contentType('text/javascript')
            .send coffee.compile data, bare: on
      else if fileType is 'html'
        fileName = request.path.substring request.path.lastIndexOf('/') + 1,
          request.path.lastIndexOf('.')
        r = request.path.substring request.path.indexOf('/') + 1, request.path.lastIndexOf('.')
        response.render r, (err, html) ->
          return next(err) if err?
          response.send html
      else if fileType is 'css'
        # return next()
        findFile app, request, 'styl', (err, data) ->
          return next(err) if err?
          # console.log 'data', data
          response.status(404).end() unless data?
          console.log 'non-empty data'
          stylus.render data, { filename: 'nesting.css' }, (err, css) ->
            return next() if err?
            response
              .contentType('text/css')
              .end css
      else
        console.log 'not an element file?'
        next()
  else if app.get('env') is 'production'
    console.log 'setting up production routes'
    app.use "/stylesheets",
      express.static(path.join(options.appRootDir, 'public/stylesheets'))
    app.use "/javascripts",
      express.static(path.join(options.appRootDir, 'public/javascripts'))
    app.use "/elements",
      express.static(path.join(options.appRootDir, 'public/elements'))
    if isAmodule(options)
      app.use "/elements",
        express.static(path.join(options.config.rootDir, 'public/elements'))


  app

isAmodule = (options) ->
  return options.config.rootDir isnt options.appRootDir
