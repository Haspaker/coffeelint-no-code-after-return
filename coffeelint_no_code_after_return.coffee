module.exports = class NoCodeAfterReturn

  rule:
    name: 'no_code_after_return'
    level: 'warn'
    message: 'Dead Code'
    description: 'Detects dead code after return statements'

  debugNode: (node) ->
    return unless node?
    console.log node.constructor.name
    console.log node
    console.log '------------------------------'
    console.log

  deadCodeError: (node, astApi) ->
    @errors.push astApi.createError
      context: node.variable
      lineNumber: node.locationData.first_line + 1
      lineNumberEnd: node.locationData.last_line + 1

  lintIf: (ifExp, astApi) ->
    bodyHasReturn = @lintExpressions(ifExp.body.expressions, astApi)
    if ifExp.elseBody?
      elseHasReturn = @lintExpressions(ifExp.elseBody.expressions, astApi)
      bodyHasReturn and elseHasReturn

  lintReturn: (retExp, astApi) ->
    @lintExpression(retExp.expression, astApi) if retExp.expression?
    true

  lintExpression: (exp, astApi) ->
    if exp.constructor.name is 'Return'
      @lintReturn(exp, astApi)
    else if exp.constructor.name is 'If'
      @lintIf(exp, astApi)
    else if exp.constructor.name in ['For', 'While', 'Code']
      @lintCode(exp, astApi)

  lintExpressions: (expressions, astApi) ->
    returnExp = null
    expressions.forEach (exp) =>
      # @debugNode exp
      @deadCodeError(exp, astApi) if returnExp
      lint = @lintExpression(exp, astApi)
      returnExp or= lint
    return returnExp

  lintCode: (code, astApi) -> @lintExpressions code.body.expressions, astApi

  lintNode: (node, astApi) ->
    node.traverseChildren false, (child) =>
      @lintCode(child, astApi) if child.constructor.name is 'Code'
    return

  lintAST: (node, astApi) -> @lintNode node, astApi
