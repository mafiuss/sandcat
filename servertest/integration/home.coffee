request = require 'supertest'
express = require 'express'

app = require('../../app');

describe 'GET /cat', ->
  it 'responds with 303 when called without the trailing /', (done) ->
    request app
    .get '/cat'
    .expect 303, done

describe 'GET /cat/', ->
  it 'responds to to /cat/ with 200', (done) ->
    request app
    .get '/cat/'
    .expect 200, done
