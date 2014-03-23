define [
    'yggdrasil/world'
    'yggdrasil/floor'
    'yggdrasil/camera'
    'yggdrasil/wall'
    'alsvidr/viewvisitor'
    'util/random'
    'util/queuetask'
    'util/pointerlock'
    'util/vector3'
    'input/inputvisitor'
], (World, Floor, Camera, Wall, ViewVisitor, Random, queueTask, PointerLock, Vector3, InputVisitor) ->
    class Game
        constructor: ->
            self = @
            @world = new World()
            @world.add new Floor 10, 10
            @camera = new Camera new Vector3 5, 0.5, 5
            @world.add @camera
            @viewVisitor = new ViewVisitor @world
            @inputVisitor = new InputVisitor document

            @_placeWalls()

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

        launchDrawLoop: ->
            self = @
            tickPhysics = ->
                self.tickPhysics()
            viewVisitor = @viewVisitor
            draw = ->
                viewVisitor.update()
                queueTask tickPhysics
                requestAnimationFrame draw
            draw()

        tickPhysics: ->
            @world.visit @inputVisitor

