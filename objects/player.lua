local player = {
  instance = {}
}

--[[
Cycles are {
  cycles = { frame_ind_1, frame_ind_2, ...},
  speed = speed_ms_frame_time,
}
]]--
function player.create(x, y)
  local instance = {}
  local sheet_animator = require("lib.sheet_animator")
  instance.ballistic = require("objects.projectile").create(200, 200, 6.28 - 1.57)
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
    { 0, 1, 0, 1 },
    800,
    0,
    0,
    false
  )
  instance.character_animation = sheet_animator:create(
    instance.character,
    26,
    26,
    { 0, 1, 2, 3, 4, 5, 6 },
    200,
    0,
    0,
    false
  )
  instance.elapsed_time = 0
  player.instance = instance
  return player
end

function player:drop()
  self.instance = {}
end

function player:update(dt)
  local instance = self.instance
  instance.elapsed_time = instance.elapsed_time + (dt * 1000)
  local actual_speed = instance.speed
  if love.keyboard.isDown("lshift") then
    actual_speed = actual_speed + instance.boost
  end
  if love.keyboard.isDown("left") then
    instance.x = instance.x - actual_speed * dt
  elseif love.keyboard.isDown("right") then
    instance.x = instance.x + actual_speed * dt
  end
  if love.keyboard.isDown("up") then
    instance.y = instance.y - actual_speed * dt
  elseif love.keyboard.isDown("down") then
    instance.y = instance.y + actual_speed * dt
  end
  instance.ballistic:update(dt)
end

function player:draw()
  local instance = self.instance
  local quad = instance.character_animation:get_quad()
  love.graphics.draw(instance.character, quad, instance.x, instance.y)
  quad = instance.bazooka_animation:get_quad()
  love.graphics.draw(instance.bazooka, quad, instance.x, instance.y - 28)
  instance.ballistic.draw(instance.ballistic)
end

return player
