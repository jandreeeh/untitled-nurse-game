Injure = Object:extend()

local initInjuryRate
local injuryRate

local numOfInjured = 0
local numberOfHealthy = 0
local numberOfHealed = 0
local numberOfDead = 0

local maxInjured  
local keyStudent=1

function Injure:init(rate, min, value)
    initInjuryRate = rate
    injuryRate = rate
    numberOfHealthy = value
    maxInjured = min
end

function Injure:grab()
    return numberOfHealthy, numberOfHealed, numberOfDead
end

local function injure()
    StudentNPC[keyStudent].state = "injured"
    keyStudent = keyStudent + 1
    numberOfHealthy = numberOfHealthy - 1
end


function Injure:update(dt)
    if numberOfHealthy > maxInjured then
        injuryRate = injuryRate - dt
        if injuryRate <= 0 then
            injure()
            injuryRate = initInjuryRate
        end
    end 
    
        numOfInjured = 0

        numberOfHealed = 0
        numberOfDead = 0
    
        for i, v in ipairs(StudentNPC) do
            if v.state == "injured" then
                numOfInjured = numOfInjured + 1
            end
            if v.state == "healed" then
                numberOfHealed = numberOfHealed + 1
            end
            if v.state == "dead" then
                numberOfDead = numberOfDead + 1
            end
        end
end

function Injure:draw()
    love.graphics.print("Number of Walking: "..numberOfHealthy, 10, 40)
    love.graphics.print("Number of Injured: "..numOfInjured, 10, 50)
    love.graphics.print("Number of Healed: "..numberOfHealed, 10, 60)
    love.graphics.print("Number of Dead: "..numberOfDead, 10, 70)
end