local level = {
  loaded = false,
  d = nil,
}

local updates = {}
local draws = {}
local character, grass

function level:load()
  grass = love.graphics.newImage("asset/sp_grass.png")
  character = require("objects.player"):create(200, 400)
  table.insert(updates, character)
  table.insert(updates, require("lib.sheet_animator"))
  table.insert(draws, character)
end

function level:update(dt)
  for _, update in ipairs(updates) do
    update:update(dt)
  end
end

function level:keypressed(key)
  character:keypressed(key)
end

function level:draw()
  local quad = love.graphics.newQuad(0, 0, 46, 38, 1024, 1024);
  local scale = 1;
  for x = 0, 17 do
    for y = 0, 16 do
      love.graphics.draw(grass, quad, x * 46 * scale, y * 38 * scale, 0, scale, scale)
    end
  end
  for _, draw in ipairs(draws) do
    draw:draw()
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
