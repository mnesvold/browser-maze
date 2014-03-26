define ['util/vector2'], (Vector2) ->
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

    class SquarePrimMaze
        constructor: (@unit, size, @random) ->
            @size = size.clone().multiplyScalar @unit
            segments = [
                new Vector2 0, 0
                new Vector2 0, @size.y
                new Vector2 @size.x, @size.y
                new Vector2 @size.x, 0
                new Vector2 0, 0
            ]
            @boundaries = [ segments ]

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

            for x in xCoords[1..]
                for y in yCoords
                    start = nodeAt x - 1, y
                    end = nodeAt x, y
                    boundary = [
                        new Vector2(x, y).multiplyScalar @unit
                        new Vector2(x, y + 1).multiplyScalar @unit
                    ]
                    edges.push new Edge boundary, start, end

            for y in yCoords[1..]
                for x in xCoords
                    start = nodeAt x, y - 1
                    end = nodeAt x, y
                    boundary = [
                        new Vector2(x, y).multiplyScalar @unit
                        new Vector2(x + 1, y).multiplyScalar @unit
                    ]
                    edges.push new Edge boundary, start, end
            
            # Prune edges
            
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

