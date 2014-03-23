_config =
    shim:
        three:
            exports: 'THREE'

requirejs.config _config

require ['jquery', 'game'], ($, Game) ->
    $(document).ready ->
        new Game().launchDrawLoop()
