path = require 'path'
vows = require 'vows'
assert = require 'assert'
coffeelint = require path.join('..', 'lib', 'coffeelint')


vows.describe('plusplus').addBatch({

    'Unary addition operators' :

        topic : '''
            y++
            ++y
            x--
            --x
            '''

        'are permitted by default' : (source) ->
            errors = coffeelint.lint(source)
            assert.isArray(errors)
            assert.isEmpty(errors)

        'can be forbidden' : (source) ->
            errors = coffeelint.lint(source, {plusplus: {'level':'error'}})
            assert.isArray(errors)
            assert.lengthOf(errors, 4)
            error = errors[0]
            assert.equal(error.lineNumber, 1)
            assert.equal(error.rule, 'plusplus')

}).export(module)