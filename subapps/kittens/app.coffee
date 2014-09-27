kittenRoutes = require './routes/kittens'

module.exports = (app, config) ->
  kittenRoutes(app, config)
  
  app
