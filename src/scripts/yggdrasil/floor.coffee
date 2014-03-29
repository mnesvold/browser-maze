define [], () ->
    class Floor
        constructor: (@x_size, @z_size, @y_pos) ->

        accept: (visitor) ->
            visitor.visitFloor this

