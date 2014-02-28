var gulp = require('gulp');

var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var exec = require('gulp-exec');
var filter = require('gulp-filter');
var gutil = require('gulp-util');
var plumber = require('gulp-plumber');
var sass = require('gulp-ruby-sass');
var uglify = require('gulp-uglify');

var paths = {

	coffee: ['js/*.coffee'],
	script: ['js/*.js'],
	styles: ['sass/**/*.sass', 'sass/**/*.scss', 'sass/**/*.css'],
	stylesMain: ['sass/style.sass']
};

gulp.task('init', function () {

	gulp.src('')
		.pipe(exec('if [ -w style.css ]; then echo "Permissions are good"; elif [ -a style.css ]; then echo "Error"; else touch style.css && chmod 774 style.css; fi'));
});

gulp.task('coffee', function () {

	return gulp.src(paths.coffee)
		.pipe(coffee())
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(gulp.dest('js/compiled.js'));
});

gulp.task('script', function () {

	return gulp.src(paths.script)
		.pipe(uglify())
		.pipe(concat('main.min.js'))
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(filter('main.min.js'))
		.pipe(gulp.dest(''));
});

gulp.task('styles', function () {

	return gulp.src(paths.stylesMain)
		.pipe(sass())
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(filter('style.css'))
		.pipe(gulp.dest(''));
});


gulp.task('watch', function () {

	gulp.watch(paths.coffee, ['coffee']);
	gulp.watch(paths.script, ['script']);
	gulp.watch(paths.styles, ['styles']);
});

gulp.task('default', ['init', 'watch']);