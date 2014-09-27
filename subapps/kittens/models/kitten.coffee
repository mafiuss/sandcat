'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema

KittenSchema = new Schema
  created:
    type: Date
    'default': Date.now
  updated:
    type: Date
    'default': Date.now
  name:
    type: String
    required: true
    trim: true

KittenSchema.path('name').validate (name) ->
  !!name;
, 'Name cannot be blank'

module.exports = mongoose.model('Kitten', KittenSchema)
