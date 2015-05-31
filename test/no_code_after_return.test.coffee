chai = require 'chai'
coffeelint = require 'coffeelint'
fs = require 'fs'
path = require 'path'

NoCodeAfterReturn = require path.join '..', 'coffeelint_no_code_after_return'
coffeelint.registerRule NoCodeAfterReturn

expect = chai.expect

examplesDir = path.join __dirname, 'examples'

isExampleFile = (name) -> /_example\.coffee$/.test name
isNegative = (name) -> /^negative_/.test name
forEachExample = (fn) ->
  files = fs.readdirSync examplesDir
  files.filter(isExampleFile).forEach fn

describe 'No Code After Return', ->
  forEachExample (filename) ->
  # do (filename = 'inside_if_example.coffee') ->
    examplePath = path.join __dirname, 'examples', filename
    context "\"#{filename}\"", ->
      if isNegative(filename)
        it 'does not have any dead code', (done) ->
          fs.readFile examplePath, (err, source) ->
            return done(err) if err

            errors = coffeelint.lint(source.toString())

            expect(errors).to.be.empty

            done()

      else
        it 'has dead code', (done) ->
          fs.readFile examplePath, (err, source) ->
            return done(err) if err

            errors = coffeelint.lint(source.toString())

            expect(errors).to.not.be.empty

            done()
