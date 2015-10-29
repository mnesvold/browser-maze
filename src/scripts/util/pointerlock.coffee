_getPointerLockRequestFunction = (element) ->
    element.requestPointerLock ||
        element.mozRequestPointerLock ||
        element.webkitRequestPointerLock

_getPointerLockElement = () ->
    document.pointerLockElement ||
        document.mozPointerLockElement ||
        document.webkitPointerLockElement

module.exports = class PointerLock
    constructor: (@element, @lockCallback) ->
        self = @
        @moveCallbacks = []
        @unlockCallbacks = []
        @_moveCallback = (event) ->
            self._fireMoveCallbacks event
        @_lockChangeCallback = (event) ->
            self._handleLockChange event
        @_addVendorListeners(
            document
            'pointerlockchange'
            @_lockChangeCallback
        )
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
        @_removeVendorListeners(
            document
            'pointerlockchange'
            @_lockChangeCallback
        )
        @_fireUnlockCallbacks()

    _fireMoveCallbacks: (event) ->
        @_polyfillMoveEvent event
        @_fireCallbacks @moveCallbacks, event

    _polyfillMoveEvent: (event) ->
        event.movementX ?=
            event.mozMovementX ?
            event.webkitMovementX ?
            0
        event.movementY ?=
            event.mozMovementY ?
            event.webkitMovementY ?
            0

    _fireUnlockCallbacks: (event) ->
        @_fireCallbacks @unlockCallbacks, event

    _fireCallbacks: (callbacks, event) ->
        for callback in callbacks
            callback event

    _addVendorListeners: (object, eventName, listener) ->
        object.addEventListener eventName, listener
        object.addEventListener 'moz' + eventName, listener
        object.addEventListener 'webkit' + eventName, listener

    _removeVendorListeners: (object, eventName, listener) ->
        object.removeEventListener eventName, listener
        object.removeEventListener 'moz' + eventName, listener
        object.removeEventListener 'webkit' + eventName, listener
