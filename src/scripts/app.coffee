require ['jquery', 'game'], ($, Game) ->
    $(document).ready ->
        new Game().launchDrawLoop()

