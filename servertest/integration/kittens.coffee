request = require 'supertest'
express = require 'express'
app = require '../../app'
mongoose = require 'mongoose'
Kitten = require '../../subapps/kittens/models/kitten'
mongoose.connect 'mongodb://localhost/cat-test'

describe 'kiitens web application', ->
  k1 = null
  k2 = null

  before (done) ->
    k1 = new Kitten(name : 'Nina')
    k2 = new Kitten(name : 'Margarita')
    k1.save (err) ->
      if err? then throw err

      k2.save (err) ->
        if err? then throw err

        done()

  describe 'GET all kittens', ->

    it 'respond with json', (done) ->
      request app
      .get '/cat/kittens/all'
      .set 'Accept', 'application/json'
      .expect 'Content-Type', /json/
      .expect 200, done

  describe 'GET a specific kitten', ->

    it 'respond with json and finds a kitten', (done) ->
      console.log 'kitten 1 ', k1
      request app
      .get "/cat/kittens/#{k1._id}"
      .set 'Accept', 'application/json'
      .expect 'Content-Type', /json/
      .expect 200, done

  after (done) ->
    Kitten.remove name: 'Nina', ->
      Kitten.remove name: 'Margarita', ->
        done()
