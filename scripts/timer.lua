Timer = Object:extend()


function Timer:new()
    self.time = 0 -- initial value in seconds
  end

  function Timer:reset()
    self.time = 0
  end
  
  function Timer:update( dt )
    self.time = self.time + dt -- make it count down
  end
  
  function Timer:draw()
  
    local minutes = math.floor( self.time / 60 ) -- calculate how many minutes are left
    local seconds = math.floor( self.time % 60 ) -- calculate how many seconds are left
    local milliseconds = self.time * 100 % 100 -- calculate how many milliseconds are left
  


    love.graphics.print( string.format("%02d:%02d.%02d",minutes,seconds,milliseconds), 15, 15 )
-- print it somewhere near the middle of the screen with proper formatting
  end
  