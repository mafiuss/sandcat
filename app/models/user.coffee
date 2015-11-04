'use strict'
bcrypt = require 'bcryptjs'
mongoose = require 'mongoose'
Schema = mongoose.Schema

UserSchema = new Schema
  created:
    type: Date
    'default': Date.now
  updated:
    type: Date
    'default': Date.now
  info:
    first: String
    last: String
    bday:
      type: Date
      'default': Date.now
    foto: String
  local:
    email:
      type: String
      unique: on
    password: String
  facebook:
    id: String
    token: String
    email: String
    name: String
  twitter:
    id: String
    token: String
    displayName: String
    username: String
  google:
    id: String
    token: String
    email: String
    name: String
  disqus:
    id: String
    token: String
    email: String
    name: String
  roles: [String]
  verified:
    type: Boolean
    'default': off
  enabled:
    type: Boolean
    'default': 1

# UserSchema.path('name').validate (name) ->
#   !!name;
# , 'Name cannot be blank'
UserSchema.methods.checkPassword = (password) ->
  bcrypt.compareSync password, @local.password

UserSchema.methods.hasRole = (rolename) ->
  return off unless rolename?
  @roles.indexOf(rolename) isnt -1

UserSchema.methods.isAdmin = ->
  if @roles.indexOf('admin') is -1 then off else on

UserSchema.methods.isClient = ->
  if @roles.indexOf('client') is -1 then off else on

UserSchema.methods.changePassword = (password) ->
  console.log 'changing password', @local.email
  @local.password = generateHash password
  @save()

UserSchema.statics.isPasswordStrongEnough = (password) ->
  return off unless password?
  regularExpression =
    /^(?=.*[0-9])(?=.*[!@#$%^&*\.])[a-zA-Z0-9!@#$%^&*\.]{10,30}$/
  veredict = regularExpression.test password
  return veredict

UserSchema.statics.generateHash = generateHash = (password) ->
  bcrypt.hashSync password, bcrypt.genSaltSync(10)

UserSchema.statics.findOneOrCreate = (criteria, document, callback)->
  @findOne criteria, (err, user) =>
    return callback err if err?

    return callback err, user if user?

    @create document, (err2, newuser) ->
      callback err2, newuser



module.exports = mongoose.model('User', UserSchema)
