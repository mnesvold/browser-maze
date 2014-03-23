define [], () ->
    class Random
        constructor: ->
        
        randomFloat: ->
            Math.random()
        
        randomInt: (max) ->
            Math.floor Math.random() * max

