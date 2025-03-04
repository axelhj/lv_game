local sheet_animator = {
  instances = {},
  elapsed_time = 0,
}

local function get_quad(self)
  local w = self.image_w / self.frames_x
  local h = self.image_h / self.frames_y
  local row = math.floor(
    self.cycles[self.current_frame] / self.frames_x
  )
  local col = math.floor(
    self.cycles[self.current_frame] % self.frames_x
  )
  return love.graphics.newQuad(
    (col + 1) * self.pad_x + (col * w),
    (row + 1) * self.pad_y + (row * h),
    w, h, self.image_w, self.image_h
  )
end

local function reset(self)
  self.current_frame = 1
  self.next_tick = sheet_animator.elapsed_time + self.speed
end

--[[
Cycles are {
  cycles = { frame_ind_1, frame_ind_2, ...},
  speed = speed_ms_frame_time,
}
]]--
function sheet_animator:create(lv_image, frames_x, frames_y, cycles, speed, pad_x, pad_y, repeat_)
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
    repeat_ = repeat_,
    reset = reset,
    get_quad = get_quad,
  }
  table.insert(self.instances, instance)
  return instance
end

function sheet_animator:drop(self, instance)
  for i = 1, #self.instances do
    if self.instances[i] == instance then
      table.remove(self.instances, i)
      break
    end
  end
end

function sheet_animator:drop_all()
  for i = #self.instances, 1, -1 do
    table.remove(self.instances, i)
  end
end

function sheet_animator:update(dt)
  self.elapsed_time = self.elapsed_time + (dt * 1000)
  for i = 1, #self.instances do
    local instance = self.instances[i]
    if
      instance.next_tick ~= nil and
      instance.next_tick <= self.elapsed_time
    then
      instance.next_tick = instance.next_tick + instance.speed
      if instance.current_frame == #instance.cycles then
        if instance.repeat_ then
          instance.current_frame = 1
        end
      else
        instance.current_frame = instance.current_frame + 1
      end
    elseif
      instance.next_tick ~= nil and
      instance.next_tick <= self.elapsed_time - instance.speed
    then
      instance.next_tick = self.elapsed_time + instance.speed
    end
  end
end

return sheet_animator
