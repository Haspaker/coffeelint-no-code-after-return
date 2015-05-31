f = ->
  doSomething()
  return ->
    doSomething()
    return
    doSomethingElse
