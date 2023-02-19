pointer = {}

local arrow
local arrowHalfW, arrowHalfH

local playerX, playerY
local studentX, studentY
local isStudentOff = false
local arrowPosX, arrowPosY

function pointer.load(x, y)
    playerX, playerY = player.position.x, player.position.y
    studentX, studentY = x, y
    print(0/0 > 1)
    arrow = love.graphics.newImage('sprites/small-arrow.png')
    arrowHalfW = arrow:getWidth() / 2
    arrowHalfH = arrow:getHeight() / 2
end

function pointer.update(dt)
  playerX, playerY = player.position.x, player.position.y
end

function pointer.draw()
  local angle = math.atan2(playerY - studentY, playerX - studentX)
  love.graphics.draw(arrow, playerX, playerY, angle, 1, 1, -15, arrowHalfH)
end

