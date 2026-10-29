local copy_merge = require"lib.merge".copy_merge
local animator = require"lib.sheet_animator"

local level = {}

function level:new(d)
  local new = copy_merge(self, {
    d = d,
  })
  d:add("update", function(dt) new:update(dt) end)
  d:add("draw", function(_) new:draw() end)
  d:add("keypressed", function(key) new:keypressed(key) end)
  new.grass = love.graphics.newImage("asset/sp_grass.png")
  new.wall = love.graphics.newImage("asset/sp_wall.png")
  new.wall_blocks = {}
  new.character = require("objects.player"):new(d, 200, 450)
  new:build_buildings()
  return new
end

function level:build_buildings()
  self.wall_blocks = {
    { x = 100, y = 100, },
    { x = 135, y = 100, },
    { x = 170, y = 100, },
    { x = 205, y = 100, },
    { x = 240, y = 100, },
    { x = 275, y = 100, },
    { x = 310, y = 100, },
    { x = 345, y = 100, },
    { x = 380, y = 100, },
    { x = 380, y = 100, },
    { x = 100, y = 380, },
    { x = 135, y = 380, },
    { x = 170, y = 380, },
    { x = 205, y = 380, },
    { x = 240, y = 380, },
    { x = 275, y = 380, },
    { x = 100, y = 135, },
    { x = 100, y = 170, },
    { x = 100, y = 205, },
    { x = 100, y = 240, },
    { x = 100, y = 275, },
    { x = 100, y = 310, },
    { x = 100, y = 345, },
    { x = 380, y = 135, },
    { x = 380, y = 170, },
    { x = 380, y = 205, },
    { x = 380, y = 240, },
    { x = 380, y = 275, },
    { x = 380, y = 310, },
    { x = 380, y = 345, },
    { x = 380, y = 380, },
  }
end

function level:keypressed(key)
  self.character:keypressed(key)
end

function level:update(dt)
  animator:update(dt)
  self.character:update(dt)
end

function level:draw()
  local quad = love.graphics.newQuad(0, 0, 46, 38, 1024, 1024);
  local scale = 1;
  for x = 0, 17 do
    for y = 0, 16 do
      love.graphics.draw(self.grass, quad, x * 46 * scale, y * 38 * scale, 0, scale, scale)
    end
  end
  quad = love.graphics.newQuad(0, 0, 35, 35, 1024, 1024);
  for _, wall in pairs(self.wall_blocks) do
    love.graphics.draw(self.wall, quad, wall.x, wall.y, 0, scale, scale)
  end
  love.graphics.setColor(0.2, 0.6, 0)
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
