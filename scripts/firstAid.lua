FirstAid = Object:extend()

require 'scripts.tools'


function FirstAid:new()
    self.aidKit = {Tool("Bandage", 1, nil, love.graphics.newImage("sprites/tools/band.png"), love.graphics.newImage("sprites/tools/bandOut.png")),
                    Tool("Painkillers", 2, nil, love.graphics.newImage("sprites/tools/pain.png"), love.graphics.newImage("sprites/tools/painOut.png")),
                    Tool("Ice Pack", 3, nil, love.graphics.newImage("sprites/tools/ice.png"), love.graphics.newImage("sprites/tools/iceOut.png")),
                    Tool("Water Bottle", 4, nil, love.graphics.newImage("sprites/tools/water.png"), love.graphics.newImage("sprites/tools/waterOut.png")),
                    Tool("CPR", 5, nil, love.graphics.newImage("sprites/tools/cpr.png"), love.graphics.newImage("sprites/tools/cprOut.png"))}
    --[[self.aidKit.bandage = Tool("Bandage")
    self.aidKit.painKiller = Tool("Painkillers")
    self.aidKit.icePack = Tool("Ice Pack")
    self.aidKit.waterBottle = Tool("Water Bottle")
    self.aidKit.cpr = Tool("CPR")]]
    
    self.currentSelectedIndex = 1
    self.currentSelectedTool = self.aidKit[self.currentSelectedIndex]

    self.HasFactor = false
    self.effect = nil
    self.sypmtom = nil
    self.AidingNow = false
    self.bodyTimer = 0

    self.numAttempts = 3

    self.doneAiding = false
    self.effectDone = false

    self.studentID = nil

    self.tintScreen = love.graphics.newImage("sprites/ui/tint.png")
    self.mainScreen = love.graphics.newImage('sprites/ui/mainScreen.png')
    self.timerBar = love.graphics.newImage('sprites/ui/bodyTimer.png')
    self.redBar = love.graphics.newImage('sprites/ui/redBar.png')
    self.greenBar = love.graphics.newImage('sprites/ui/greenBar.png')
    self.mainScreen = love.graphics.newImage('sprites/ui/mainScreen.png')
    self.conditionScreen = love.graphics.newImage('sprites/ui/conditionScreen.png')
    self.strikeScreen = {}
    self.strikeScreen.blank = love.graphics.newImage('sprites/ui/strike1.png')
    self.strikeScreen.one = love.graphics.newImage('sprites/ui/strike2.png')
    self.strikeScreen.two = love.graphics.newImage('sprites/ui/strike3.png')
    self.strikeScreen.three = love.graphics.newImage('sprites/ui/strike4.png')
    self.currentStrike = self.strikeScreen.blank
    self.aidinToolsScreen = love.graphics.newImage('sprites/ui/aidinTools.png')
end

function FirstAid:grab(symp, eff, id)
    self.sypmtom = symp
    self.effect = eff
    self.studentID = id
    
    self.doneAiding = false
    self.effectDone = false
    self.numAttempts = 3

end

function FirstAid:aidNoEffect()
    if self.sypmtom.id == self.currentSelectedTool.id then
        self.doneAiding = true
    else
        self.numAttempts = self.numAttempts - 1
    end
end

function FirstAid:aidWithEffect()
    if self.effectDone == false then
        if self.effect.id == self.currentSelectedTool.id then
            self.effectDone = true
            print("Has effect, done effect")
        else
            self.numAttempts = self.numAttempts - 1
            print("Has effect, wrong tool")
        end
    else if self.effectDone == true then
        if self.sypmtom.id == self.currentSelectedTool.id then
            self.doneAiding = true
            print("Has effect, done effect, done symptom")
        else
            self.numAttempts = self.numAttempts - 1
        end
    end
end
end






function FirstAid:update(dt)
    self.currentSelectedTool = self.aidKit[self.currentSelectedIndex]   
    for i, v in ipairs(StudentNPC) do
        if v.id == self.studentID then
            self.bodyTimer = v.normalizeTimer
            if self.numAttempts <= 0 then
                v.state = "dead"
                self:endTurn(0.5, dt)
            end
        end
    end

    if self.numAttempts == 3 then
        self.currentStrike = self.strikeScreen.blank
    elseif self.numAttempts == 2 then
        self.currentStrike = self.strikeScreen.one
    elseif self.numAttempts == 1 then
        self.currentStrike = self.strikeScreen.two
    elseif self.numAttempts == 0 then
        self.currentStrike = self.strikeScreen.three
    end

    if self.doneAiding then
        self:endTurn(0.5, dt)
        for i, v in ipairs(StudentNPC) do
            if v.id == self.studentID then
                v.state = "healed"
            
            end
        end
    end



end

