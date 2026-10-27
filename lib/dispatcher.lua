local d = {}

function d:new()
  return setmetatable({
    id = 0,
    registered_observers = {},
    observers = {},
  }, { __index = self })
end

function d:add(event, observer)
  self.observers[event] = self.observers[event] or {}
  table.insert(self.observers[event], observer)
  local new_id = self.id
  self.id = self.id + 1
  self.registered_observers[new_id] = { event, observer }
  return new_id
end

function d:remove(event, observer)
  local event_observers = self.observers[event]
  for i, event_observer in pairs(event_observers) do
    if event_observer == observer then
      event_observers[i] = nil
      return true
    end
  end
  return false
end

function d:remove_id(event, id)
  local registered_observer = self.registered_observers[id]
  local event, observer = unpack(registered_observer)
  for i, iterated_observer in pairs(self.registered_observers) do
    if iterated_observer == registered_observer then
      self.registered_observers[i] = nil
    end
  end
  return self:remove(event, observer)
end

function d:dispatch(event, message)
  local event_observers = self.observers[event] or {}
  for i, event_observer in pairs(event_observers) do
    if event_observer then
      event_observer(message)
    end
  end
end

return d
