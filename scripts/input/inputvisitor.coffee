define ['input/keyboard'], (KeyboardInput) ->
    class InputVisitor
        constructor: (root) ->
            @keyboard = new KeyboardInput root

        visitCamera: (camera) ->
            if @keyboard.isActive KeyboardInput.constants.UP
                camera.pitch -= 0.01
            if @keyboard.isActive KeyboardInput.constants.DOWN
                camera.pitch += 0.01
            if @keyboard.isActive KeyboardInput.semantic.FORWARD
                camera.moveForward()
            if @keyboard.isActive KeyboardInput.semantic.BACKWARD
                camera.moveBackward()
            if @keyboard.isActive KeyboardInput.semantic.STRAFE_LEFT
                camera.moveLeft()
            if @keyboard.isActive KeyboardInput.semantic.STRAFE_RIGHT
                camera.moveRight()

        visitFloor: ->
        visitWall: ->
        visitPanel: ->

