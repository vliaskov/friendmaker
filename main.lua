-- Tutorial 1: Hamster Ball
-- Add an image to the game and move it around using
-- the arrow keys.
-- compatible with löve 0.6.0 and up

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
   for i=1,4,1 do
     strangers[i] = {}
     strangers[i].x = {}
     strangers[i].y = {}
     strangers[i].x = math.random(width)
     strangers[i].y = math.random(height)
   end
end

function love.update(dt)
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
   if love.keyboard.isDown("space") then
      y = y - (speed * dt)
   end
end

function love.draw()
   love.graphics.draw(hamster, x, y)
   for i=1,4,1 do
    love.graphics.draw(stranger, strangers[i].x, strangers[i].y, 0, 0.3, 0.3)
   end
end



