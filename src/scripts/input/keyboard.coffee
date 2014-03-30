define [], () ->
    log_events = false

    KeyboardConstants = k =
        UP: 38
        DOWN: 40
        COMMA: 188
        A: 65
        D: 68
        E: 69
        O: 79
        S: 83
        W: 87

    QWERTYSemantics =
        FORWARD: k.W
        BACKWARD: k.S
        STRAFE_LEFT: k.A
        STRAFE_RIGHT: k.D

    DvorakSemantics =
        FORWARD: k.COMMA
        BACKWARD: k.O
        STRAFE_LEFT: k.A
        STRAFE_RIGHT: k.E

    combineSemantics = (semantics...) ->
        merge = {}
        for source in semantics
            for key of source
                property = source[key]
                mergedProperty = merge[key] ? []
                if mergedProperty.indexOf(property) < 0
                    mergedProperty.push property
                merge[key] = mergedProperty
        merge

    class KeyboardInput
        constructor: (eventRoot) ->
            @active = active = {}
            eventRoot.addEventListener 'keydown', (event) ->
                if log_events
                    console.log "DOWN #{event.keyCode}"
                active[event.keyCode] = true
            eventRoot.addEventListener 'keyup', (event) ->
                if log_events
                    console.log " UP  #{event.keyCode}"
                delete active[event.keyCode]

        isActive: (keyCodes) ->
            if not Array.isArray(keyCodes)
                keyCode = [keyCodes]
            for keyCode in keyCodes
                if @active[keyCode]
                    return true
            false

        @constants = KeyboardConstants
        @semantic = combineSemantics QWERTYSemantics, DvorakSemantics

