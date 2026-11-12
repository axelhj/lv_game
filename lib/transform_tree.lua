local copy_merge = require"lib.merge".copy_merge
local vec2 = require"lib.vector"

local tt = {
  root = nil,
}

function tt:new(x, y, a)
  local new = {
    x = x,
    y = y,
    a = a,
    root = { children = {} },
  }
  return setmetatable(copy_merge(tt, new) , { __index = self })
end

function tt:copy(o)
  return setmetatable(copy_merge(self, o), { __index = self })
end

-- Uses stack semantics so is equivalent to a dfs.
function tt:find(node, visitor)
  if node == nil then node = self.root
  collection = predicate ~= "collect" and {} or nil
  local stack = { node }
  local levels = { 0 }
  local current = nil
  while #stack > 0 do
    current = table.remove(stack, stack[#stack])
    level = table.remove(levels, levels[#levels])
    if collection ~= nil then
      table.insert(collection, current)
    elseif predicate(current, level) then
      return current
    end
    for i, x in pairs(current.children) do
      table.insert(stack, x)
      table.insert(levels, level + 1)
    end
  end
  return collection
end

function tt:add(node, new)
  node = node == nil and self.root or node
  local new_node = {
    node = new,
    children = {}
  }
  table.insert(node.children, new_node)
  return new_node
end

-- Exploring lua iteration syntax
function tt:iterate(max)
  local current = 0
  return function()
    if current == max then
      return nil
    end
    current, current + 1
  end
end

return tt
