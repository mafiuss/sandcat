'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema

AccessLogSchema = new Schema
  created:
    type: Date
    'default': Date.now
  updated:
    type: Date
    'default': Date.now
  address: String

  user:
    type: Schema.Types.ObjectId, ref: 'User'

# AccessLogSchema.path('name').validate (name) ->
#   !!name;
# , 'Name cannot be blank'
module.exports = mongoose.model('AccessLog', AccessLogSchema)
