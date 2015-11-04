path = require 'path'
index = require '../controllers/index'

module.exports = (app, config, passport) ->
  authModule = if config.authModule? then config.authModule else 'auth'
  authType = config.authentication or 'none'
  landingModule = config.landingModule
  app.route('/')
    .get (req, res, next) ->
      console.log 'base route'
      return next() unless authModule? and authType?
      return next() if authType isnt 'alwaysOn'
      return next() unless authModule.length > 0
      return next() if req.user?
      console.log 'auth enabled'
      res.redirect("#{authModule}/")
    ,(req, res, next) ->
      return next() unless landingModule?
      return next() if landingModule is ''
      console.log 'landing module found lets go there', landingModule
      res.redirect "#{landingModule}/"
    , index.render

  app.route('/logout')
    .all (req, res) ->
      req.logout()
      res.redirect '/'

  app.route '/not-found'
    .get (req, res) ->
      index.notfound req, res

  return app
