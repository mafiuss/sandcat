gulp   = require 'gulp'
$      = require('gulp-load-plugins')()
karma  = require('karma').server
mocha  = require 'gulp-mocha'
gutil  = require 'gulp-util'
CSON   = require 'season'
path   = require 'path'
del    = require 'del'
# jade   = require 'gulp-jade'
runSeq = require 'run-sequence'
debug  = require 'gulp-debug'
symlink = require 'gulp-symlink'

sandcatConfig = CSON.readFileSync path.join(__dirname ,'config.cson')
console.log $
gulp.task 'default', () ->
  gutil.log 'ok'

gulp.task 'karma', ->
  karma.start
    configFile: __dirname + '/test/karma.conf.coffee'
    singleRun: on
  , (exitCode) ->
    gutil.log "Karma has exited with code #{exitCode}"
    process.exit exitCode

gulp.task 'mocha', ->
  gulp.src './servertest/**/*.coffee', read: off
    .pipe mocha
      reporter: 'nyan'

gulp.task 'test', ['mocha', 'karma'], ->
  gutil.log 'test completed.'

gulp.task 'styles', ->
  gutil.log 'styles.'
  gulp.src ['public/stylesheets/**/*.styl']
    .pipe $.stylus(compress: on)
    .pipe gulp.dest 'dist/public/stylesheets'

  gulp.src [
    "#{sandcatConfig.subappsDir}/*/public/stylesheets/**/*.styl"]
    .pipe $.stylus(compress: on)
    .pipe gulp.dest "dist/#{sandcatConfig.subappsDir}"

gulp.task 'clean', del.bind null, ['.tmp', 'dist']

gulp.task 'coffee', ->
  gulp.src [
    '*.coffee'
    '!gulpfile.coffee']
  .pipe $.coffee(bare: on).on('error', gutil.log)
  .pipe gulp.dest 'dist'


  gulp.src "app/**/*.coffee"
    .pipe $.coffee(bare: on).on('error', gutil.log)
    .pipe gulp.dest 'dist/app'

  gulp.src "config/**/*.coffee"
    .pipe $.coffee(bare: on).on('error', gutil.log)
    .pipe gulp.dest 'dist/config'

  gulp.src ['public/javascripts/**/*.coffee']
    .pipe $.coffee(bare: on).on('error', gutil.log)
    .pipe $.uglify()
    .pipe gulp.dest 'dist/public/javascripts'

  if sandcatConfig.subappsDir?
    gulp.src [
      "#{sandcatConfig.subappsDir}/*/public/javascripts/**/*.coffee"]
    .pipe $.coffee(bare: on).on('error', gutil.log)
    .pipe $.uglify()
    .pipe gulp.dest "dist/#{sandcatConfig.subappsDir}"

    gulp.src [
      "#{sandcatConfig.subappsDir}/*/app/**/*.coffee"
      "#{sandcatConfig.subappsDir}/*/app.coffee"]
    .pipe $.coffee(bare: on).on('error', gutil.log)
    .pipe gulp.dest "dist/#{sandcatConfig.subappsDir}"


gulp.task 'images', ->
  gutil.log 'images.'
  gulp.src ['public/images/**/*']
    .pipe $.imagemin
      progressive: on
      interlaced: on
    .pipe gulp.dest 'dist/public/images'

  gulp.src [
    "#{sandcatConfig.subappsDir}/*/public/images/**/*"]
    .pipe $.imagemin
      progressive: on
      interlaced: on
    .pipe gulp.dest "dist/#{sandcatConfig.subappsDir}/"

gulp.task 'copy', ->
  gulp.src path.join(__dirname, 'config.cson')
    .pipe gulp.dest 'dist'
  gulp.src ["#{sandcatConfig.subappsDir}/*/app/models/config.cson"]
    .pipe gulp.dest "dist/#{sandcatConfig.subappsDir}/"
  gulp.src ["#{sandcatConfig.viewsDir}/**/*.jade"]
    .pipe $.replace('components/webcomponentsjs/webcomponents.js',
      'components/webcomponentsjs/webcomponents.min.js')
    .pipe gulp.dest "dist/#{sandcatConfig.viewsDir}"
  gulp.src ["#{sandcatConfig.subappsDir}/*/#{sandcatConfig.viewsDir}/**/*.jade"]
    .pipe $.replace('components/webcomponentsjs/webcomponents.js',
      'components/webcomponentsjs/webcomponents.min.js')
    .pipe gulp.dest "dist/#{sandcatConfig.subappsDir}"
  gulp.src ['bower_components']
    .pipe symlink('.tmp/components')
    .pipe symlink('.tmp/public/components')
  gulp.src ['bower_components/**/*']
    .pipe gulp.dest 'dist/bower_components'

