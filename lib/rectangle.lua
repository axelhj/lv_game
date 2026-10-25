local merge = require"lib.merge".merge
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
    other.offset_x                   > self.offset_x + self.extent_x or
    other.offset_x + other.extent_x < self.offset_x or
    other.offset_y                   > self.offset_y + self.extent_y or
    other.offset_y + other.extent_y < self.extent_y)
end

function r:contains(other)
  return not (
    other.offset_x                   > offset_x and
    other.offset_x + other.extent_x < offset_x + extent_x and
    other.offset_y                   > offset_y and
    other.offset_y + other.extent_y < extent_y + extent_y)
end

function r:contained_by(other)
  return not (
    other.offset_x                   < self.offset_x and
    other.offset_x + other.extent_x > self.offset_x + self.extent_x and
    other.offset_y                   < self.offset_y and
    other.offset_y + other.extent_y > self.extent_y + self.extent_y)
end

return r
