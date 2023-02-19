love.graphics.setDefaultFilter("nearest", "nearest")
--love.window.setMode(0,0, {fullscreen=false})
vector = require "lib.hump.vector"
Object = require "lib/classic"
flux = require 'lib/flux'


Gamestate = require 'lib.hump.gamestate'
Game = require 'states.game'
Menu = require 'states.menu'

local font = love.graphics.newFont('font/editundo.ttf', 30)
love.graphics.setFont(font)
--[[local push = require "lib.push"

local gameWidth, gameHeight = 640, 360 
local windowWidth, windowHeight = love.window.getDesktopDimensions()

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})]]

function love.load()
    math.randomseed(os.time())
    love.filesystem.setIdentity('nurse_game');

    --Gamestate.registerEvents()
    Gamestate.switch(Menu)
end

function love.update(dt)
    Gamestate.update(dt)
end

function love.draw()
    --push:start()
   Gamestate.draw()
   --push:finish()
end

function love.keypressed(key)
    Gamestate.keypressed(key)
end

function love.keyreleased(key)
    Gamestate.keyreleased(key)

end

--global functions
function lerp(a, b, x, dt)
    return a + (b - a) * x * dt
end

function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

function magnitude(vector)
    local x = vector.x
    local y = vector.y
    return math.sqrt((x^2)+(y^2))
 end

