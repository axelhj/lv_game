local d = {}

function d:new()
  return setmetatable({}, { __index = self })
end

function d:add(event, observer)
  self.observers = self.observers or {}
  self.observers[event] = self.observers[event] or {}
  table.insert(self.observers[event], observer)
end

function d:remove(event, observer)
  if observer then
    local evt = self.observers[evt]
    for i = 1, #evt do
      if evt[i] == observer then
        table.remove(evt, observer)
        return true
      end
    end
  else
    for i = 1, #self.observers do
      if self.observers[i] == observer then
        table.remove(self.observers, observer)
        return true
      end
    end
  end
  return false
end

function d:dispatch(event, message)
  local evt = self.observers[event] or {}
  for i = 1, #evt do
    evt[i](message)
  end
end

return d
