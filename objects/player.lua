local merge = require"lib.merge".merge
local vec2 = require"lib.vector"
local ballistic = require("objects.projectile")

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
  new.angle = 0
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
  self.keypressed_event = d:add("keypressed", function(key) new:keypressed(key) end)
  self.update_event = d:add("update", function(dt) new:update(dt) end)
  self.draw_event = d:add("draw", function(_) new:draw() end)
  return new
end

function player:keypressed(key)
  if key == "space" then
    self.bazooka_animation:reset()
    local origin_pos = vec2:new(self.x + 4, self.y - 26):rotate(
      vec2:new(self.x, self.y),
      self.angle
    )
    ballistic:new(self.d, origin_pos.x, origin_pos.y, 6.28 - 1.57 + self.angle)
  end
end

function player:drop()
  self.d:remove_id("keypressed", self.keypressed_event)
  self.d:remove_id("update", self.update_event)
  self.d:remove_id("draw", self.draw_event)
end

function player:update(dt)
  self.elapsed_time = self.elapsed_time + (dt * 1000)
  local actual_speed = self.speed
  local turn_speed = math.pi * 0.5
  if love.keyboard.isDown("lshift") then
    actual_speed = actual_speed + self.boost
    turn_speed = math.pi * 0.75
  end
  if love.keyboard.isDown("left") then
    self.angle = self.angle - turn_speed * dt
  elseif love.keyboard.isDown("right") then
    self.angle = self.angle + turn_speed * dt
  end
  local movement = vec2:new(0, 0)
  if love.keyboard.isDown("up") then
    movement.y = -actual_speed * dt
  elseif love.keyboard.isDown("down") then
    movement.y = actual_speed * dt
  end
  local pos = movement:origin_rotate(self.angle)
  self.x = self.x + pos.x
  self.y = self.y + pos.y
end

function player:draw()
  local quad = self.character_animation:get_quad()
  local _, _, w, h = quad:getViewport()
  love.graphics.draw(self.character, quad, self.x, self.y, self.angle, 1, 1, w/2, h/2)
  quad = self.bazooka_animation:get_quad()
  _, _, w, h = quad:getViewport()
  local bazooka_pos = vec2:new(self.x, self.y + 18):rotate(
    vec2:new(self.x, self.y),
    self.angle
  )
  love.graphics.draw(self.bazooka, quad, bazooka_pos.x, bazooka_pos.y, self.angle, 1, 1, w / 2, h / 2)
end

return player
