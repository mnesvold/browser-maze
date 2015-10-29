Browser Maze
============

A procedurally-generated, 3D maze, right in your browser.


Try It!
-------

Check out https://mnesvold.github.io/browser-maze/.

Hack on It!
-----------

```bash
# tl;dr
$ git clone https://github.com/mnesvold/browser-maze.git # Get the code
$ cd browser-maze                                        # Get in the code
$ npm install                                            # Install dependencies
$ <edit files>                                           # Hack!
$ ./compile                                              # Build
$ <open build/maze.html in your favorite browser>        # Play
```

The source is written in [CoffeeScript](http://coffeescript.org/), using [Browserify](http://browserify.org/) + [Coffeeify](https://www.npmjs.com/package/coffeeify) for dependency management. Run `npm install` to get the build and runtime dependencies, then run `./compile` to kick things off. Browser Maze uses no XHRs, so you can open `build/maze.html` over the `file://` scheme without bothering with static file servers.

Runtime Dependencies
------------

* [JQuery](https://jquery.com/) for minor DOM interactions
* [Three.js](http://threejs.org/) for the 3D graphics
* [Raphael.js](http://raphaeljs.com/) for drawing the maze maps
