-- Goblin - the friendmaker
-- compatible with löve 0.6.0 and up

numstrangers = 4
numitems = 8
stranger_mindist = 50
ontarget_mindist = 20
stranger_speed = 20
item_cycle = 3
item_random_stall = 4
entity_moverandom_duration = 1
entity_random_speed = 10

colorsRGB = {
  friendcolor = {240, 248, 255},
  antiquewhite = {250, 235, 215},
}

function love.load()
   -- love.graphics.setMode(600, 600, false, false, 0)
   goblin = love.graphics.newImage("goblin.gif")
   stranger = love.graphics.newImage("peasant.jpg")
   princess = love.graphics.newImage("princess.jpg")
   flower = love.graphics.newImage("flower.jpg")
   boar = love.graphics.newImage("boar.png")
   background = love.graphics.newImage("meadow.jpg")
   grave = love.graphics.newImage("rip.gif")

   happyfemale = love.audio.newSource("happy-female.wav", "static") 
   happymale = love.audio.newSource("happy-male.wav", "static") 
   maniaclaugh = love.audio.newSource("maniac-laugh.wav", "static") 
   sadmale = love.audio.newSource("sad-male.wav", "static") 
   pop = love.audio.newSource("pop.wav", "static") 
   scream = love.audio.newSource("scream.wav", "static") 
   music = love.audio.newSource("POL-deep-emerald-short.wav")
   love.audio.play(music)

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
     strangers[i].isfriend = false
     strangers[i].dead = false
     role = math.random(3)
     strangers[i].pic = {}
     if (role == 1) then
       strangers[i].pic = princess
     else
       strangers[i].pic = stranger
     strangers[i].oldtime = oldtime
     strangers[i].stall = math.random(item_random_stall)
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
     items[i].oldtime = oldtime
     if (role == 1) then
       items[i].pic = flower
       items[i].visible = true
       items[i].onoff = true
       items[i].stall = math.random(item_random_stall)
       items[i].canpick = true
       items[i].picked = false
     else
       items[i].pic = boar
       items[i].visible = true
       items[i].onoff = false
       items[i].automove = true
       items[i].canpick = false
       items[i].stall = math.random(item_random_stall)
     end  
   end
end

interact_matrix = {
    boar, peasant, kill
}

function kill(a, b)
    b.pic = grave
    b.dead = true 
    love.audio.play(scream); 
end

function interact (a, b)
   inter=true
--   kill(a,b) 
--   interact_matrix[2](a, b)
--   for i=1,3,1 do
----    if (interact_matrix[i][1] == a.pic and interact_matrix[i][2] == b.pic) then
--      interact_matrix[i][3](a, b)
--    break
--    end
--   end
end

function use_item(item)
   if (item) then  
   for i=1,numstrangers,1 do
     if ( (math.abs(x - strangers[i].x) < 4*stranger_mindist) and (math.abs(y - strangers[i].y) < 4*stranger_mindist)) then
       if (item.pic == flower and strangers[i].pic == princess) then
         strangers[i].isfriend = true
         love.graphics.setColor(0, 0, 255)
         love.audio.play(happyfemale)
         inventory = nil
       end
       if (item.pic == flower and strangers[i].pic == male) then
         love.graphics.setColor(0, 255, 255)
         love.audio.play(sadmale)
       end
     end
   end
   end
end

function drop_item(item)
     if (item) then
       item.visible = true
       item.picked = false
       item.x = x
       item.y = y
       inventory = nil
       item.oldtime = os.time()
     end
end

function get_item()
   for i=1,numitems,1 do
     if ((items[i].picked == false) and (math.abs(x - items[i].x) < 20) and (math.abs(y - items[i].y) < 20)) then
       if (items[i].canpick == true) then
        items[i].picked = true
        items[i].visible = false
        if (inventory) then
         drop_item(inventory)
        end
        inventory = items[i]
        love.audio.play(pop)
       end
     end    
     if ((items[i].picked == true)) then
       items[i].x = x
       items[i].y = y
     end   
   end
end

function automove(entity)
   newtime = os.time()
   if (newtime - entity.oldtime > item_cycle + entity.stall) then
      if (entity.moving == false) then
             entity.dir = math.random(4)
             entity.oldtime = newtime
             entity.stall = math.random(item_random_stall)
             entity.moving = true
      else
             entity.moving = false
             entity.oldtime = newtime
      end
  elseif (entity.moving == true) then
    if (newtime - entity.oldtime > entity_moverandom_duration) then
      entity.moving = false
    elseif (entity.dir == 1) then
      entity.x = entity.x + entity_random_speed
    elseif (entity.dir == 2) then
      entity.x = entity.x - entity_random_speed
    elseif (entity.dir == 3) then
      entity.y = entity.y + entity_random_speed
    else
      entity.y = entity.y - entity_random_speed
    end  
  end
end




function love.update(dt)
   for i=1,numstrangers,1 do
     for j=1,numitems,1 do
       if ((math.abs(items[j].x - strangers[i].x) < ontarget_mindist) and (math.abs(items[j].y - strangers[i].y) < ontarget_mindist)) then
         interact(items[j], strangers[i]);   
       end
     end
     strangers[i].runningaway = false
     if (strangers[i].dead == false and (math.abs(x - strangers[i].x) <stranger_mindist) and (math.abs(y - strangers[i].y) < stranger_mindist)) then
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
        strangers[i].runningaway = true
     end    
   end
   
   for i=1,numitems,1 do
       if (items[i].onoff and (items[i].picked == false)) then
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
       if (items[i].automove == true) then
        automove(items[i])
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
   if love.keyboard.isDown(" ") then
      use_item(inventory)
   end
   if love.keyboard.isDown("d") then
      drop_item(inventory)
   end
   if love.keyboard.isDown("s") then
      get_item()
   end
end

function love.draw()
   -- love.graphics.draw(background, 0, 0)
   if (inter ==true) then love.graphics.print("interact", 10, 10) end
   love.graphics.draw(goblin, x, y)
   for i=1,numstrangers,1 do
    love.graphics.draw(strangers[i].pic, strangers[i].x, strangers[i].y, 0, 0.3, 0.3)
   end

   for i=1,numitems,1 do
    if (items[i].visible) then
      love.graphics.draw(items[i].pic, items[i].x, items[i].y, 0, 0.3, 0.3)
    end 
   end   
end



