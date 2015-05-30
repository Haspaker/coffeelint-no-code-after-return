module.exports = class NoCodeAfterReturn

  rule:
    name: 'no_code_after_return'
    level: 'warn'
    message: 'Dead Code'
    description: 'Detects dead code after return statements'

  lintNode: (node, astApi) ->

  lintAST: (node, astApi) -> @lintNode node, astApi
