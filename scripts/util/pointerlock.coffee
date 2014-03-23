define [], () ->
    _getPointerLockRequestFunction = (element) ->
        element.requestPointerLock ||
        element.mozRequestPointerLock ||
        element.webkitRequestPointerLock
    
    _getPointerLockElement = () ->
        document.pointerLockElement ||
        document.mozPointerLockElement ||
        document.webkitPointerLockElement

    class PointerLock
        constructor: (@element, @lockCallback) ->
            self = @
            @moveCallbacks = []
            @unlockCallbacks = []
            @_moveCallback = (event) ->
                self._fireMoveCallbacks event
            @_lockChangeCallback = (event) ->
                self._handleLockChange event
            document.addEventListener 'pointerlockchange', @_lockChangeCallback
            document.addEventListener 'mozpointerlockchange', @_lockChangeCallback
            document.addEventListener 'webkitpointerlockchange', @_lockChangeCallback
            request = _getPointerLockRequestFunction @element
            request.call @element
        
        addMoveListener: (listener) ->
            @moveCallbacks.push listener
        
        addUnlockListener: (listener) ->
            @unlockCallbacks.push listener
        
        _handleLockChange: (event) ->
            if _getPointerLockElement() == @element
                @_handlePointerLockAcquired()
            else
                @_handlePointerLockReleased()
        
        _handlePointerLockAcquired: (event) ->
            @lockCallback()
            document.addEventListener 'mousemove', @_moveCallback
        
        _handlePointerLockReleased: (event) ->
            document.removeEventListener 'mousemove', @_moveCallback
            document.removeEventListener 'pointerlockchange', @_lockChangeCallback
            document.removeEventListener 'mozpointerlockchange', @_lockChangeCallback
            document.removeEventListener 'webkitpointerlockchange', @_lockChangeCallback
            @_fireUnlockCallbacks()
        
        _fireMoveCallbacks: (event) ->
            @_polyfillMoveEvent event
            @_fireCallbacks @moveCallbacks, event
        
        _polyfillMoveEvent: (event) ->
            event.movementX = event.movementX || event.mozMovementX || event.webkitMovementX || 0
            event.movementY = event.movementY || event.mozMovementY || event.webkitMovementY || 0
        
        _fireUnlockCallbacks: (event) ->
            @_fireCallbacks @unlockCallbacks, event
        
        _fireCallbacks: (callbacks, event) ->
            for callback in callbacks
                callback event

