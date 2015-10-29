$ = require 'jquery'
Game = require './game'

$(document).ready ->
    new Game().launchDrawLoop()
