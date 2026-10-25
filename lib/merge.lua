local m = {}

function m.merge(a, b)
  for k, v in pairs(b) do
    a[k] = v
  end
  return a
end

function m.copy_merge(a, b)
  local copy = m.merge({}, a)
  return m.merge(copy, b)
end

return m
