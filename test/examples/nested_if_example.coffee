f = ->
  doSomething()
  if something
    doSomething()
    if somethingElse
      doSomething()
      return
      doSomethingElse()
  doSomethingElse()
