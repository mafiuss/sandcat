'use strict'

exports.render = (req, res) ->
  a = 40 + 2
  res.render 'hairball',
    title: 'Express'
    extra: a
