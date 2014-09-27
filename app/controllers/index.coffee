'use strict'

exports.render = (req, res) ->
  a = 40 + 2
  res.render 'index',
    title: 'Mean Cat'
    extra: a
