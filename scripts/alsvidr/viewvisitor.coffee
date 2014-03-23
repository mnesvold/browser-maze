define ["three"], (THREE) ->
    class ViewVisitor
        constructor: (@world) ->
            @scene = scene = new THREE.Scene()
            ratio = window.innerWidth / window.innerHeight
            @camera = camera = new THREE.PerspectiveCamera 75, ratio, 0.1, 1000
            @renderer = renderer = new THREE.WebGLRenderer()
            renderer.setSize window.innerWidth, window.innerHeight
            document.body.appendChild renderer.domElement
            @viewObjects = {}
            
            scene.add new THREE.AxisHelper 25
            
            light = new THREE.PointLight 0xffffff, 1, 100
            light.position = new THREE.Vector3 5, 10, 5
            scene.add light
            
        update: ->
            @world.visit this
            @draw()

        draw: ->
            @renderer.render @scene, @camera

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
        
        visitCamera: (camera) ->
            if @viewObjects[camera.object_id]?
                @_updateCamera camera, @viewObjects[camera.object_id]
                return
            threeCam = @camera
            @_updateCamera camera, threeCam
            @viewObjects[camera.object_id] = threeCam
            @scene.add threeCam

        _updateCamera: (camera, threeCam) ->
            threeCam.position.x = camera.x_pos
            threeCam.position.y = camera.y_pos
            threeCam.position.z = camera.z_pos
            
            target = camera.getLookVector()
            target.add threeCam.position
            threeCam.lookAt target

