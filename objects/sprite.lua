local copy_merge = require"lib.merge".copy_merge
local merge = require"lib.merge".merge
local rectangle = require"lib.rectangle"

local sprite = {
  display_angle = 0,
  movement_angle = 0,
  appear_at_s = nil,
  disappear_after_s = nil,
  scale = 1,
  hidden = false,
  speed = 0,
  x = 0,
  y = 0,
  elapsed_time = 0,
  sprite_name = nil,
  image = nil,
  image_width = nil,
  image_height = nil,
  offset = nil
}

function sprite:new(d, x, y, sprite_name, options)
  local image = love.graphics.newImage("asset/sp_"..sprite_name..".png")
  local image_width = image:getWidth()
  local image_height = image:getHeight()
  local quad = rectangle:copy(options.offset)
  quad.extent_x = quad.extent_x or image_width
  quad.extent_y = quad.extent_x or image_height
  local new = merge(copy_merge(sprite, options), {
    d = d,
    x = x,
    y = y,
    sprite_name = sprite_name,
    image = image,
    image_width = image_width,
    image_height = image_height,
    hidden = options.appear_at_s ~= nil and
      options.appear_at_s ~= 0,
    quad = love.graphics.newQuad(
      quad.offset_x,
      quad.offset_y,
      quad.extent_x,
      quad.extent_y,
      image_width,
      image_height
    )
  })
  new = setmetatable(new, { __index = self })
  new.d:add("update", function(dt) new:update(dt) end)
  new.d:add("draw", function() new:draw() end)
  return new
end

function sprite:drop()
  self.d:remove("update", self)
  self.d:remove("draw", self)
end

function sprite:update(dt)
  self.elapsed_time = self.elapsed_time + (dt * 1000)
  if
    not self.hidden and
    self.speed ~= nil and
    self.speed ~= 0
  then
    self.x = self.x + math.cos(self.movement_angle) * self.speed * dt
    self.y = self.y + math.sin(self.movement_angle) * self.speed * dt
  end
  local elapsed_seconds = self.elapsed_time / 1000
  if
    self.disappear_after_s ~= nil and
    self.disappear_after_s ~= 0 and
    elapsed_seconds > self.disappear_after_s
  then
    if not self.hidden then
      self.hidden = true
    end
    return
  end
  if
    self.appear_at_s ~= nil and
    self.appear_at_s ~= 0 and
    elapsed_seconds > self.appear_at_s and
    self.hidden
  then
    self.hidden = false
  end
end

function sprite.draw(self)
  if self.hidden then return end
  love.graphics.draw(
    self.image,
    self.quad,
    self.x,
    self.y,
    self.movement_angle + self.display_angle,
    self.scale
  )
end

return sprite
