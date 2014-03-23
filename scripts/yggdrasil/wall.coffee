define [], () ->
    class Wall
        constructor: (@x_pos, @y_pos, @z_pos, @color_hex) ->
        
        accept: (visitor) ->
            visitor.visitWall this

