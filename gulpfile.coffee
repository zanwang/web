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
cons = require 'consolidate'
fs = require 'fs'
yaml = require 'js-yaml'
_ = require 'lodash'
merge = require 'merge-stream'
moment = require 'moment'
del = require 'del'

assets = yaml.safeLoad fs.readFileSync(path.resolve('./assets.yml'), 'utf8')

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

gulp.task 'stylus:clean', (callback) ->
  del 'public/css/**/*.css', callback

gulp.task 'browserify:app', ->
  runBrowserify './app.coffee', false

gulp.task 'browserify:app:watch', ->
  runBrowserify './app.coffee', true

gulp.task 'browserify:app:clean', (callback) ->
  del 'public/js/app.js', callback

gulp.task 'browserify:home', ->
  runBrowserify './home.coffee', false

gulp.task 'browserify:home:watch', ->
  runBrowserify './home.coffee', true

gulp.task 'browserify:home:clean', (callback) ->
  del 'public/js/home.js', callback

gulp.task 'browserify', ['browserify:app', 'browserify:home']
gulp.task 'browserify:watch', ['browserify:app:watch', 'browserify:home:watch']
gulp.task 'browserify:clean', ['browserify:app:clean', 'browserify:home:clean']

assetHelperBase = (type, name) ->
  dest = "/#{type}/#{name}.#{type}"
  result = ''

  result += "\n<!-- build:#{type} #{dest} -->"

  for item in assets[type][name]
    result += "\n"
    extname = path.extname item
    item += '.' + type unless extname

    switch type
      when 'css'
        result += "<link rel=\"stylesheet\" href=\"/css/#{item}\">"
      when 'js'
        result += "<script src=\"/js/#{item}\"></script>"

  result += "\n<!-- endbuild -->"

  result

assetHelpers =
  css: assetHelperBase.bind @, 'css'
  js: assetHelperBase.bind @, 'js'

renderView = (name) ->
  (req, res, next) ->
    res.render name, assetHelpers, (err, html) ->
      return next err if err
      res.end html

gulp.task 'server', ->
  app = express()
  port = 4000

  app.engine 'html', cons.lodash
  app.set 'view engine', 'html'
  app.set 'views', path.resolve './views'

  app.get '/', renderView 'index'
  app.get '/login', renderView 'app'
  app.get '/signup', renderView 'app'
  app.get '/password-reset', renderView 'app'
  app.get '/users/:user_id/passwords/reset/:token', renderView 'password_reset'
  app.get '/app', renderView 'app'
  app.get '/app/settings', renderView 'app'
  app.get '/app/domains/:id', renderView 'app'
  app.get '/error/404', renderView 'error/404'
  app.get '/error/500', renderView 'error/500'

  app.use '/fonts', serveStatic path.resolve './bower_components/font-awesome/fonts'
  app.use serveStatic path.resolve './public'

  app.listen port
  gutil.log "Server is listening on '#{gutil.colors.cyan 'http://localhost:' + port}'"

gulp.task 'watch', ['browserify:watch', 'stylus:watch', 'server']

gulp.task 'minify', ['browserify', 'stylus'], ->
  assetsRef = $.useref.assets
    searchPath: 'public'

  gulp.src 'views/**/*.html'
    .pipe $.template assetHelpers
    .pipe assetsRef
    .pipe $.if '*.js', $.uglify()
    .pipe $.if '*.css', $.autoprefixer
      browsers: ['last 2 versions']
      cascade: false
    .pipe $.if '*.css', $.minifyCss()
    .pipe $.rev()
    .pipe assetsRef.restore()
    .pipe $.useref()
    .pipe $.revReplace()
    .pipe $.if '*.html', $.htmlmin
      removeComments: true
      collapseWhitespace: true
      removeOptionalTags: true
      removeRedundantAttributes: true
      collapseBooleanAttributes: true
    .pipe $.if '*.html', $.rename (path) ->
      path.dirname = 'views/' + path.dirname
      path
    .pipe gulp.dest 'build'
    .pipe $.rev.manifest()
    .pipe gulp.dest 'build'

gulp.task 'build', ['minify'], ->
  manifest = _.values require './build/rev-manifest.json'
    .map (item) ->
      'build/' + item

  assets = gulp.src manifest
    .pipe $.rename (path) ->
      path.dirname = 'public/' + path.extname.substring(1)
      path

  fonts = gulp.src 'bower_components/font-awesome/fonts/*'
    .pipe $.rename dirname: 'public/fonts'

  views = gulp.src 'build/views/**/*.html'
    .pipe $.rename (path) ->
      path.dirname = 'views/' + path.dirname
      path

  merge assets, fonts, views
    .pipe $.zip moment().format('YYYY-MM-DD_HH-mm-ss') + '.zip'
    .pipe gulp.dest 'build/dist'

gulp.task 'clean', ['stylus:clean', 'browserify:clean'], (callback) ->
  del 'build/**/*', callback

gulp.task 'default', ['build']