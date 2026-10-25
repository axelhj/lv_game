local merge = require"lib.merge".merge

local player = {}

--[[
Cycles are {
  cycles = { frame_ind_1, frame_ind_2, ...},
  speed = speed_ms_frame_time,
}
]]--
function player:new(d, x, y)
  local sheet_animator = require("lib.sheet_animator")
  local new = require"lib.merge".merge({ d = d }, player)
  new.ballistic = require("objects.projectile")
  new.character = love.graphics.newImage("asset/sp_yellow_guy.png")
  new.bazooka = love.graphics.newImage("asset/sp_bazooka.png")
  new.x = x
  new.y = y
  new.speed = 70
  new.boost = 60
  new.bazooka_animation = sheet_animator:new(
    new.bazooka,
    26,
    8,
    { 1, 0, },
    300,
    0,
    0,
    false
  )
  new.character_animation = sheet_animator:new(
    new.character,
    26,
    26,
    { 0, 1, 2, 3, 4, 5, 6 },
    200,
    0,
    0,
    false
  )
  new.elapsed_time = 0
  new = setmetatable(merge({}, new), { __index = self })
  d:add("keypressed", function(key) new:keypressed(key) end)
  d:add("update", function(dt) new:update(dt) end)
  d:add("draw", function(_) new:draw() end)
  return new
end

function player:keypressed(key)
  if key == "space" then
    self.bazooka_animation:reset()
    self.ballistic:create(self.x + 24, self.y - 10, 6.28 - 1.57)
  end
end

function player:drop()
  -- self.d:remove("update", self)
  -- self.d:remove("draw", self)
end

function player:update(dt)
  self.elapsed_time = self.elapsed_time + (dt * 1000)
  local actual_speed = self.speed
  if love.keyboard.isDown("lshift") then
    actual_speed = actual_speed + self.boost
  end
  if love.keyboard.isDown("left") then
    self.x = self.x - actual_speed * dt
  elseif love.keyboard.isDown("right") then
    self.x = self.x + actual_speed * dt
  end
  if love.keyboard.isDown("up") then
    self.y = self.y - actual_speed * dt
  elseif love.keyboard.isDown("down") then
    self.y = self.y + actual_speed * dt
  end
  self.ballistic:update(dt)
end

function player:draw()
  local quad = self.character_animation:get_quad()
  love.graphics.draw(self.character, quad, self.x, self.y)
  self.ballistic:draw()
  quad = self.bazooka_animation:get_quad()
  love.graphics.draw(self.bazooka, quad, self.x, self.y - 28)
end

return player
