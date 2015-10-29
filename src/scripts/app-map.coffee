$ = require 'jquery'
Raphael = require 'raphael'
Maze = require './mazes/TrianglePrimMaze'
Random = require './util/random'
Vector2 = require './util/Vector2'

drawMap = (maze, scale = 1, addToDocument = null) ->
    $canvas = $ '<div></div>'
    $canvas.addClass 'map-frame'

    if addToDocument?
        addToDocument $canvas

    width = maze.size.x * scale + 25
    height = maze.size.y * scale + 25
    #$canvas.width width
    #$canvas.height height
    paper = Raphael $canvas[0], width, height

    bg = paper.rect 0, 0, width, height
    bg.attr {
        fill: '#CCCCCC'
        'stroke-width': 0
    }

    pathString = ''
    for boundary in maze.boundaries
        v = boundary[0]
        v = v.clone().add new Vector2 10, 10
        pathString += "M#{v.x * scale},#{v.y * scale}"
        for v in boundary[1..]
            v = v.clone().add new Vector2 10, 10
            pathString += "L#{v.x * scale},#{v.y * scale}"
#        console.log pathString
    path = paper.path pathString
    path.attr {
        'stroke-width': 2
    }

    $canvas

$(document).ready ->
    $gallery = $ '#gallery'

    unit = 20
    size = new Vector2 15, 15

    for i in [0..10]
        do (i) ->
            random = new Random()
            maze = new Maze unit, size, random
            map = drawMap maze, 1, (el) ->
                $gallery.append el
