define ["three"], (THREE) ->
    class ViewVisitor
        constructor: (@world) ->
            @scene = scene = new THREE.Scene()
            @camera = camera = new THREE.PerspectiveCamera 75, 1, 0.1, 1000
            @renderer = renderer = new THREE.WebGLRenderer()
            @handleResize()
            document.body.appendChild renderer.domElement
            @viewObjects = {}

            scene.add new THREE.AxisHelper 25

            makeLight = (x, z, color) ->
                light = new THREE.PointLight color, 1, 100
                light.position.set x, 10, z
                light

            scene.add makeLight 0.5, 0.5, 0xffffff
            scene.add makeLight 0.5, 9.5, 0xff0000
            scene.add makeLight 9.5, 9.5, 0x00ff00
            scene.add makeLight 9.5, 0.5, 0x0000ff

        update: ->
            @world.visit this
            @draw()

        draw: ->
            @renderer.render @scene, @camera

        handleResize: (event) ->
            @camera.aspect = window.innerWidth / window.innerHeight
            @camera.updateProjectionMatrix()
            @renderer.setSize window.innerWidth, window.innerHeight

        visitFloor: (floor) ->
            if @viewObjects[floor.object_id]?
                return
            geometry = new THREE.CubeGeometry floor.x_size, 0.1, floor.z_size
            material = new THREE.MeshBasicMaterial { color: 0x222222 }
            mesh = new THREE.Mesh geometry, material
            mesh.position = new THREE.Vector3(
                floor.x_size / 2
                -0.1 + floor.y_pos
                floor.z_size / 2
            )
            @viewObjects[floor.object_id] = mesh
            @scene.add mesh

        visitWall: (wall) ->
            if @viewObjects[wall.object_id]?
                return
            geometry = new THREE.CubeGeometry 1, 1, 1
            material = new THREE.MeshBasicMaterial { color: wall.color_hex }
            mesh = new THREE.Mesh geometry, material
            mesh.position = new THREE.Vector3(
                wall.x_pos
                wall.y_pos
                wall.z_pos
            )
            @viewObjects[wall.object_id] = mesh
            @scene.add mesh

        visitPanel: (panel) ->
            if @viewObjects[panel.object_id]?
                return
            geometry = new THREE.PlaneGeometry 1, panel.height
            material = new THREE.MeshLambertMaterial {
                color: 0xffffff,
                side: THREE.DoubleSide
            }
            mesh = new THREE.Mesh geometry, material
            delta = panel.end.clone().sub panel.start
            mesh.scale.x = delta.length()
            mesh.rotation.y = - Math.atan2 delta.y, delta.x
            midpoint = panel.start.clone().lerp panel.end, 0.5
            mesh.position.set midpoint.x, panel.height / 2, midpoint.y
            @viewObjects[panel.object_id] = mesh
            @scene.add mesh

        visitMarker: (marker) ->
            if @viewObjects[marker.object_id]?
                return
            geometry = new THREE.CylinderGeometry 0.4, 0.4, marker.height, 20, 20
            material = new THREE.MeshLambertMaterial { color: marker.color }
            mesh = new THREE.Mesh geometry, material
            mesh.position.set(
                marker.position.x,
                marker.height / 2,
                marker.position.y
            )
            @viewObjects[marker.object_id] = mesh
            @scene.add mesh

        visitCamera: (camera) ->
            if @viewObjects[camera.object_id]?
                @_updateCamera camera, @viewObjects[camera.object_id]
                return
            threeCam = @camera
            @_updateCamera camera, threeCam
            @viewObjects[camera.object_id] = threeCam
            @scene.add threeCam

        _updateCamera: (camera, threeCam) ->
            threeCam.position = camera.position

            target = camera.getLookVector()
            target.add threeCam.position
            threeCam.lookAt target

