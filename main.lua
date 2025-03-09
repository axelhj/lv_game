io.stdout:setvbuf("no")
-- lume.serialize(x_data)
-- lume.deserialize(x_data)
-- love.filesystem.read("savedata.txt")
-- love.filesystem.write("savedata.txt", serialized)
-- love.graphics.translate(x, y)

local character, updates, draws, grass
updates = {}
draws = {}

function love.load()
  grass = love.graphics.newImage("asset/grass.png")
  character = require("objects.player"):create(200, 400)
  local pig = require("objects.sprite"):create(150, 250, "pig", {
    scale = 1.5,
    speed = 40,
    theta = math.pi * (1.05),
    angle = math.pi,
    appear_at = 3,
    disappear_at = 6,
    offset_start_x = 3,
    offset_start_y = 10,
    offset_end_x = 33,
    offset_end_y = 25,
  })
  local meat_a = require("objects.sprite"):create(35, 250, "gibs", {
    scale = 0.7,
    angle = math.pi / 3,
    appear_at = 6,
    disappear_at = 18,
    offset_start_x = 35,
    offset_start_y = 8,
    offset_end_x = 63,
    offset_end_y = 33,
  })
  local meat_b = require("objects.sprite"):create(75, 250, "gibs", {
    scale = 0.7,
    angle = math.pi / 3,
    appear_at = 6,
    disappear_at = 18,
    offset_start_x = 0,
    offset_start_y = 0,
    offset_end_x = 27,
    offset_end_y = 24,
  })
  local meat_c = require("objects.sprite"):create(50, 220, "gibs", {
    scale = 0.7,
    appear_at = 7,
    disappear_at = 20,
    offset_start_x = 12,
    offset_start_y = 38,
    offset_end_x = 25,
    offset_end_y = 50,
  })
  table.insert(updates, character)
  table.insert(updates, pig)
  table.insert(updates, meat_a)
  table.insert(updates, meat_b)
  table.insert(updates, meat_c)
  table.insert(updates, require("lib.sheet_animator"))
  table.insert(draws, character)
  table.insert(draws, pig)
  table.insert(draws, meat_a)
  table.insert(draws, meat_b)
  table.insert(draws, meat_c)
end

function love.update(dt)
  for _, update in ipairs(updates) do
    update:update(dt)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  character:keypressed(key)
end

function love.draw()
  local quad = love.graphics.newQuad(0, 0, 46, 38, 1024, 1024)
  local scale = 1
  for x = 0, 17 do
    for y = 0, 16 do
      love.graphics.draw(grass, quad, x * 46 * scale, y * 38 * scale, 0, scale, scale)
    end
  end
  for _, draw in ipairs(draws) do
    draw:draw()
  end
  -- love.graphics.draw(gun, 300, 200)
  -- quad = gun_animation:get_quad()
  -- love.graphics.draw(gun, quad, 20, 20)
  love.graphics.setColor(0.2, 0.6, 0)
  -- love.graphics.rectangle("line", x, y, 400, 40)
  love.graphics.setColor(0, 0.2, 0.6)
  -- love.graphics.print("Hello World!", x, y)
  love.graphics.setColor(1, 1, 1)
end
