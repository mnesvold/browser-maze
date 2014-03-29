define [], () ->
    class Random
        constructor: ->

        randomFloat: ->
            Math.random()

        randomInt: (max) ->
            Math.floor Math.random() * max

        shuffle: (a) ->
            for i in [a.length-1..1]
                j = @randomInt i + 1
                [a[i], a[j]] = [a[j], a[i]]

