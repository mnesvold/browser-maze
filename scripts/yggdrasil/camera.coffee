define ['util/vector3'], (Vector3) ->
    class Camera
        constructor: (@x_pos, @y_pos, @z_pos, speedVector, yaw, pitch) ->
            @speedVector = speedVector ? new Vector3 .06, 0, .06
            @yaw = yaw ? 0
            @pitch = pitch ? 0

        accept: (visitor) ->
            visitor.visitCamera this
        
        getLookVector: ->
            target = new Vector3 0, 0, 1
            target.applyEuler new THREE.Euler(
                @pitch
                @yaw
                0
                'YXZ'
            )
            target
        
        moveForward: ->
            delta = @getLookVector()
            @_move delta
        
        moveBackward: ->
            delta = @getLookVector()
            delta.negate()
            @_move delta
        
        moveLeft: ->
            delta = @getLookVector()
            delta.cross new Vector3 0, -1, 0
            @_move delta
        
        moveRight: ->
            delta = @getLookVector()
            delta.cross new Vector3 0, 1, 0
            @_move delta
        
        _move: (delta) ->
            @x_pos += delta.x * @speedVector.x
            @y_pos += delta.y * @speedVector.y
            @z_pos += delta.z * @speedVector.z
