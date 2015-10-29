module.exports = class World
    constructor: ->
        @objects = []
        @nextID = 1

    add: (object) ->
        object.object_id = @_getNextID()
        @objects.push object

    visit: (visitor) ->
        for object in @objects
            object.accept visitor

    _getNextID: ->
        next = @nextID
        @nextID += 1
        next
