gulp   = require 'gulp'
karma  = require('karma').server
mocha  = require 'gulp-mocha'

gulp.task 'default', () ->
  console.log 'ok'

gulp.task 'karma', ->
  karma.start
    configFile: __dirname + '/test/karma.conf.coffee'
    singleRun: on
  , (exitCode) ->
    console.log "Karma has exited with code #{exitCode}"
    process.exit exitCode

gulp.task 'mocha', ->
  gulp.src './servertest/*/*.coffee', read: off
  .pipe mocha
    reporter: 'nyan'

gulp.task 'test', ['mocha', 'karma'], ->
  console.log 'test completed.'
