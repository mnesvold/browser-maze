define [], () ->
    class Panel
        constructor: (@height, @start, @end) ->

        accept: (visitor) ->
            visitor.visitPanel this

