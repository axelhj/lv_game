local sprite = {}

local merge = require"lib/merge".merge

function sprite:create(x, y, sprite_name, options)
  local theta = options and options.theta or 0
  local angle = options and options.angle or 0
  local appear_seconds = options and options.appear_at or nil
  local disappear_seconds = options and options.disappear_at or nil
  local scale = options and options.scale or nil
  local instance = {
    hidden = appear_seconds ~= nil and
      appear_seconds ~= 0 and
      disappear_seconds ~= nil,
    speed = options and options.speed,
    scale = scale,
    angle = angle,
    theta = theta,
    x = x,
    y = y,
    appear_seconds = appear_seconds,
    disappear_seconds = disappear_seconds,
    elapsed_time = 0,
    sprite_name = sprite_name,
  }
  instance.image = love.graphics.newImage("asset/"..sprite_name..".png")
  local image_width = instance.image:getWidth()
  local image_height = instance.image:getHeight()
  local quad_top_x = options and options.offset_start_x or 0
  local quad_top_y = options and options.offset_start_y or 0
  local quad_bottom_x = options and options.offset_end_x or image_width
  local quad_bottom_y = options and options.offset_end_y or image_height
  instance.quad = love.graphics.newQuad(
    quad_top_x,
    quad_top_y,
    quad_bottom_x,
    quad_bottom_y,
    image_width,
    image_height
  )
  return merge(instance, sprite)
end

function sprite:drop()
end

function sprite.update(instance, dt)
  instance.elapsed_time = instance.elapsed_time + (dt * 1000)
  if
    not instance.hidden and
    instance.speed ~= nil and
    instance.speed ~= 0
  then
    instance.x = instance.x + math.cos(instance.theta) * instance.speed * dt
    instance.y = instance.y + math.sin(instance.theta) * instance.speed * dt
  end
  local elapsed_seconds = instance.elapsed_time / 1000
  if
    instance.disappear_seconds ~= nil and 
    instance.disappear_seconds ~= 0 and 
    elapsed_seconds > instance.disappear_seconds
  then
    if not instance.hidden then
      instance.hidden = true
    end
    return
  end
  if
    instance.appear_seconds ~= nil and
    instance.appear_seconds ~= 0 and
    elapsed_seconds > instance.appear_seconds and
    instance.hidden
  then
    instance.hidden = false
  end
end

function sprite.draw(instance)
  if instance.hidden then return end
  love.graphics.draw(
    instance.image,
    instance.quad,
    instance.x,
    instance.y,
    (instance.theta or 0) + (instance.angle or 0),
    instance.scale == nil and 1 or instance.scale
  )
end

return sprite
