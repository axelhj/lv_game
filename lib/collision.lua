local c = {}

local rectangle = require"lib.rectangle"

function c:new()
  return setmetatable({}, { __index = self })
end

function c.prepare_tuple(rect, other, intersection)
  local w = other.offset_x < rect.offset_x
    and intersection.extent_x or -intersection.extent_x
  local h = other.offset_y < rect.offset_y
    and intersection.extent_y or -intersection.extent_y
  return { w, h }
end

function c:resolve(moving_object, objects, iters)
  -- Find intersections (AABB)
  -- Find the overlapping rectangle
  -- Measure widht and height of overlap to determine direction
  -- Smallest overlap axis is resolved
  for i = 1, iters do
    local max_i = nil
    local max_o = nil
    local max = 0
    for i, object in pairs(objects) do
      local intersection = moving_object:intersection_rect(object)
      if intersection ~= nil then
        local area = intersection:area()
        if area > max then
          max = area
          max_i = intersection
          max_o = object
        end
      end
    end
    if max_i ~= nil then
      local tuple = self.prepare_tuple(moving_object, max_o, max_i)
      if math.abs(tuple[1]) < math.abs(tuple[2]) then
        moving_object.offset_x = moving_object.offset_x + tuple[1]
      else
        moving_object.offset_y = moving_object.offset_y + tuple[2]
      end
    end
  end
end

return c
