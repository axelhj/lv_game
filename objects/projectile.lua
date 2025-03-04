local projectile = {
  instance = {}
}

--[[
Cycles are {
  cycles = { frame_ind_1, frame_ind_2, ...},
  speed = speed_ms_frame_time,
}
]]--
function projectile.create(x, y)
  local instance = {}
  sheet_animator = require("sheet_animator")
  instance.character = love.graphics.newImage("asset/yellow_guy.png")
  instance.bazooka = love.graphics.newImage("asset/bazooka.png")
  instance.x = x
  instance.y = y
  instance.speed = 70
  instance.boost = 60
  instance.bazooka_animation = sheet_animator:create(
    instance.bazooka,
    26,
    8,
    { 0, 1 },
    800,
    0,
    0
  )
  instance.character_animation = sheet_animator:create(
    instance.character,
    26,
    26,
    { 0, 1, 2, 3, 4, 5, 6 },
    200,
    0,
    0
  )
  instance.elapsed_time = 0
  projectile.instance = instance
  return projectile
end

function projectile:drop()
  self.instance = {}
end

function projectile:update(dt)
  local instance = self.instance
  instance.elapsed_time = instance.elapsed_time + (dt * 1000)
  local actual_speed = instance.speed
  instance.y = instance.y - actual_speed * dt
end

function projectile:draw()
  local instance = self.instance
  local quad = instance.character_animation:get_quad()
  love.graphics.draw(instance.character, quad, instance.x, instance.y)
  quad = instance.bazooka_animation:get_quad()
  love.graphics.draw(instance.bazooka, quad, instance.x, instance.y - 28)
end

return projectile
