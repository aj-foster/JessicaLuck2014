var gulp = require('gulp');

var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var exec = require('gulp-exec');
var filter = require('gulp-filter');
var gutil = require('gulp-util');
var haml = require('gulp-ruby-haml');
var livereload = require('gulp-livereload');
var plumber = require('gulp-plumber');
var sass = require('gulp-ruby-sass');
var rename = require('gulp-rename');
var uglify = require('gulp-uglify');

var paths = {

	coffee: ['js/*.coffee'],
	haml: ['haml/*.haml'],
	script: ['js/*.js'],
	styles: ['sass/**/*.sass', 'sass/**/*.scss', 'sass/**/*.css'],
	stylesMain: ['sass/style.sass'],

	outputs: ['*.php', 'style.css', 'main.min.js']
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
		.pipe(gulp.dest('js'));
});

gulp.task('haml', function () {

	return gulp.src(paths.haml)
		.pipe(haml())
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(rename({extname: '.php'}))
		.pipe(gulp.dest(''));
});

gulp.task('script', function () {

	return gulp.src(paths.script)
		.pipe(concat('main.min.js'))
		.pipe(uglify())
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(gulp.dest(''));
});

gulp.task('styles', function () {

	return gulp.src(paths.stylesMain)
		.pipe(sass({style: "compressed"}))
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(filter('style.css'))
		.pipe(gulp.dest(''));
});


gulp.task('watch', function () {

	gulp.watch(paths.coffee, ['coffee'])
		.on('error', gutil.log)
		.on('error', gutil.beep);
	gulp.watch(paths.haml, ['haml'])
		.on('error', gutil.log)
		.on('error', gutil.beep);
	gulp.watch(paths.script, ['script'])
		.on('error', gutil.log)
		.on('error', gutil.beep);
	gulp.watch(paths.styles, ['styles'])
		.on('error', gutil.log)
		.on('error', gutil.beep);

	var server = livereload();

	gulp.watch(paths.outputs)
		.on('change', function (file) {
			server.changed(file.path);
		});
});

gulp.task('default', ['init', 'watch']);