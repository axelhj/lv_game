local copy_merge = require"lib.merge".copy_merge

local r = {
  offset_x = 0,
  extent_x = 0,
  offset_y = 0,
  extent_y = 0,
}

function r:new(
  offset_x,
  offset_y,
  extent_x,
  extent_y)
  local new = {
    offset_x = offset_x,
    extent_x = extent_x,
    offset_y = offset_y,
    extent_y = extent_y
  }
  return setmetatable(copy_merge(r, new) , { __index = self })
end

function r:copy(o)
  return setmetatable(copy_merge(self, o), { __index = self })
end

function r:intersects(other)
  return not (
    other.offset_x                  > self.offset_x + self.extent_x or
    other.offset_x + other.extent_x < self.offset_x or
    other.offset_y                  > self.offset_y + self.extent_y or
    other.offset_y + other.extent_y < self.extent_y)
end

function r:intersection_rect(other)
  if not self:intersects(other) then return nil end
  local x = math.max(self.offset_x, other.offset_x)
  local y = math.max(self.offset_y, other.offset_y)
  local w = math.min(
    self.offset_x + self.extent_x,
    other.offset_x + other.extent_x) - x
  local h = math.min(
    self.offset_y + self.extent_y,
    other.offset_y + other.extent_y) - y
  return self:new(x, y, w, h)
end

function r:contains(other)
  return not (
    other.offset_x                  > offset_x and
    other.offset_x + other.extent_x < offset_x + extent_x and
    other.offset_y                  > offset_y and
    other.offset_y + other.extent_y < extent_y + extent_y)
end

function r:contained_by(other)
  return not (
    other.offset_x                   < self.offset_x and
    other.offset_x + other.extent_x > self.offset_x + self.extent_x and
    other.offset_y                   < self.offset_y and
    other.offset_y + other.extent_y > self.extent_y + self.extent_y)
end

function r:string()
  return "(x: "..self.offset_x.." y: "..self.offset_y..
    " w: "..self.extent_x.." h: "..self.extent_y..")"
end

function r:area()
  return self.extent_x * self.extent_y
end

return r
