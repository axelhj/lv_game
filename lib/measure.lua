local m = {}

function m.measure_screen()
  return { w = love.graphics.getWidth(), h = love.graphics.getHeight() }
end

return m
