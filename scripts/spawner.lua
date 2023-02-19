Spawner = Object:extend()

local minStudents
local bodyTimer
local haveEffect

local function createUUID()
    local uuid = ""
    local chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    for i = 1, 6 do
        local l = math.random(1, #chars)
        uuid = uuid .. string.sub(chars, l, l)
    end
    return uuid
end

function Spawner:spawn(timer, bool)
    local inX = math.random(boundsX1, boundsX2)
    local inY = math.random(boundsY1, boundsY2)
    local sDeter = math.random(1,6)
    local sprite = nil
    local id = createUUID()

    if sDeter == 1 then
        sprite = love.graphics.newImage("sprites/students/students1.png")
    elseif sDeter == 2 then
        sprite = love.graphics.newImage("sprites/students/students2.png")
    elseif sDeter == 3 then
        sprite = love.graphics.newImage("sprites/students/students3.png")
    elseif sDeter == 4 then
        sprite = love.graphics.newImage("sprites/students/students4.png")
    elseif sDeter == 5 then 
        sprite = love.graphics.newImage("sprites/students/students5.png")
    elseif sDeter == 6 then
        sprite = love.graphics.newImage("sprites/students/students6.png")
    end

    table.insert(StudentNPC, Students(inX, inY, id, sprite, timer, bool))
    table.insert( CastShadow, Shadow(inX, inY, id, false))
end


function Spawner:initSpawn(value, min, timer, bool)
    for i = value, 1, -1 do
        self:spawn(timer, bool)
    end
    bodyTimer = timer
    haveEffect = bool
    minStudents = min
end


function Spawner:update(dt)
  
end

function Spawner:draw()

end


function Spawner:keypressed(key)
   -- if key == "k" and numberOfHealthy > maxInjured then
       -- injure()

    
   --s end
end

