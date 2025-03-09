local projectile = {
  instances = {},
  elapsed_time = 0
}

--[[
Cycles are {
  cycles = { frame_ind_1, frame_ind_2, ...},
  speed = speed_ms_frame_time,
}
]]--
function projectile:create(x, y, theta)
  if self.ballistic == nil then
    self.ballistic = love.graphics.newImage("asset/ballistic.png")
    self.quad = love.graphics.newQuad(
      10, 2, 47, 132,
      self.ballistic:getWidth(),
      self.ballistic:getHeight()
    )
  end
  local instance = {}
  instance.x = x
  instance.y = y
  instance.theta = theta
  instance.speed = 300
  instance.created_time = self.elapsed_time
  table.insert(self.instances, instance)
  return self
end

function projectile:drop()
  self.instances = {}
end

function projectile:update(dt)
  self.elapsed_time = self.elapsed_time + (dt * 1000)
  for i = #self.instances, 1, -1 do
    local instance = self.instances[i]
    if (self.elapsed_time - instance.created_time) / 1000 > 4 then
      table.remove(self.instances, i)
    end
    instance.x = instance.x + math.cos(instance.theta) * instance.speed * dt
    instance.y = instance.y + math.sin(instance.theta) * instance.speed * dt
  end
end

function projectile:draw()
  for i = 1, #self.instances do
    local instance = self.instances[i]
    love.graphics.draw(
      self.ballistic,
      self.quad,
      instance.x,
      instance.y,
      instance.angle,
      0.3
    )
  end
end

return projectile
