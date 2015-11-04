LocalStrategy   = require('passport-local').Strategy
GoogleStrategy = require('passport-google-oauth2').Strategy
GOOGLE_CLIENT_ID = '348855066747-25gomgo6sauhaaiqcf0vef7gopkkau3s.apps.googleusercontent.com'
GOOGLE_CLIENT_SECRET = 't9KUk2I3qEGJ09S1ZOLsbBdB'
userModel = null
module.exports = (passport, model, options) ->
  userModel = model
  MOUNT_PATH = if options.config.mountPath? then options.config.mountPath else ''
  BASEURL = if options.config.baseURL? then options.config.baseURL else 'http://localhost:8001'
  AUTHMODULE = if options.config.authModule? then options.config.authModule else 'auth'
  console.log 'passport configuration', MOUNT_PATH, BASEURL
  passport.serializeUser (user, done) ->
    done(null, user.id)

  passport.deserializeUser (id, done) ->
    userModel.findById id, (err, user) ->
      done err, user


  passport.use 'local', new LocalStrategy
    usernameField: 'email'
    passwordField: 'password'
  , (email, password, done) ->
    userModel.findOne {'local.email': email}, (err, user) ->
      console.log 'hitit'
      return done(err) if err?
      return done(null, false) unless user?
      console.log 'hit it!'
      if user.checkPassword(password)
        tryToLogUserAccess(user, options)
        done null, user
      else
        done null, false

  passport.use new GoogleStrategy
    clientID:     GOOGLE_CLIENT_ID
    clientSecret: GOOGLE_CLIENT_SECRET
    callbackURL: "#{BASEURL}#{MOUNT_PATH}/#{AUTHMODULE}/auth-google/callback"
    passReqToCallback   : true
  , googleResponseHandler

googleResponseHandler = (request, accessToken, refreshToken, profile, done) ->
  doc = {'local.email': profile.email}
  updateGoogleProfile = (u) ->
    if u.google?.id? and u.google.id isnt profile.id
      console.log 'email matched a user profile id not'
      return done(new Error('profile.id missmatch'))
    else
      u.google =
        'id': profile.id
        'token': accessToken

  if securityClearanceOK(profile.email)
    userModel.findOneOrCreate doc, doc, (err, user) ->
      return done(err) if err?
      updateGoogleProfile(user)
      user.save (err, user) ->
        console.log 'saved...'
        return done(err, user)
  else
    return done(new Error('user not passed security clearence check'), null)

  return

securityClearanceOK = (email) ->
  # return on
  users = [
    'the.mafiuss@gmail.com'
    'usohelveticaynoarial@gmail.com'
    'edgar@batanga.com'
    'oolii.mendoz@gmail.com'
  ]
  return users.indexOf(email) isnt -1

tryToLogUserAccess = (user, options) ->
  try
    return if !options.logClass?

    l = new options.logClass()
    l.user = user._id
    l.address = '0.0.0.0'
    l.save()
  catch error
    console.log error
