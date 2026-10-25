local rectangle = require"lib.rectangle"
local copy_merge = require"lib.merge".copy_merge
local animator = require"lib.sheet_animator"

local level = {}

function level:new(d)
  local new = copy_merge(self, {
    d = d,
  })
  d:add("keypressed", function(key) new:keypressed(key) end)
  d:add("update", function(dt) new:update(dt) end)
  d:add("draw", function(_) new:draw() end)
  require("objects.sprite"):new(d, 150, 250, "pig", {
    scale = 1.5,
    speed = 40,
    movement_angle = math.pi * (1.05),
    display_angle = math.pi,
    appear_at_s = 3,
    disappear_after_s = 6,
    offset = rectangle:new(3, 10, 33, 25)
  })
  require("objects.sprite"):new(d, 35, 250, "gibs", {
    scale = 0.7,
    display_angle = math.pi / 3,
    appear_at_s = 6,
    disappear_after_s = 18,
    offset = rectangle:new(35, 8, 63, 33),
  })
  require("objects.sprite"):new(d, 75, 250, "gibs", {
    scale = 0.7,
    display_angle = math.pi / 3,
    appear_at_s = 6,
    disappear_after_s = 18,
    offset = rectangle:new(0, 0, 27, 24)
  })
  require("objects.sprite"):new(d, 50, 220, "gibs", {
    scale = 0.7,
    appear_at_s = 7,
    disappear_after_s = 20,
    offset = rectangle:new(12, 38, 25, 50),
  })
  new.character = require("objects.player"):new(d, 200, 400)
  new.grass = love.graphics.newImage("asset/sp_grass.png")
  return new
end

function level:keypressed(key)
end

function level:update(dt)
  animator:update(dt)
end

function level:draw()
  local quad = love.graphics.newQuad(0, 0, 46, 38, 1024, 1024)
  local scale = 1
  for x = 0, 17 do
    for y = 0, 16 do
      love.graphics.draw(self.grass, quad, x * 46 * scale, y * 38 * scale, 0, scale, scale)
    end
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

return level
