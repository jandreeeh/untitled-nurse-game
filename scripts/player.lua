Player = Object:extend()

local rotFactor = 0

function Player:new()
    self.position = vector(240, 496)
    self.tempPos = vector(self.position.x, self.position.y)
    self.speed = 100
    self.rot = 0
    self.state = 0
    self.isMoving = false
    self.sprite = love.graphics.newImage("sprites/player/player.png")
    self.shadow = love.graphics.newImage('sprites/shadow.png')

    self.isSprinting = false
    self.shiftPressing = false
    self.sprintAmount = 1
    self.sprintSpeed = 300
end

function Player:reset()
    self.position = vector(240, 496)
    self.tempPos = vector(self.position.x, self.position.y)
    self.speed = 100
end

function Player:update(dt)
    self.isMoving = false

    if love.keyboard.isDown("right") then
        self.tempPos.x = self.tempPos.x + self.speed * dt
        self.isMoving = true
    end
    if love.keyboard.isDown("left") then
        self.tempPos.x = self.tempPos.x - self.speed * dt
        self.isMoving = true
    end
    if love.keyboard.isDown("down") then
        self.tempPos.y = self.tempPos.y + self.speed * dt
        self.isMoving = true
    end
    if love.keyboard.isDown("up") then
        self.tempPos.y = self.tempPos.y - self.speed * dt
        self.isMoving = true
    end
    if love.keyboard.isDown("lshift") and self.sprintAmount <=3 and self.isSprinting == false and self.shiftPressing == false then
        self.speed = self.sprintSpeed
        self.sprintAmount = self.sprintAmount - dt
        if self.sprintAmount <= 0 then
            self.isSprinting = true
            self.shiftPressing = true
        end
    else
        self.speed = 130
        self.sprintAmount = self.sprintAmount + dt
        if self.sprintAmount > 1 then
            self.sprintAmount = 1
            self.isSprinting = false
        end
    end
    
    if self.tempPos.x < boundsX1 then
        self.tempPos.x = boundsX1
    end
    if self.tempPos.x > boundsX2 then
        self.tempPos.x = boundsX2
    end
    if self.tempPos.y < boundsY1 then
        self.tempPos.y = boundsY1
    end
    if self.tempPos.y > boundsY2 then
        self.tempPos.y = boundsY2
    end
    

    self.position = lerp(self.position, self.tempPos, 10, dt)
  -- self.position.y = lerp(self.position.y, self.tempPos.y, 5, dt)
    if self.isMoving == false then
        rotFactor = 0
    else
        rotFactor = self.speed
    end

    self.rot = math.sin(love.timer.getTime() * rotFactor/10) * 0.1
end

function Player:keyreleased(key)
    if key == "lshift" then
        self.shiftPressing = false
    end
end

function Player:draw()
    --love.graphics.print(self.rot, self.position.x, self.position.y)
    --love.graphics.print(t, self.position.x, self.position.y + 5)
    love.graphics.draw(self.sprite, self.position.x, self.position.y, self.rot, scale, scale, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
    --love.graphics.print("coords: "..self.position.x.." "..self.position.y, self.position.x, self.position.y)
    --love.graphics.print("Sprint: "..self.sprintAmount, self.position.x-10, self.position.y)
    --love.graphics.print("shiftPressing: "..tostring(self.shiftPressing), self.position.x-10, self.position.y+10)
end