function FirstAid:keyreleased(key)
    if key == "right" then
        self.currentSelectedIndex = self.currentSelectedIndex + 1
        if self.currentSelectedIndex > #self.aidKit then
            self.currentSelectedIndex = #self.aidKit
        end
    end
    if key == "left" then
        self.currentSelectedIndex = self.currentSelectedIndex - 1
        if self.currentSelectedIndex < 1 then
            self.currentSelectedIndex = 1
        end
    end 
    if key == "up" and self.effect.isEffect == false then
            self:aidNoEffect()
    else if key == "up" and self.effect.isEffect == true then
            self:aidWithEffect()
        end
    end
end

local height = love.graphics.getHeight()

local HUDy = {
alpha = 0,
mainScreenY = 22 + height,
conditionScreenY = 44 + height,
strikeY = 188 + height,
aidinToolsY = 248 + height,
toolsY = 295 + height,
barY = 22 + height,
greenBarY = 235 + height}

local initHUDy = {
initAlpha = 255,
initMainScreenY = 22,
initConditionScreenY = 44,
initStrikeY = 188,
initAidinToolsY = 248,
initToolsY = 295,
initBarY = 22,
initGreenBarY = 235}



function FirstAid:called()
    GameMode = 1
    flux.to(HUDy, .5, {alpha = 225}):ease('cubicout')
    flux.to(HUDy, .5, {mainScreenY = initHUDy.initMainScreenY}):ease('cubicout')
    flux.to(HUDy, .5, {conditionScreenY = initHUDy.initConditionScreenY}):ease('cubicout')
    flux.to(HUDy, .5, {strikeY = initHUDy.initStrikeY}):ease('cubicout')
    flux.to(HUDy, .5, {aidinToolsY = initHUDy.initAidinToolsY}):ease('cubicout')
    flux.to(HUDy, .5, {toolsY = initHUDy.initToolsY}):ease('cubicout')
    flux.to(HUDy, .5, {barY = initHUDy.initBarY}):ease('cubicout')
    flux.to(HUDy, .5, {greenBarY = initHUDy.initGreenBarY}):ease('cubicout')
end

function FirstAid:endTurn(t, dt)
    flux.to(HUDy, .5, {alpha = 0}):ease('cubicin')
    flux.to(HUDy, .5, {mainScreenY = 22 + height}):ease('cubicin')
    flux.to(HUDy, .5, {conditionScreenY = 44 + height}):ease('cubicin')
    flux.to(HUDy, .5, {strikeY = 188 + height}):ease('cubicin')
    flux.to(HUDy, .5, {aidinToolsY = 248 + height}):ease('cubicin')
    flux.to(HUDy, .5, {toolsY = 295 + height}):ease('cubicin')
    flux.to(HUDy, .5, {barY = 22 + height}):ease('cubicin')
    flux.to(HUDy, .5, {greenBarY = 235 + height}):ease('cubicin')

    --t = t - dt
    --if t <= 0 then
        GameMode = 0
   -- end
end



function FirstAid:drawAidkit()
    local x1 = 118
    local x2 = 521
    local width = x2 - x1

    for i =1, #self.aidKit do
        if i == self.currentSelectedIndex then
            love.graphics.draw(self.aidKit[i].iconOut, x1 +(width/(#self.aidKit + 1)) * i, HUDy.toolsY, 
            0, scale, scale,self.aidKit[i].iconOut:getWidth()/2, self.aidKit[i].iconOut:getHeight()/2)
        else
            love.graphics.draw(self.aidKit[i].icon, x1 + (width/(#self.aidKit + 1)) * i, HUDy.toolsY, 
            0, scale, scale,self.aidKit[i].icon:getWidth()/2, self.aidKit[i].icon:getHeight()/2)
        end
    end
end

function FirstAid:draw()

    love.graphics.setColor(255, 255, 255, HUDy.alpha)
    love.graphics.draw(self.tintScreen, 0, 0, 0, scale, scale)
    love.graphics.setColor(255,255,255,255)

    love.graphics.draw(self.mainScreen, 36, HUDy.mainScreenY, 0, scale, scale)

    love.graphics.draw(self.sypmtom.icon, 58, HUDy.conditionScreenY, 0, scale, scale)
    love.graphics.draw(self.conditionScreen, 58, HUDy.conditionScreenY, 0, scale, scale)
    if self.effect.isEffect == true then
        if self.effectDone == false then
            love.graphics.draw(self.effect.icon, 58, HUDy.conditionScreenY, 0, scale, scale)
        end
    end

    love.graphics.draw(self.currentStrike, 286, HUDy.strikeY, 0, scale, scale)

    love.graphics.draw(self.aidinToolsScreen, 36, HUDy.aidinToolsY, 0, scale, scale)
    self:drawAidkit()

    love.graphics.draw(self.redBar, 244, HUDy.barY, 0, scale, scale)
    love.graphics.draw(self.greenBar, 244, HUDy.greenBarY, 0, scale, scale * self.bodyTimer, 0, self.greenBar:getHeight())
    love.graphics.draw(self.timerBar, 244, HUDy.barY, 0, scale, scale)


end