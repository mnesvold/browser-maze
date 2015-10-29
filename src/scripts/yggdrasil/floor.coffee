module.exports = class Floor
    constructor: (@x_size, @z_size, @y_pos=0) ->

    accept: (visitor) ->
        visitor.visitFloor this
