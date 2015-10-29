World = require './yggdrasil/world'
Floor = require './yggdrasil/floor'
Camera = require './yggdrasil/camera'
Wall = require './yggdrasil/wall'
Panel = require './yggdrasil/panel'
Marker = require './yggdrasil/marker'
ViewVisitor = require './alsvidr/viewvisitor'
Random = require './util/random'
queueTask = require './util/queuetask'
PointerLock = require './util/pointerlock'
Vector2 = require './util/vector2'
Vector3 = require './util/vector3'
InputVisitor = require './input/inputvisitor'
PhysicsVisitor = require './physics/physicsvisitor'
Maze = require './mazes/SquarePrimMaze'

module.exports = class Game
    constructor: ->
        self = @
        @world = new World()
        @world.add new Floor 10, 10
        @camera = new Camera new Vector3 0.5, 0.5, 0.5
        @world.add @camera
        @viewVisitor = new ViewVisitor @world
        @inputVisitor = new InputVisitor document
        @physicsVisitor = new PhysicsVisitor

        #@_placeWalls()
        @_placeMaze()

        @world.add new Marker new Vector2(0.5, 0.5), 0.1, 0x000000
        @world.add new Marker new Vector2(9.5, 9.5), 0.1, 0xffffff

        canvas = document.getElementsByTagName('canvas')[0]
        canvas.addEventListener 'click', () ->
            pointerLock = new PointerLock canvas, () ->
            pointerLock.addMoveListener (event) ->
                deltaX = - event.movementX / 100
                deltaY = event.movementY / 100
                self.camera.yaw += deltaX
                self.camera.pitch += deltaY

        resize = (event) ->
            self.viewVisitor.handleResize event
        window.addEventListener 'resize', resize

    _placeWalls: ->
        random = new Random()
        x = 0
        while x < 10
            z = 0
            while z < 10
                if (0 < x < 9) and (0 < z < 9)
                    z += 1
                    continue
                @world.add new Wall x, 0.5, z, random.randomInt 0xffffff
                z += 1
            x += 1

    _placeMaze: ->
        unit = 1
        size = new Vector2 10, 10
        random = new Random()
        maze = new Maze unit, size, random
        for boundary in maze.boundaries
            for i in [1...boundary.length]
                start = boundary[i - 1]
                end = boundary[i]
                panel = new Panel 1, start, end
                @world.add panel

    launchDrawLoop: ->
        self = @
        tickPhysics = ->
            self.tickPhysics()
        viewVisitor = @viewVisitor
        draw = ->
            viewVisitor.update()
            queueTask tickPhysics
            unless window.shutdown?
                requestAnimationFrame draw
        draw()

    tickPhysics: ->
        @world.visit @inputVisitor
        @physicsVisitor.tickPhysics @world
