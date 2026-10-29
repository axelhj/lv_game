io.stdout:setvbuf("no")
-- lume.serialize(x_data)
-- lume.deserialize(x_data)
-- love.filesystem.read("savedata.txt")
-- love.filesystem.write("savedata.txt", serialized)
-- love.graphics.translate(x, y)

local levels = {
  menu = require("level.menu"),
  first = require("level.level1"),
  second = require("level.level2")
}

local current_level = "menu"

function switch_level(level)
  current_level = level
  if not levels[current_level].loaded then
    local d = require("lib.dispatcher"):new()
    levels[current_level] = levels[current_level]:new(d)
    levels[current_level].loaded = true
    d:add("menu", switch_level)
    d:add("quit", function() love.event.quit() end)
  end
end

function love.load()
  switch_level(current_level)
end

function love.update(dt)
  levels[current_level].d:dispatch("update", dt)
end

function love.keypressed(key)
  if key == "escape" and current_level ~= "menu"  then
    levels[current_level].d:dispatch("menu", "menu")
  end
  levels[current_level].d:dispatch("keypressed", key)
end

function love.draw()
  levels[current_level].d:dispatch("draw", nil)
  -- if love.timer then love.timer.sleep(0.1) end
end
