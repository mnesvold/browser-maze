module.exports = class Marker
    constructor: (@position, @height, @color) ->

    accept: (visitor) ->
        visitor.visitMarker this
