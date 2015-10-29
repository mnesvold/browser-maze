THREE = require 'three.js'
Vector3 = require '../util/vector3'

module.exports = class Camera
    constructor: (@position, speedVector, yaw, pitch) ->
        @velocity = new Vector3 0, 0, 0
        @speedVector = speedVector ? new Vector3 1, 0, 1
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
        @velocity.add delta.multiply @speedVector
