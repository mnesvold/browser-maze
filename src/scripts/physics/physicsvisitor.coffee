Vector3 = require '../util/vector3'

module.exports = class PhysicsVisitor
    constructor: ->
        @_lastTick = null

    tickPhysics: (world) ->
        lastTick = @_lastTick
        nowTick = @_now()
        @_lastTick = nowTick
        unless lastTick?
            return
        elapsed = (nowTick - lastTick)
        @obstacles = []
        @mobiles = []
        @_collectObjects world
        @_tickObjects elapsed
        delete @obstacles
        delete @mobiles

    _now: ->
        window.performance.now() / 1000

    _collectObjects: (world) ->
        world.visit this

    _tickObjects: (elapsed) ->
        for mobile in @mobiles
            @_tickObject elapsed, mobile

    _tickObject: (elapsed, mobile) ->
        originalPosition = mobile.position.clone()
        mobile.position.add mobile.velocity.multiplyScalar elapsed
        mobile.velocity.set 0, 0, 0
        if @_isMobileInCollision mobile
            mobile.position = originalPosition

    _isMobileInCollision: (mobile) ->
        for obstacle in @obstacles
            if @_areObjectsColliding mobile, obstacle
                return true
        return false

    _areObjectsColliding: (mobile, obstacle) ->
        for i in [0..2]
            min = obstacle.min.getComponent i
            max = obstacle.max.getComponent i
            position = mobile.position.getComponent i
            collision = (min <= position <= max)
            if not collision
                return false
        return true

    visitCamera: (camera) ->
        @mobiles.push camera

    visitPanel: (panel) ->

    visitFloor: (floor) ->

    visitMarker: (marker) ->
