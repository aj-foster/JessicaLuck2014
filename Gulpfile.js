// Gulp is a JavaScript task runner (like Grunt) that... runs tasks.  In this
// Gulpfile, we instruct Gulp to compile our Haml, Sass, and CoffeeScript, as
// well as concatenate and minify JavaScript files together.

// To use Gulp, install Node.js, run "npm install -g gulp" as well as
// "npm install" in the project directory.  Then, run "gulp" to have Gulp watch
// for file changes or "gulp deploy" to run a one-time compilation.

// All of the following require statements call in the various packages that
// are installed using "npm install".  They live in the node_modules folder and
// should not be checked into a git repository.

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


// When we ask Gulp to watch for changes to the various files and trigger
// compilation, these are the paths to watch.

var paths = {

	coffee: ['js/*.coffee'],
	haml: ['haml/*.haml'],
	script: ['js/*.js'],
	styles: ['sass/**/*.sass', 'sass/**/*.scss', 'sass/**/*.css'],
	stylesMain: ['sass/style.sass'],

	outputs: ['*.php', 'style.css', 'main.min.js']
};


// When Gulp starts, we do a quick check to see if the style.css file to which
// we are going to write is writable.

gulp.task('init', function () {

	gulp.src('')
		.pipe(exec('if [ -w style.css ]; then echo "Permissions are good"; elif [ -a style.css ]; then echo "Error"; else touch style.css && chmod 774 style.css; fi'));
});


// When CoffeeScript files are saved, we use coffee() to compile them and
// deposite the compile JavaScript in the js/ folder.

gulp.task('coffee', function () {

	return gulp.src(paths.coffee)
		.pipe(coffee())
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(gulp.dest('js'));
});


// Similarly, when Haml files are saved, we compile them to HTML.  Originally
// we were going to use PHP functionality on the main page, hence we tell Gulp
// to rename the output files to .php instead of .html.

gulp.task('haml', function () {

	return gulp.src(paths.haml)
		.pipe(haml())
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(rename({extname: '.php'}))
		.pipe(gulp.dest(''));
});


// When changes are made to JavaScript files, whether due to CoffeeScript
// compilation or otherwise, we concatenate all of the JavaScript into a single
// file and minify (uglify) it.  This is the production code.

gulp.task('script', function () {

	return gulp.src(paths.script)
		.pipe(concat('main.min.js'))
		.pipe(uglify())
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(gulp.dest(''));
});


// Finally, when Sass files are changed, we compile the styles.  There are
// various ways to output the CSS; "compressed" works well for production code.

gulp.task('styles', function () {

	return gulp.src(paths.stylesMain)
		.pipe(sass({style: "compressed"}))
		.on('error', gutil.log)
		.on('error', gutil.beep)
		.pipe(filter('style.css'))
		.pipe(gulp.dest(''));
});


// Here we instruct Gulp to watch the various types of files and trigger the
// appropriate tasks.  As an added bonus, if you have a LiveReload plugin
// installed in your browser, Gulp will trigger a refresh / style injection.

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
gulp.task('deploy', ['init', 'coffee', 'script', 'styles', 'haml']);