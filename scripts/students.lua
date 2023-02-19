Students = Object:extend()

local anim8 = require "lib.anim8"


require 'scripts.pointer'
require 'scripts.tools'
local injuryList = {Tool("Wound", 1, false, love.graphics.newImage("sprites/ui/wound.png")),
                    Tool("Headache", 2, false, love.graphics.newImage("sprites/ui/headache.png")),
                    Tool("Bruise", 3, false, love.graphics.newImage("sprites/ui/bruise.png"))}

local effectList = {Tool("Dehydrated", 4, true, love.graphics.newImage("sprites/ui/dehydration.png")),
                    Tool("Low Heart Rate", 5, true, love.graphics.newImage("sprites/ui/lowRate.png")),
                    Tool("None", nil, false)}



function Students:new(x, y, id, sprite, timer, bool)
    self.x = x
    self.y = y
    self.position = vector(x, y)
    self.id = id
    self.state = "walking"

    self.initTimer = timer
    self.bodyTimer, self.hasEffect = timer, bool
    self.normalizeTimer = nil

    if self.hasEffect then
        self.symptom = injuryList[math.random(1, #injuryList)]
        self.effect = effectList[math.random(1, #effectList)]
    else
        self.symptom = injuryList[math.random(1, #injuryList)]
        self.effect = effectList[#effectList]
    end
    

    self.speed = math.random(1,3)
    if self.speed == 1 then
        self.speed = 50
    elseif self.speed == 2 then
        self.speed = 75
    elseif self.speed == 3 then
        self.speed = 100
    end

    self.movePos =  vector(math.random(boundsX1, boundsX2),math.random(boundsY1, boundsY2))
    self.startTime = math.random(1,4)
    self.waitTime = self.startTime
    
    self.distToPlayer = nil

    self.sprite = sprite
    self.grid = anim8.newGrid(16, 16, self.sprite:getWidth(), self.sprite:getHeight())
    self.frame = {}
    self.frame.normal = anim8.newAnimation(self.grid('1-1',1), 0.2)
    self.frame.injured = anim8.newAnimation(self.grid('2-2',1), 0.2)
    self.frame.healed = anim8.newAnimation(self.grid('3-3',1), 0.2)
    self.frame.angel = anim8.newAnimation(self.grid('4-4',1), 0.2)
    self.currentFrame = self.frame.normal
    self.angelSprite = self.frame.angel
    
    self.arrow = love.graphics.newImage('sprites/arrow.png')

    self.cross = love.graphics.newImage('sprites/cross.png')
    self.crossOut = love.graphics.newImage('sprites/crossOut.png')
    self.currentCross = self.cross

    self.IsAiding = false
    self.isMoving = true
    self.rotFactor = 0
    self.rot = 0

end

local function rangeNormalizer(x, min, max)
    return (x - min) / (max - min)
end

function Students:update(dt)
    self.currentFrame:update(dt)

    if self.state == "walking" then
        self.isMoving =lerp
        if self.position:dist(self.movePos) < 0.2 then
            self.isMoving = false
            if self.waitTime <= 0 then
                self.waitTime = self.startTime
                self.movePos = vector(math.random(boundsX1, boundsX2),math.random(boundsY1, boundsY2))    
            else 
                self.waitTime = self.waitTime - dt
            end
        end
        if self.isMoving == false then
            self.rotFactor = 0
        else
            self.rotFactor = self.speed
        end
        self.position = MoveTowards(self.position, self.movePos, self.speed * dt)
        
    
        self.rot = math.sin(love.timer.getTime() * self.rotFactor/10) * 0.1
    end
    if self.state == "injured" then
        self.bodyTimer = self.bodyTimer - dt
        self.currentFrame = self.frame.injured
        self.distToPlayer = self.position:dist(player.position)
        self.rot = 0

        if self.bodyTimer <= 0 then
            self.state = "dead"
            GameMode = 0
        end
        self.normalizeTimer = rangeNormalizer(self.bodyTimer, 0, self.initTimer)
        
        if self.distToPlayer < 15 then
            self.currentCross = self.crossOut
        else
            self.currentCross = self.cross
        end
        
    end
    if self.state == "healed" then
        self.currentFrame = self.frame.healed
    end
    if self.state == "dead" then

    end
end

function Students:draw()
    if self.state == "injured" then
        love.graphics.draw(self.currentCross, self.position.x, self.position.y-30, nil, (scale + 1) * self.normalizeTimer, (scale + 1)  * self.normalizeTimer, 
                            self.currentCross:getWidth()/2, self.currentCross:getHeight()/2)
                            
        --Draw arrow
        if self.distToPlayer > 35 then
            local angle = math.atan2( self.position.y - player.position.y, self.position.x - player.position.x)
            love.graphics.draw(self.arrow, player.position.x, player.position.y, angle, scale, scale, -20, self.arrow:getHeight()  /2)
        end
        
    end
    self.currentFrame:draw(self.sprite, self.position.x, self.position.y, self.rot, scale, scale, self.sprite:getWidth()/8, self.sprite:getHeight()/2)
       
    if self.state == "dead" then
        self.angelSprite:draw(self.sprite, self.position.x, self.position.y-10, nil, scale, scale, self.sprite:getWidth()/8, self.sprite:getHeight()/2)
        --love.graphics.print("Them dead lmfao", self.position.x, self.position.y)
    end
end

function Students:keypressed(key)
    if self.state == "injured" then
        if self.distToPlayer < 15 then
            if key == "x" and self.IsAiding == false then
                self.IsAiding = true
                firstAid:grab(self.symptom, self.effect, self.id)
                firstAid:called()
            end
        end
    end
end



function MoveTowards(current, target, maxDistanceDelta)
    local a = target - current;
    local magnitude = magnitude(a)
        if magnitude <= maxDistanceDelta or magnitude == 0 then
            return target;
        end
    return current + a / magnitude * maxDistanceDelta;
end



