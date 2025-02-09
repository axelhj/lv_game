local sheet_animator = {
  instances = {},
  elapsed_time = 0,
}

--[[
Cycles are {
  cycles = {
    { frame_ind_1, frame_ind_2, ...},
    { frame_ind_1, frame_ind_2, ...},
  },
  speed = speed_ms_frame_time,
}
]]--
function sheet_animator.new(animator, lv_image, frames_x, frames_y, cycles, speed, pad_x, pad_y)
  local width = lv_image:getWidth()
  local height = lv_image:getHeight()
  local instance = {
    image = lv_image,
    image_w = width,
    image_h = height,
    frames_x = frames_x,
    frames_y = frames_y,
    pad_x = pad_x,
    pad_y = pad_y,
    cycles = cycles,
    current_frame = 1,
    speed = speed,
    next_tick = 0,
  }
  table.insert(animator.instances, instance)
  return animator
end

function sheet_animator.drop(animator, instance)
  for i = 1, #animator.instances do
    if animator.instances[i] == instance then
      table.remove(animator.instances, i)
      break
    end
  end
end

function sheet_animator.drop_all(animator)
  for i = #animator.instances, 1, -1 do
    table.remove(animator.instances, i)
  end
end

function sheet_animator.update(animator, dt)
  animator.elapsed_time = animator.elapsed_time + (dt * 1000)
  for i = 1, #animator.instances do
    local instance = animator.instances[i]
    if
      instance.next_tick ~= nil and
      instance.next_tick <= animator.elapsed_time
    then
      instance.next_tick = instance.next_tick + instance.speed
      if instance.current_frame == #instance.cycles then
        instance.current_frame = 1
      else
        instance.current_frame = instance.current_frame + 1
      end
    elseif
      instance.next_tick ~= nil and
      instance.next_tick <= animator.elapsed_time - instance.speed
    then
      instance.next_tick = animator.elapsed_time + instance.speed
    end
  end
end

function sheet_animator.get_quad(animator, image)
  for i = 1, #animator.instances do
    local instance = animator.instances[i]
    if instance.image == image then
      local w = instance.image_w / instance.frames_x
      local h = instance.image_h / instance.frames_y
      local row = math.floor(
        instance.cycles[instance.current_frame] / instance.frames_x
      )
      local col = math.floor(
        instance.cycles[instance.current_frame] % instance.frames_x
      )
      return love.graphics.newQuad(
        (col + 1) * instance.pad_x + (col * w),
        (row + 1) * instance.pad_y + (row * h),
        w, h, instance.image_w, instance.image_h
      )
    end
  end
end

return sheet_animator
