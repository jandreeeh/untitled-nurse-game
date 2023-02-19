Shadow = Object:extend()

function Shadow:new(x, y, id, isPlayer)
    self.x = 0
    self.y = 0
    self.id = id
    self.isPlayer = isPlayer
    self.sprite = love.graphics.newImage('sprites/shadow.png')
end

function Shadow:update(dt)
    if self.isPlayer == false then   
    for i, v in ipairs(StudentNPC) do
        if v.id == self.id then
            self.x = v.position.x
            self.y = v.position.y
        end
    end
    else if self.isPlayer == true then
        self.x = player.position.x
        self.y = player.position.y
    end
    end
end

function Shadow:draw()
    love.graphics.draw(self.sprite, self.x, self.y+5, 0, scale, scale, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
end