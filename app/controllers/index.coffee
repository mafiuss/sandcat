'use strict'

exports.render = (req, res) ->
  console.log 'rendering...'
  u = req.user
  console.log req.user if user?
  return res.render 'index',
    title: 'sandcat'

exports.notfound = (req, res) ->
  return res.render '404',
    message: 'NOT FOUND'
