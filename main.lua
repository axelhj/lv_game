io.stdout:setvbuf("no")
-- lume.serialize(x_data)
-- lume.deserialize(x_data)
-- love.filesystem.read("savedata.txt")
-- love.filesystem.write("savedata.txt", serialized)
-- love.graphics.translate(x, y)

local gun, gun_animation, character, speed, boost, x, y, sheet_animator, grass, character_animation

function love.load()
  gun = love.graphics.newImage("gun.png")
  grass = love.graphics.newImage("grass.png")
  -- gun_width = gun:getWidth()
  -- gun_height = gun:getHeight()
  character = love.graphics.newImage("yellow_guy.png")
  speed = 40
  boost = 70
  x = 150
  y = 150
  sheet_animator = require("sheet_animator")
  character_animation = sheet_animator:create(
    character,
    26,
    26,
    { 0, 1, 2, 3, 4, 5, 6 },
    200,
    0,
    0
  )
  gun_animation = sheet_animator:create(
    gun,
    13,
    13,
    { 0, 1, 2 },
    200,
    1,
    12
  )
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
  local quad = love.graphics.newQuad(0, 0, 46, 38, 1024, 1024)
  local scale = 1
  for x = 0, 16 do
    for y = 0, 16 do
      love.graphics.draw(grass, quad, x * 46 * scale, y * 38 * scale, 0, scale, scale)
    end
  end
  love.graphics.draw(gun, 300, 200)
  love.graphics.draw(character, 200, 50)
  local quad = gun_animation:get_quad()
  love.graphics.draw(gun, quad, 20, 20)
  quad = character_animation:get_quad()
  love.graphics.draw(character, quad, 80, 80)
  love.graphics.setColor(0.2, 0.6, 0)
  love.graphics.rectangle("line", x, y, 400, 40)
  love.graphics.setColor(0, 0.2, 0.6)
  love.graphics.print("Hello World!", x, y)
  love.graphics.setColor(1, 1, 1)
end
