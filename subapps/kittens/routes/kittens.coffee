'use strict'

kittens = require '../controllers/kittens'

module.exports = (app, config) ->
  app.route '/'
  .get kittens.render
  .post kittens.create

  app.route '/all'
  .get kittens.all

  app.route '/:kittenId'
  .delete kittens.destroy
  .get kittens.show
  .put kittens.update

  app
# express = require('express')
# router = express.Router()
#
# kittens = require('../controllers/kittens');
#
# router.get '/', (req, res) ->
#   kittens.render req, res
#
# router.post '/', (req, res) ->
#   kittens.create req, res
#
# router.get '/all', (req, res) ->
#   kittens.all req, res
#
# #
# # FIXME: figure out a way to use the app.param() API
# # see kittens.kitten
# #
# router.delete '/:kittenId', (req, res) ->
#   kittens.destroy req, res, req.params.kittenId
#
# router.get '/:kittenId', (req, res) ->
#   kittens.show req, res, req.params.kittenId
#
# router.put '/:kittenId', (req, res) ->
#   kittens.update req, res, req.params.kittenId
# # it would be cool to be able to use the
# # x.route '/:kittenId', (req, res) ->
# #   .get kittens.show
# #   .put kittens.create
# #   .delete kittens.destroy
#
# module.exports = router
