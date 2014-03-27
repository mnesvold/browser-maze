define ['util/vector3'], (Vector3) ->
    class PhysicsVisitor
        tickPhysics: (world) ->
            @obstacles = []
            @mobiles = []
            @_collectObjects world
            @_tickObjects()
            delete @obstacles
            delete @mobiles

        _collectObjects: (world) ->
            world.visit this

        _tickObjects: ->
            for mobile in @mobiles
                @_tickObject mobile

        _tickObject: (mobile) ->
            originalPosition = mobile.position.clone()
            mobile.position.add mobile.velocity
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

        visitWall: (wall) ->
            pos = new Vector3 wall.x_pos, wall.y_pos, wall.z_pos
            min = pos.clone().sub new Vector3(.5, .5, .5)
            max = pos.add new Vector3(.5, .5, .5)
            obstacle =
                min: min
                max: max
            @obstacles.push obstacle

        visitPanel: (panel) ->

        visitFloor: (floor) ->

        visitMarker: (marker) ->

