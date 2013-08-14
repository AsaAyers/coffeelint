# Patch the source properties onto the destination.
extend = (destination, sources...) ->
    for source in sources
        (destination[k] = v for k, v of source)
    return destination

# Patch any missing attributes from defaults to source.
defaults = (source, defaults) ->
    extend({}, defaults, source)

# Create an error object for the given rule with the given
# attributes.
createError = (rule, attrs = {}) ->
    level = attrs.level
    if level not in ['ignore', 'warn', 'error']
        throw new Error("unknown level #{level}")

    if level in ['error', 'warn']
        return attrs
    else
        null

module.exports = class BasePlugin
    # To implement a custom plugin you need to override
    # `rule_name`, `tokens`, and `lint`

    rule_name: undefined

    # This should be an array of token types to lint.
    #
    # example: [ '->', 'INDENT', 'MATH' ]
    tokens: []

    lint: (token) ->

    constructor: (@lexicalLinter, @config) ->

    run: (token) ->
        if token[0] in @tokens
            # Temporary to make this run.
            @lines = @lexicalLinter.lines
            @lineNumber = @lexicalLinter.lineNumber
            return @lint token

    # helper functions

    peek: ->
        @lexicalLinter.peek arguments...

    createLexError : (attrs = {}) ->
        rule = @rule_name
        attrs.lineNumber = @lineNumber + 1
        attrs.level = @config[rule].level
        attrs.line = @lines[@lineNumber]
        attrs.rule = rule

        createError rule, defaults(attrs, @config[rule])
