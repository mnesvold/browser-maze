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
$ git clone https://github.com/mnesvold/browser-maze.git
$ cd browser-maze
$ <edit files>
$ PATH=$PATH:./node_modules/.bin
$ grunt
$ <open build/maze.html in your favorite browser>
```

Most of the source is written in [CoffeeScript](http://coffeescript.org/), using a healthy portion of [Grunt](http://gruntjs.com/) for compilation and [RequireJS](http://requirejs.org) for dependency management. All the necessary Node packages (including Grunt itself) are checked in under `node_modules`, so as long as you have Node installed, put `node_modules/.bin` on your path for the session and run `grunt` to kick things off.

### Development Builds

The default `grunt` task generates a `build` folder that compiles everything in `src`, but leaves the RequireJS modules as they are. For convenience's sake, there's also a `grunt watch` task that will keep `build` up to date as you change files in `src`.

### Distribution Builds

Run `grunt dist` to generate a `dist` folder with the JavaScript combined and minified.

Dependencies
------------

* [Three.js](http://threejs.org/)
* [Raphael.js](http://raphaeljs.com/), for drawing the maze maps
* [Require.js](http://requirejs.org/), including its optimizer for `dist` builds

