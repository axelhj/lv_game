io.stdout:setvbuf("no")
-- lume.serialize(x_data)
-- lume.deserialize(x_data)
-- love.filesystem.read("savedata.txt")
-- love.filesystem.write("savedata.txt", serialized)
-- love.graphics.translate(x, y)

local character, sheet_animator, grass

function love.load()
  grass = love.graphics.newImage("asset/grass.png")
  character = require("objects.player").create(150, 150)
  sheet_animator = require("sheet_animator")
end

function love.update(dt)
  sheet_animator:update(dt)
  character:update(dt)
end

function love.keypressed(key)
  if key == "escape" then
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
  -- love.graphics.draw(gun, 300, 200)
  character:draw()
  -- quad = gun_animation:get_quad()
  -- love.graphics.draw(gun, quad, 20, 20)
  love.graphics.setColor(0.2, 0.6, 0)
  -- love.graphics.rectangle("line", x, y, 400, 40)
  love.graphics.setColor(0, 0.2, 0.6)
  -- love.graphics.print("Hello World!", x, y)
  love.graphics.setColor(1, 1, 1)
end
