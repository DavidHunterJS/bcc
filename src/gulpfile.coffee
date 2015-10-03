do ->
  'use strict'
  
  gulp         = require 'gulp'
  gutil        = require 'gulp-util'
  plumber      = require 'gulp-plumber'
  connect      = require 'gulp-connect'
  coffee       = require 'gulp-coffee'
  sass         = require 'gulp-sass'
  concat       = require 'gulp-concat'
  uglify       = require 'gulp-uglify'
  minifyCSS    = require 'gulp-minify-css'


  gulp.task 'connect', ->
    connect.server
      port: 9000
      root: '../dist'
      livereload: true
    return
  
  gulp.task 'html', ->
    gulp.src('*.html')
      .pipe(gulp.dest('../dist'))
      .pipe connect.reload()
  
  
  ###gulp.task 'js', ->
    gulp.src('js/*.js')
      .pipe(plumber())
      .pipe(uglify())
      .pipe(gulp.dest('../dist/js'))
      .pipe connect.reload()###
  
  gulp.task 'sass', ->
    gulp.src('./sass/*.sass')
      .pipe(sass(
        indentedSyntax: true
        errLogToConsole: true
      )).on('error', gutil.log)
      .pipe(gulp.dest('../dist/css/'))
      .pipe connect.reload()

  gulp.task 'coffeeTask', ->
    gulp.src('./coffee/*.coffee')
      .pipe(plumber())
      .pipe(coffee({bare: true}).on('error', gutil.log))
      .pipe(gulp.dest('../dist/js/'))
      .pipe connect.reload()
  
  gulp.task 'watch', ->
    gulp.watch [ '*.html' ], [ 'html' ]
    gulp.watch [ './coffee/*.coffee' ], [ 'coffeeTask' ]
    gulp.watch [ './sass/*.sass' ], [ 'sass' ]
    # gulp.watch [ 'js/*.js' ], [ 'js' ]
    return
  
  gulp.task 'default', [
    'connect'
    'watch'
  ]
  return
