local menu = Gamestate.new()

require 'scripts.button'

local buttons = {Button("Play", 1, love.graphics.newImage('sprites/menu/play1.png'), love.graphics.newImage('sprites/menu/play2.png')),
                 Button("Quit", 2, love.graphics.newImage('sprites/menu/quit1.png'), love.graphics.newImage('sprites/menu/quit2.png'))}

local selcetedButtonIndex = 1
local selectedButton = buttons[selcetedButtonIndex]

local menuBG = love.graphics.newImage('sprites/menu/bg.png')
local bgx, bgy = 0, 0

local title = love.graphics.newImage('sprites/menu/title.png')

function menu:init()

end

local     valueX, valueY = -50, -75

function menu:update(dt)

    selectedButton = buttons[selcetedButtonIndex]

    --[[bgx = bgx + valueX * dt
    bgy = bgy + valueY * dt

    if bgx > -(love.graphics.getWidth() - (scale*menuBG:getWidth())) then
        valueX = -valueX
    end
    if bgx > 0 then
        valueX = -valueX
    end
    
    if bgy > -(love.graphics.getHeight() - (scale*menuBG:getHeight())) then
        valueY = -valueY
    end
    if bgy > 0 then
        valueY = -valueY
    end]]


end

local function drawButtons()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    local halfWidth = width / 2
    local halfHeight = height / 2

    for i, button in ipairs(buttons) do
        if i == selcetedButtonIndex then
            love.graphics.draw(button.imageOut, halfWidth, halfHeight +((halfHeight/(#buttons+1))*i), nil, 1.5, 1.5, button.imageOut:getWidth()/2, button.imageOut:getHeight()/2)
        else
            love.graphics.draw(button.image, halfWidth, halfHeight +((halfHeight/(#buttons+1))*i), nil, 1.5, 1.5, button.image:getWidth()/2, button.image:getHeight()/2)
        end
    end
end

function menu:draw()
    love.graphics.draw(menuBG, 0, 0, nil, scale, scale)
    love.graphics.draw(title, love.graphics.getWidth()/2, love.graphics.getHeight()/2 - 75
    , nil, scale, scale, title:getWidth()/2, title:getHeight()/2)

    drawButtons()

    --[[love.graphics.print(bgx, 10, 10)
    love.graphics.print(bgy, 10, 30)
    love.graphics.print(valueX, 10, 50)
    love.graphics.print(valueY, 10, 70)
    love.graphics.print(love.graphics.getWidth() - (scale*menuBG:getWidth()) , 10, 90)
    love.graphics.print(menuBG:getHeight() * scale, 10, 110)]]
end

function menu:keypressed(key)
    if key == 'up' then
        selcetedButtonIndex = selcetedButtonIndex - 1
        if selcetedButtonIndex < 1 then
            selcetedButtonIndex = #buttons
        end
    end
    if key == 'down' then
        selcetedButtonIndex = selcetedButtonIndex + 1
        if selcetedButtonIndex > #buttons then
            selcetedButtonIndex = 1
        end
    end
    if key == 'return' then
        if buttons[selcetedButtonIndex].id == 1 then
            Gamestate.switch(Game)
        elseif buttons[selcetedButtonIndex].id == 2 then
            love.event.quit()
        end
    end
end
return menu