local game = Gamestate.new()

StudentNPC = {}
CastShadow = {}

require "scripts.player"
require "scripts.students"
require "scripts.spawner"
require "scripts.injury"
require "scripts.firstAid"
require "scripts.shadow"
require "scripts.timer"

player = Player()
spawner = Spawner()
injure = Injure()
firstAid = FirstAid()
local timer = Timer()

local playerShadow = Shadow(player.position.x, player.position.y, nil, true)

scale = 2

local cartographer = require "lib.cartographer"
local gameMap = cartographer.load('maps/playMap.lua')
--local boundMap = gameMap.layers["Wall"
boundsX1, boundsY1, boundsX2, boundsY2 = 240, 240, 1168, 944

mapW = gameMap.width * gameMap.tilewidth * scale
mapH = gameMap.height * gameMap.tileheight  *scale

local gamera = require"lib.gamera"
local cam = gamera.new(0, 0, mapW, mapH)

local camPos = vector(player.position.x, player.position.y)

GameMode = 0

local toggleDraw = true
local gameStart = false
local gameEnd = false

Difficulty = "normal"
local spawnValue 
local injuryRate
local bodyTimer
local haveEffect
local minStudents

function DifficultySetter()
    if Difficulty == "hard" then
        spawnValue = 20
        injuryRate = 5
        bodyTimer = 15
        haveEffect = true
        minStudents = 0
    elseif Difficulty == "normal" then
        spawnValue = 20
        injuryRate = 8
        bodyTimer = 20
        haveEffect = true
        minStudents = 0
    end
end

function game:init()
    cam:setWorld(0,0,mapW,mapH)
    DifficultySetter()
end

function game:enter()
    gameStart = false

    StudentNPC = {}
    CastShadow = {}
    player:reset()
    timer:reset()

    injure:init(injuryRate, minStudents, spawnValue)
    spawner:initSpawn(spawnValue, minStudents, bodyTimer, haveEffect)
end

function game:update(dt)
    
    if gameEnd == false then
        if gameStart then
        flux.update(dt)
        timer:update(dt)
        if GameMode == 0 then
            camPos.x = lerp(camPos.x, player.position.x, 15, dt)
            camPos.y = lerp(camPos.y, player.position.y, 15, dt)
            cam:setPosition(camPos.x, camPos.y)

            spawner:update(dt)
            player:update(dt)
        end
        if GameMode == 1 then
            camPos.x = lerp(camPos.x, player.position.x - 100, 15, dt)
            camPos.y = lerp(camPos.y, player.position.y + 50, 15, dt)
            cam:setPosition(camPos.x, camPos.y)
            firstAid:update(dt)
            
        end
        
        injure:update(dt)
        for i,v in ipairs(StudentNPC) do
            v:update(dt)
        end
        for i, v in ipairs(CastShadow) do
            v:update(dt)
        end
        playerShadow:update(dt)

        numberOfHealthy, numberOfHealed, numberOfDead = injure:grab()

        if numberOfHealed + numberOfDead == spawnValue then
            gameEnd = true
        end
        
        --[[if cam.x > (mapW - love.graphics.getWidth()) * scale then
            cam.x = (mapW - love.graphics.getWidth()) * scale
        end
        if cam.y > (mapH - love.graphics.getHeight()) * scale then
            cam.y = (mapH - love.graphics.getHeight()) * scale
        end]]
    end
end
end

local function drawCamera()
    love.graphics.push()
        love.graphics.scale(scale, scale)
        gameMap:draw()
    love.graphics.pop()
    for index, value in ipairs(CastShadow) do
        value:draw()
    end
    playerShadow:draw()
    for i,v in ipairs(StudentNPC) do
        v:draw()
    end
    player:draw()
end


function game:draw()
    if gameEnd == false then
        if gameStart then
            cam:draw(drawCamera)
            --love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)
            timer:draw()
            --love.graphics.print("Number of Students:".. #StudentNPC, 10, 30)
            
            if GameMode == 1 then
                firstAid:draw()
            end
        end
        if not gameStart then
            love.graphics.print("Press [ENTER] to start", 10 , love.graphics.getHeight()- 50)
        end
    end

if gameEnd then
    love.graphics.print("You saved ".. numberOfHealed .." students", 10 ,10)
    love.graphics.print("Press [ENTER] to return to menu", 10 , love.graphics.getHeight()- 50)
end
end


function game:keypressed(key)
    for i,v in ipairs(StudentNPC) do
        v:keypressed(key)
    end

    if GameMode == 1 then
        firstAid:keyreleased(key)
    end
   
    if key == "escape" and gameStart == true then
        Gamestate.switch(Menu)
    end
    if key == "return" then
        gameStart = true
    end
    if key == "return" and gameEnd == true then
        Gamestate.switch(Menu)
    end
   --[[ if key == "z" and GameMode == 1 then
        GameMode = 0
    end]]

end

function game:keyreleased(key)
    player:keyreleased(key)
end

return game