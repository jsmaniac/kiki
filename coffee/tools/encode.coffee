# 00000000  000   000   0000000   0000000   0000000    00000000
# 000       0000  000  000       000   000  000   000  000     
# 0000000   000 0 000  000       000   000  000   000  0000000 
# 000       000  0000  000       000   000  000   000  000     
# 00000000  000   000   0000000   0000000   0000000    00000000

encode = require('html-entities').XmlEntities.encode

module.exports = (s) ->
    if s
        r = encode s
        r = r.replace /\s/g, '&nbsp;'
    else
        ''