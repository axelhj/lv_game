local level = {
  loaded = false,
  d = nil,
}

local options = { "Level 1", "Level 2", "Quit" }
local actions = { "first", "second", "quit" }
local selected_ind = 1
local font

function level.load()
  font = love.graphics.newFont(36)
  -- grass = love.graphics.newImage("asset/sp_grass.png")
  -- character = require("objects.player"):create(200, 400)
  -- table.insert(updates, character)
  -- table.insert(updates, require("lib.sheet_animator"))
  -- table.insert(draws, character)
end

function level:update(dt)
end

function level:keypressed(key)
  if key == "k" or key == "up" then
    selected_ind = math.max(1, selected_ind - 1)
  elseif key == "j" or key == "down" then
    selected_ind = math.min(#options, selected_ind + 1)
  elseif key == "return" then
    if actions[selected_ind] == "quit" then
      self.d:dispatch("quit", nil)
    elseif actions[selected_ind] == "first" then
      self.d:dispatch("menu", "first")
    elseif actions[selected_ind] == "second" then
      self.d:dispatch("menu", "second")
    end
  end
end

function level:draw()
  local radius = 12
  local screen_size = { w = love.graphics.getWidth(), h = love.graphics.getHeight() }
  local center = { x = screen_size.w / 2, y = screen_size.h / 2 }
  local rel_size = { w = screen_size.w * 0.7, h = screen_size.h * 0.7 }
  love.graphics.setColor(0.2, 0.4, 0.2)
  love.graphics.rectangle("fill", center.x - rel_size.w / 2, center.y - rel_size.h / 2, rel_size.w, rel_size.h, radius)
  love.graphics.setColor(0.2, 0.6, 0.6)
  love.graphics.rectangle("line", center.x - rel_size.w / 2, center.y - rel_size.h / 2, rel_size.w, rel_size.h, radius)
  love.graphics.setFont(font)
  love.graphics.setColor(0.6, 0.6, 0.6)
  love.graphics.print("Welcome!", center.x - rel_size.w / 2, center.y - rel_size.h / 2 + 20)
  row_spacing = 50
  marker_spacing = 50
  for i, option in ipairs(options) do
    love.graphics.setColor(0.6, 0.6, 0.6)
    if i == selected_ind then
      love.graphics.setColor(0.05, 0.2, 0.05)
      love.graphics.print(
        ">",
        center.x - rel_size.w / 2,
        center.y - rel_size.h / 2 + 100 + (i - 1) * row_spacing)
    end
    love.graphics.print(
      option,
      center.x - rel_size.w / 2 + marker_spacing,
      center.y - rel_size.h / 2 + 100 + (i - 1) * row_spacing
    )
  end
  love.graphics.setColor(1, 1, 1)
end

 return level
