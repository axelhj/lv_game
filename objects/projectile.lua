local projectile = {
  instance = {}
}

--[[
Cycles are {
  cycles = { frame_ind_1, frame_ind_2, ...},
  speed = speed_ms_frame_time,
}
]]--
function projectile.create(x, y, alpha)
  local instance = projectile.instance
  instance.ballistic = love.graphics.newImage("asset/ballistic.png")
  instance.x = x
  instance.y = y
  instance.alpha = alpha
  instance.speed = 300
  instance.elapsed_time = 0
  instance.quad = love.graphics.newQuad(
    10, 2, 47, 132,
    instance.ballistic:getWidth(),
    instance.ballistic:getHeight()
  )
  return projectile
end

function projectile:drop()
  self.instance = {}
end

function projectile:update(dt)
  local instance = self.instance
  instance.elapsed_time = instance.elapsed_time + (dt * 1000)
  if (instance.elapsed_time / 1000) > 4 then
    self.ballistic = nil
    return
  end
  instance.x = instance.x + math.cos(instance.alpha) * instance.speed * dt
  instance.y = instance.y + math.sin(instance.alpha) * instance.speed * dt
end

function projectile:draw()
  local instance = self.instance
  if instance.ballistic == nil then
    return
  end
  local quad = instance.quad
  love.graphics.draw(instance.ballistic, quad, instance.x, instance.y)
end

return projectile
