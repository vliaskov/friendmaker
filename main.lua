-- Tutorial 1: Hamster Ball
-- Add an image to the game and move it around using
-- the arrow keys.
-- compatible with löve 0.6.0 and up
numstrangers = 4
stranger_mindist = 50
stranger_speed = 20
function love.load()
   -- love.graphics.setMode(600, 600, false, false, 0)
   hamster = love.graphics.newImage("goblin.gif")
   stranger = love.graphics.newImage("peasant.jpg")
   x = 50
   y = 50
   speed = 200
   width = love.graphics.getWidth()
   height = love.graphics.getHeight()
   math.randomseed( os.time() )
   local i
   strangers = {}
   for i=1,numstrangers,1 do
     strangers[i] = {}
     strangers[i].x = {}
     strangers[i].y = {}
     strangers[i].x = math.random(width)
     strangers[i].y = math.random(height)
   end
end

function love.update(dt)
   for i=1,numstrangers,1 do
     if ((math.abs(x - strangers[i].x) <stranger_mindist) and (math.abs(y - strangers[i].y) < stranger_mindist)) then
        if ( (strangers[i].x > x) and (strangers[i].x < width - stranger_speed) ) then
          strangers[i].x = strangers[i].x + stranger_speed
        elseif ( (strangers[i].x < x) and (strangers[i].x > stranger_speed) ) then
          strangers[i].x = strangers[i].x - stranger_speed
        end
     if ( (strangers[i].y > y) and (strangers[i].y < height - stranger_speed) ) then
          strangers[i].y = strangers[i].y + stranger_speed
        elseif ( (strangers[i].y < y) and (strangers[i].y > stranger_speed) ) then
          strangers[i].y = strangers[i].y - stranger_speed
        end
     end    
   end

   if love.keyboard.isDown("right") then
      x = x + (speed * dt)
   end
   if love.keyboard.isDown("left") then
      x = x - (speed * dt)
   end

   if love.keyboard.isDown("down") then
      y = y + (speed * dt)
   end
   if love.keyboard.isDown("up") then
      y = y - (speed * dt)
   end
end

function love.draw()
   love.graphics.draw(hamster, x, y)
   for i=1,numstrangers,1 do
    love.graphics.draw(stranger, strangers[i].x, strangers[i].y, 0, 0.3, 0.3)
   end
end



