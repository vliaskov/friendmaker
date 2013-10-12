-- Tutorial 1: Hamster Ball
-- Add an image to the game and move it around using
-- the arrow keys.
-- compatible with löve 0.6.0 and up

numstrangers = 4
numitems = 8
stranger_mindist = 50
stranger_speed = 20
item_cycle = 3
item_random_stall = 3

function love.load()
   -- love.graphics.setMode(600, 600, false, false, 0)
   hamster = love.graphics.newImage("goblin.gif")
   stranger = love.graphics.newImage("peasant.jpg")
   princess = love.graphics.newImage("princess.jpg")
   flower = love.graphics.newImage("flower.jpg")
   boar = love.graphics.newImage("boar.png")
   x = 50
   y = 50
   speed = 200
   width = love.graphics.getWidth()
   height = love.graphics.getHeight()
   oldtime = os.time()
   math.randomseed( oldtime )

   local i
   strangers = {}
   for i=1,numstrangers,1 do
     strangers[i] = {}
     strangers[i].x = {}
     strangers[i].y = {}
     strangers[i].x = math.random(width)
     strangers[i].y = math.random(height)
     role = math.random(3)
     strangers[i].pic = {}
     if (role == 1) then
       strangers[i].pic = princess
     else
       strangers[i].pic = stranger
     end  
   end
   
   items = {}
   for i=1,numitems,1 do
     items[i] = {}
     items[i].x = {}
     items[i].y = {}
     items[i].x = math.random(width)
     items[i].y = math.random(height)
     role = math.random(3)
     items[i].pic = {}
     if (role == 1) then
       items[i].pic = flower
       items[i].visible = true
       items[i].onoff = true
       items[i].oldtime = oldtime
       items[i].stall = math.random(item_random_stall)
     else
       items[i].pic = boar
       items[i].visible = true
       items[i].onoff = false
     end  
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
   
   for i=1,numitems,1 do
       if (items[i].onoff) then
         newtime = os.time()
         if (newtime - items[i].oldtime > item_cycle + items[i].stall) then
           if (items[i].visible == false) then
             items[i].x = math.random(width)
             items[i].y = math.random(height)
             items[i].visible = true
             items[i].oldtime = newtime
             items[i].stall = math.random(item_random_stall)
           else
             items[i].visible = false
             items[i].oldtime = newtime
           end
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
    love.graphics.draw(strangers[i].pic, strangers[i].x, strangers[i].y, 0, 0.3, 0.3)
   end

   for i=1,numitems,1 do
    if (items[i].visible) then
      love.graphics.draw(items[i].pic, items[i].x, items[i].y, 0, 0.3, 0.3)
    end 
   end   
end