# gulp.task 'views', ->
#   gutil.log 'burps!'
#   gulp.src ["#{sandcatConfig.viewsDir}/**/*.jade"]
#     .pipe $.jade()
#     .pipe gulp.dest 'dist/public'
renameElementsPathx = (path) ->
  return path unless path.dirname?
  s = path.dirname.split '/'
  # i'll regret this magic number 2? FIXME
  return path unless s.length >= 2

  path.dirname = "#{s[s.length - 1]}/#{s[s.length - 2]}"
  path

renameElementsPath = (path) ->
  return path unless path.dirname?
  # gutil.log path
  path.dirname = path.dirname.substring path.dirname.lastIndexOf('/'),
    path.dirname.length
  path

gulp.task 'webcomponentsjs', ->
  gulp.src ["public/elements/**/*.coffee"]
    .pipe $.coffee(bare: on).on('error', gutil.log)
    .pipe gulp.dest '.tmp/public/elements'

  if sandcatConfig.subappsDir?
    gulp.src [
      "#{sandcatConfig.subappsDir}/**/*.coffee"
      "!#{sandcatConfig.subappsDir}/*/app.coffee"
      "!#{sandcatConfig.subappsDir}/*/app/**/*.coffee"
      "!#{sandcatConfig.subappsDir}/*/public/javascripts/**/*.coffee"
    ]
    # .pipe debug title: 'before'
    .pipe $.rename renameElementsPath
    # .pipe debug title: 'after rename'
    .pipe $.coffee(bare: on).on('error', gutil.log)
    .pipe gulp.dest ".tmp/public/elements"

gulp.task 'webcomponentscss', ->
  gulp.src ['public/elements/**/*.styl']
    .pipe $.stylus()
    .pipe gulp.dest '.tmp/public/elements'

  gulp.src [
    "#{sandcatConfig.subappsDir}/**/*.styl"
    "!*/#{sandcatConfig.viewsDir}"
    "!*/#{sandcatConfig.subappsDir}/*/public/stylesheets/**/*.styl"
  ]
  .pipe $.stylus()
  .pipe $.rename renameElementsPath
  .pipe gulp.dest ".tmp/public/elements"

gulp.task 'webcomponentshtml', ->
  gulp.src ['public/elements/**/*.jade']
    .pipe $.jade()
    .pipe gulp.dest '.tmp/public/elements'

  gulp.src [
    "#{sandcatConfig.subappsDir}/**/*.jade"
    "!#{sandcatConfig.subappsDir}/**/*-elements.jade"
    "!#{sandcatConfig.subappsDir}/*/app/**/*.jade"
  ]
  # .pipe debug title: 'after select html'
  .pipe $.jade()
  .pipe $.rename renameElementsPath
  .pipe gulp.dest ".tmp/public/elements"

  gulp.src [
    "#{sandcatConfig.subappsDir}/**/*-elements.jade"
  ]
  .pipe $.jade()
  # .pipe debug title: 'before path rename'
  .pipe $.rename (path) ->
    path.dirname = ''
  # .pipe debug title: 'after path rename'
  .pipe gulp.dest ".tmp/public/elements"

gulp.task 'vulcanize', ->
  gulp.src [".tmp/public/elements/**/*-elements.html"]
  .pipe debug title: 'after src'
  .pipe $.vulcanize(
    dest: 'dist/public/elements'
    stripComments: on
    inlineScripts: on
    inlineCss: on).on('error', gutil.log)
  .pipe debug title: 'after vulcanize'
  .pipe gulp.dest "dist/public/elements"


gulp.task 'build', ['clean'], (cb)->
  runSeq 'copy', 'images', ['coffee', 'styles'],
    'webcomponentsjs', 'webcomponentshtml', 'webcomponentscss', 'vulcanize', cb
