exists = (anArray, predicate) ->
  reachable()
  for element in anArray when predicate(element)
    reachable()
    return true

  reachable()
