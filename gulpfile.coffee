gulp = require 'gulp'
$ = (require 'gulp-load-plugins')()
nib = require 'nib'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
coffeeify = require 'coffee-reactify'
watchify = require 'watchify'
envify = require 'envify/custom'
path = require 'path'
gutil = require 'gulp-util'
prettyTime = require 'pretty-hrtime'
express = require 'express'
serveStatic = require 'serve-static'
fs = require 'fs'

errorHandler = (err) ->
  gutil.beep()
  console.error err
  @emit 'end'

runBrowserify = (file, watch) ->
  b = browserify
    basedir: path.resolve './coffee'
    debug: watch
    cache: {}
    packageCache: {}
    fullPaths: watch
    extensions: ['.coffee', '.cjsx']
    entries: file
  .transform coffeeify
  .transform envify
    NODE_ENV: if watch then 'dev' else 'prod'

  bundle = ->
    extname = path.extname file
    name = path.basename(file, extname) + '.js'
    start = process.hrtime()
    success = true

    b.bundle()
      .on 'error', (err) ->
        success = false
        errorHandler.call @, err.message
      .pipe source name
      .pipe gulp.dest 'public/js'
      .on 'end', ->
        return unless success
        end = process.hrtime start
        gutil.log "Generated '#{gutil.colors.cyan name}' in #{gutil.colors.magenta prettyTime end}"

  if watch
    b = watchify b

    b.on 'update', (files) ->
      log = ''

      for i, name of files
        log += ', ' if i > 0
        log += "'#{gutil.colors.cyan name.substring __dirname.length + 1}'"

      gutil.log "#{log} was updated"
      bundle()

  bundle()

gulp.task 'stylus', ->
  gulp.src 'styl/**/*.styl'
    .pipe $.ignore.exclude /[\/\\]_/
    .pipe $.stylus
      use: [nib()]
      import: [
        'nib'
        path.resolve './styl/_variables.styl'
        path.resolve './styl/_mixin.styl'
      ]
      'include css': true
    .on 'error', errorHandler
    .pipe gulp.dest 'public/css'

gulp.task 'stylus:watch', ->
  gulp.watch 'styl/**/*.styl', ['stylus']

gulp.task 'stylus:clean', ->
  gulp.src 'public/css/**/*.css', read: false
    .pipe $.rimraf()

gulp.task 'browserify:app', ->
  runBrowserify './app.coffee', false

gulp.task 'browserify:app:watch', ->
  runBrowserify './app.coffee', true

gulp.task 'browserify:app:clean', ->
  gulp.src 'public/js/app.js', read: false
    .pipe $.rimraf()

gulp.task 'browserify:home', ->
  runBrowserify './home.coffee', false

gulp.task 'browserify:home:watch', ->
  runBrowserify './home.coffee', true

gulp.task 'browserify:home:clean', ->
  gulp.src 'public/js/home.js', read: false
    .pipe $.rimraf()

gulp.task 'browserify', ['browserify:app', 'browserify:home']
gulp.task 'browserify:watch', ['browserify:app:watch', 'browserify:home:watch']
gulp.task 'browserify:clean', ['browserify:app:clean', 'browserify:home:clean']

gulp.task 'fontawesome', ->
  gulp.src 'bower_components/font-awesome/fonts/*'
    .pipe gulp.dest 'public/fonts'

gulp.task 'fontawesome:clean', ->
  gulp.src 'public/fonts/*', read: false
    .pipe $.rimraf()

renderView = (name) ->
  (req, res, next) ->
    stream = fs.createReadStream path.resolve "./views/#{name}.html"
    stream.pipe res

gulp.task 'server', ->
  app = express()
  port = 4000

  app.get '/', renderView 'index'
  app.get '/login', renderView 'app'
  app.get '/signup', renderView 'app'
  app.get '/password-reset', renderView 'app'
  app.get '/app', renderView 'app'
  app.use serveStatic path.resolve './public'

  app.listen port
  gutil.log "Server is listening on '#{gutil.colors.cyan 'http://localhost:' + port}'"

gulp.task 'watch', ['browserify:watch', 'stylus:watch', 'server']

gulp.task 'build', ['browserify', 'stylus'], ->
  assets = $.useref.assets
    searchPath: 'public'

  gulp.src 'views/*.html'
    .pipe assets
    .pipe $.if '*.js', $.uglify()
    .pipe $.if '*.css', $.autoprefixer
      browsers: ['last 2 versions']
      cascade: false
    .pipe $.if '*.css', $.minifyCss()
    .pipe $.rev()
    .pipe assets.restore()
    .pipe $.useref()
    .pipe $.revReplace()
    .pipe $.if '*.html', $.htmlmin
      removeComments: true
      collapseWhitespace: true
      removeOptionalTags: true
      removeRedundantAttributes: true
      collapseBooleanAttributes: true
    .pipe gulp.dest 'build'
    .pipe $.rev.manifest()
    .pipe gulp.dest 'build'

gulp.task 'clean', ['stylus:clean', 'browserify:clean', 'fontawesome:clean'], ->
  gulp.src 'build/**/*', read: false
    .pipe $.rimraf()

gulp.task 'default', [ 'build' ]