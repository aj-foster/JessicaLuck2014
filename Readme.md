# Jessica and Luck 2014

**Website for the 2014 SGA Presidential Election at the University of Central Florida**

---

### Overview

**Introduction**: This is a website that was created by AJ Foster for one of the 2014 UCF SGA Presidential candidates.  Because previous campaign websites are often used as starting points for each year's campaign, I elected to make this site's code public in the spirit of the web community.

**License**: You are free to look through the code (obviously, since it is posted here) and use it as a reference.  You may not use the site's code in its entirety.  It would be extremely nice to leave a comment in your site's header lending credit if this repository was helpful.

**Trying it Out**: If you'd like to run these files on your own, use `git clone (...)` with the link to the right, or download the project as a .zip folder.  Because compiled assets (i.e. the actual HTML, CSS, and JS files) are difficult to manage with git, they have been ommitted from this project.  In order to generate those files, follow these steps:

1. Do you have Node.js installed on your system?  If not, check out [the Node.js website](http://nodejs.org) and install it.
2. Do you have Gulp installed?  If not, run `npm install -g gulp` in your Mac / Linux Terminal.
3. Do you have Haml / Sass installed?  If not, run `gem install haml sass` in your terminal.
4. Also in your terminal, `cd` to the JessicaLuck2014 project directory.  Run `npm install` to install all of the necessary packages for building / compiling the site.
5. Run `gulp deploy` to generate all of the site's files.  You're done!

**Technical Details**: This site has several moving parts:

* [Gulp](http://gulpjs.com/) (a JavaScript task runner, like Grunt) compiles the site's assets. See `Gulpfile.js` for more commentary.
* [Haml](http://haml.info/) is a language that compiles into HTML.
* [Sass](http://sass-lang.com/) is a language that compiles into CSS.
* [CoffeeScript](http://coffeescript.org/) is a language that compiles into Javascript.
* [Bourbon](http://bourbon.io/) and [Neat](http://neat.bourbon.io/) are complementary frameworks that make site layouts very easy.
* [HTML5 Shiv](https://code.google.com/p/html5shiv/) and [Selectivizr](http://selectivizr.com/) fix Internet Explorer... at least they try.

---

### Reflection

**Analytics**: Here's a quick snapshot of the site's usage during the campaign period.

* 1,116 Visitors
* Highest traffic: 1 day after launch, and during the election days (~150 / day)
* Highest times: 2pm and 9pm
* 70% Desktop, 25% Mobile, 5% Tablet
* 43% Direct Traffic, 42% Referred from Social Media, 13% Organic Search

**Design**: The layout of the site is very simple, which is good considering how difficult it is to encourage educated voting.  As a whole, the site is quite plain.  Given that (without the video) the site used 9 requests and less than 400kb of bandwidth, we certainly could have afforded to add decorative elements (background images, for example).  While the expansive bios / involvement / platform makes for good reading to someone who cares, we should have focused on the majority of voters who simply don't - easily accessible highlights from each of those sections would have been preferable to most visitors.

**Usage**: Having a section to highlight supporters is a good idea, but it didn't work within the small timeframe of the election.  It all depends, of course, on how many people offer their photo.

**Maintenance**: Using Sass / Haml like this is great for rapid prototyping and quick deployment.  Unfortunately, you as the web developer are committing yourself to making all necessary changes to the site throughout the process.  Whereas something like Wordpress would allow the candidates to tweak the site's text to their heart's content, Haml is strictly developer-friendly.  Keep this in mind when you budget time for the project.

---

If you have any questions, please feel free to open an issue or contact me directly.