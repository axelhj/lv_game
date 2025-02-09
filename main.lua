io.stdout:setvbuf("no")
-- lume.serialize(x_data)
-- lume.deserialize(x_data)
-- love.filesystem.read("savedata.txt")
-- love.filesystem.write("savedata.txt", serialized)
-- love.graphics.translate(x, y)

local gun, character, speed, boost, x, y, sheet_animator

function love.load()
  gun = love.graphics.newImage("gun.png")
  -- gun_width = gun:getWidth()
  -- gun_height = gun:getHeight()
  character = love.graphics.newImage("character.png")
  speed = 40
  boost = 70
  x = 150
  y = 150
  sheet_animator = require("sheet_animator"):new(gun, 13, 13, { 0, 1, 2 }, 200, 0, 10)
end

function love.update(dt)
  sheet_animator:update(dt)
  local acceleration = speed
  if love.keyboard.isDown("lshift") then
    acceleration = acceleration + boost
  end
  if love.keyboard.isDown("left") then
    acceleration = -acceleration
  elseif not love.keyboard.isDown("right") then
    acceleration = 0
  end
  x = x + acceleration * dt
end

function love.keypressed(key)
  if key == "escape" then
    -- love.window.close()
    love.event.quit()
  end
end

function love.draw()
  love.graphics.draw(gun, 300, 200)
  love.graphics.draw(character, 200, 50)
  local quad = sheet_animator:get_quad(gun)
  love.graphics.draw(gun, quad, 20, 20)
  love.graphics.setColor(0.2, 0.6, 0)
  love.graphics.rectangle("line", x, y, 400, 40)
  love.graphics.setColor(0, 0.2, 0.6)
  love.graphics.print("Hello World!", x, y)
  love.graphics.setColor(1, 1, 1)
end
