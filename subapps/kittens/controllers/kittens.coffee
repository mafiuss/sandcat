'use strict'

Kitten = require '../models/kitten'
_ = require 'lodash'

exports.render = (req, res) ->
  a = 40 + 2
  res.render 'kittens',
    title: 'Kittens landing zone'
    info: 'purrr'

exports.kitten = (req, res, next, id) ->
  Kitten.findOne( _id: id).exec (err, kitten) ->
    if err
       next err
    if !kitten?
      next new Error 'Failed to load kitten ' + id
    req.kitten = kitten
    next()

exports.create = (req, res) ->
  kitten = new Kitten req.body

  kitten.save (err) ->
    if err?
      res.status(500).json error: 'Cannot save the kitten'
    else
      res.json kitten

exports.update = (req, res) ->
  # kitten = req.kitten
  Kitten.findOne( _id: req.params.kittenId).exec (err, kitten) ->
    if err
       new Error err
    if !kitten?
      next new Error 'Failed to load kitten ' + req.params.kittenId

    kitten = _.extend kitten, req.body

    kitten.save (err) ->
      if err?
        res.json 500, error: 'Cannot update the kitten'
      else
        res.json kitten

exports.destroy = (req, res) ->

  Kitten.findOne( _id: req.params.kittenId).exec (err, kitten) ->
    if err
       new Error err
    if !kitten?
      next new Error 'Failed to load kitten ' + req.params.kittenId


    kitten.remove (err) ->
      if err?
        res.json 500, error: 'Cannot delete the kitten'
      else
        res.json kitten

exports.show = (req, res) ->
  Kitten.findOne( _id: req.params.kittenId).exec (err, kitten) ->
    if err
       new Error err
    if !kitten?
      next new Error 'Failed to load site ' + req.params.kittenId

    res.json kitten

exports.all = (req, res) ->
  Kitten.find().sort('-created').exec (err, kittens) ->
    if err?
      res.json 500, error: 'Cannot list the kittens'
    else
      res.json kittens
