f = ->
  reachable()
  return ->
    reachable()
    return
    unreachable
