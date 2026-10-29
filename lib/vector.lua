local copy_merge = require"lib.merge".copy_merge

local v = {
  x = 0,
  y = 0,
}

function v:new(x, y)
  local new = {
    x = x,
    y = y
  }
  return setmetatable(copy_merge(self, new) , { __index = self })
end

function v:copy(o)
  return setmetatable(copy_merge(self, o), { __index = self })
end

function v:intersects(other)
  return not (
    other.offset_x                   > self.offset_x + self.extent_x or
    other.offset_x + other.extent_x < self.offset_x or
    other.offset_y                   > self.offset_y + self.extent_y or
    other.offset_y + other.extent_y < self.extent_y)
end

function v:add(other)
  return v:new(other.x + self.x, other.y + self.y)
end

function v:sub(other)
  return v:new(other.x - self.x, other.y - self.y)
end

function v:rotate(about, theta)
  local point = about:sub(self)
  local cos_t = math.cos(theta)
  local sin_t = math.sin(theta)
  return about:add(v:new(
    point.x * cos_t - point.y * sin_t,
    point.x * sin_t + point.y * cos_t))
end

function v:distance(other)
  local dx = other.x - self.x
  local dy = other.y - self.y
  return math.sqrt(dx * dx + dy * dy)
end

return v
