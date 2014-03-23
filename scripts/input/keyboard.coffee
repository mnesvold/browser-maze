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

        isActive: (keyCode) ->
            return @active[keyCode]

        @constants = KeyboardConstants
        @semantic = DvorakSemantics

