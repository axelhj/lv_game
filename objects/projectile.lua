local rectangle = require"lib.rectangle"
local measure_screen = require"lib.measure".measure_screen
local merge = require"lib.merge".merge

local projectile = {}

function projectile:new(d, x, y, movement_angle)
  if self.ballistic == nil then
    self.ballistic = love.graphics.newImage("asset/sp_ballistic.png")
    self.w = self.ballistic:getWidth()
    self.h = self.ballistic:getHeight()
    self.quad = love.graphics.newQuad(
      10, 2, 47, 132,
      self.w,
      self.h
    )
    local screen_size = measure_screen()
    self.bounds = rectangle:new(0, 0, screen_size.w, screen_size.h)
  end
  local new = merge({
    d = d,
    x = x,
    y = y,
    movement_angle = movement_angle,
    display_angle = movement_angle - math.pi / -2,
    -- display_angle = movement_angle,
    speed = 300,
    elapsed_time = 0,
  }, self)
  new.update_event = d:add("update", function(dt) new:update(dt) end)
  new.draw_event = d:add("draw", function() new:draw() end)
  return new
end

function projectile:drop()
  self.d:remove_id("update", self.update_event)
  self.d:remove_id("draw", self.draw_event)
end

function projectile:update(dt)
  self.elapsed_time = self.elapsed_time + (dt * 1000)
  if --self.elapsed_time / 1000 > 4 or
    not self.bounds:intersects(rectangle:new(self.x - 40, self.y - 40, self.w * 3, self.h * 3))
  then
    self:drop()
  else
    self.x = self.x + math.cos(self.movement_angle) * self.speed * dt
    self.y = self.y + math.sin(self.movement_angle) * self.speed * dt
  end
end

function projectile:draw()
  love.graphics.draw(
    self.ballistic,
    self.quad,
    self.x,
    self.y,
    self.display_angle,
    0.3
  )
end

return projectile
