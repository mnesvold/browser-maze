Browser Maze
============

A procedurally-generated, 3D maze, right in your browser.


Try It!
-------

To give it a try, download `maze.html`, `maze.js`, and `require.js` from the `dist` folder onto your local machine and open `maze.html` from there into your local browser.

Hack on It!
-----------

```bash
# tl;dr
$ git clone https://github.com/mnesvold/browser-maze.git # Get the code
$ cd browser-maze                                        # Get in the code
$ npm install                                            # Install build dependencies
$ bower install                                          # Install client dependencies
$ PATH=$PATH:./node_modules/.bin                         # Get the dependencies on the path
$ <edit files>                                           # Hack!
$ grunt                                                  # Build
$ <open build/maze.html in your favorite browser>        # Play
```

Most of the source is written in [CoffeeScript](http://coffeescript.org/), using a healthy portion of [Grunt](http://gruntjs.com/) for compilation, [Bower](http://bower.io/) for client-side dependencies, and [RequireJS](http://requirejs.org) for inter-module dependency management. Run `npm install` to get the build dependencies, run `bower install` to get the client-side libraries in place, put `node_modules/.bin` on your path for the session, and run `grunt` to kick things off.

### Development Builds

The default `grunt` task generates a `build` folder that compiles everything in `src`, but leaves the RequireJS modules as they are. For convenience's sake, there's also a `grunt watch` task that will keep `build` up to date as you change files in `src`.

### Distribution Builds

Run `grunt dist` to generate a `dist` folder with the JavaScript combined and minified.

Dependencies
------------

* [Three.js](http://threejs.org/)
* [Raphael.js](http://raphaeljs.com/), for drawing the maze maps
* [Require.js](http://requirejs.org/), including its optimizer for `dist` builds

