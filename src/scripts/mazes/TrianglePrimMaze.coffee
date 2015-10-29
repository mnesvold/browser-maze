Vector2 = require '../util/vector2'

class Node
    nextComponent = 0

    constructor: (@coord) ->
        @edges = []
        @component = nextComponent
        nextComponent += 1

class Edge
    constructor: (@boundary, @nodes...) ->
        for node in @nodes
            node.edges.push this

module.exports = class TrianglePrimMaze
    constructor: (@unit, size, @random) ->
        upsilon = @unit
        upsilonOverTwo = upsilon * 0.5
        upsilonRootThreeOverTwo = upsilonOverTwo * Math.sqrt 3

        @size = new Vector2(
            size.x * upsilonOverTwo
            size.y * upsilonRootThreeOverTwo
        )
        @boundaries = []

        # Generate outer walls
        boundaries = @boundaries
        do (boundaries, size) ->
            north = 0
            south = size.y * upsilonRootThreeOverTwo
            northwestX = southwestX = upsilonOverTwo
            northeastX = southeastX = size.x * upsilonOverTwo
            if (size.y % 2) == 0
                southwestX -= upsilonOverTwo
                southeastX -= upsilonOverTwo
            [].push [
                new Vector2 northwestX, north
                new Vector2 northeastX, north
                new Vector2 southeastX, south
                new Vector2 southwestX, south
                new Vector2 northwestX, north
            ]

        boundaries = @boundaries
        do (boundaries, size) ->
            # North wall
            north = 0
            west = upsilonOverTwo
            east = size.x * upsilonOverTwo
            boundaries.push [
                new Vector2 west, north
                new Vector2 east, north
            ]

            # South wall
            south = size.y * upsilonRootThreeOverTwo
            if (size.y % 2) != 0
                west -= upsilonOverTwo
                east += upsilonOverTwo
            boundaries.push [
                new Vector2 west, south
                new Vector2 east, south
            ]

            makeSideWall = (x, y, dx, dy, yMax) ->
                wall = []
                while y <= yMax
                    wall.push new Vector2(
                        x * upsilonOverTwo
                        y * upsilonRootThreeOverTwo
                    )
                    x += dx
                    y += dy
                    dx *= -1
                wall

            # West wall
            boundaries.push makeSideWall 1, 0, -1, 1, size.y

            # East wall
            dx = 1
            if (size.x % 2) == 0
                dx = -1
            x = size.x
            boundaries.push makeSideWall x, 0, dx, 1, size.y

        # Generate nodes

        xCoords = (x for x in [0...size.x])
        yCoords = (y for y in [0...size.y])
        nodes = []
        for y in yCoords
            for x in xCoords
                nodes.push new Node new Vector2 x, y

        nodeAt = (x, y) ->
            index = x + (y * xCoords.length)
            nodes[index]

        # Generate edges

        edges = []

        isDelta = (x, y) ->
            return (x % 2) == (y % 2)

        # West edges
        for x in xCoords[1..]
            for y in yCoords
                start = nodeAt x - 1, y
                end = nodeAt x, y

                north = y * upsilonRootThreeOverTwo
                south = (y + 1) * upsilonRootThreeOverTwo
                west = x * upsilonOverTwo
                east = (x + 1) * upsilonOverTwo

                delta = isDelta x, y
                if delta
                    westY = south
                    eastY = north
                else
                    westY = north
                    eastY = south

                boundary = [
                    new Vector2 west, westY
                    new Vector2 east, eastY
                ]
                edges.push new Edge boundary, start, end

        # North edges

        for y in yCoords[1..]
            for x in xCoords
                if isDelta x, y
                    continue

                start = nodeAt x, y - 1
                end = nodeAt x, y

                north = y * upsilonRootThreeOverTwo
                west = x * upsilonOverTwo
                east = (x + 2) * upsilonOverTwo

                boundary = [
                    new Vector2 west, north
                    new Vector2 east, north
                ]
                edges.push new Edge boundary, start, end

        # Prune edges

        if false
            barriers = edges
        else
            barriers = []
            @random.shuffle edges

            for edge in edges
                [start, end] = edge.nodes
                if start.component == end.component
                    barriers.push edge
                    continue
                oldComponent = end.component
                newComponent = start.component
                for node in nodes
                    if node.component == oldComponent
                        node.component = newComponent

        # Convert edges to boundaries
        for barrier in barriers
            @boundaries.push barrier.boundary
