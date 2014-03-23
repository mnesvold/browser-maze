define [], () ->
    class PhysicsVisitor
        visitCamera: (camera) ->
            camera.position.add camera.velocity
            camera.velocity.multiplyScalar 0

        visitWall: (camera) ->
        visitFloor: (camera) ->

