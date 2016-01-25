LocalStrategy   = require('passport-local').Strategy
UserModel = null

module.exports = (passport, model, options) ->
  UserModel = model
  MOUNT_PATH = if options.config.mountPath? then options.config.mountPath else ''
  BASEURL = if options.config.baseURL? then options.config.baseURL else 'http://localhost:8001'
  AUTHMODULE = if options.config.authModule? then options.config.authModule else 'auth'
  console.log 'passport configuration', MOUNT_PATH, BASEURL
  passport.serializeUser (user, done) ->
    done(null, user.id)

  passport.deserializeUser (id, done) ->
    UserModel.findById id, (err, user) ->
      done err, user


  passport.use 'local', new LocalStrategy
    usernameField: 'email'
    passwordField: 'password'
  , (email, password, done) ->
    UserModel.findOne('local.email': email).exec().then (user) ->
      throw new Error('user not found') unless user?

      console.log 'checking password for', user.local.email
      if user.checkPassword(password)
        tryToLogUserAccess(user, options)
        done null, user
      else
        done null, false
    .catch (error) ->
      console.log 'error', error
      return done(error) if error?

tryToLogUserAccess = (user, options) ->
  try
    return if !options.logClass?

    l = new options.logClass()
    l.user = user._id
    l.address = '0.0.0.0'
    l.save()
  catch error
    console.log error
