
#   00000000    0000000    0000000
#   000   000  000   000  000     
#   00000000   000   000  0000000 
#   000        000   000       000
#   000         0000000   0000000 

log    = require '/Users/kodi/s/ko/js/tools/log'
Vector = require './vector'

class Pos

    constructor: (x=0, y=0, z=0) ->
        
        if (x instanceof Vector) or (x instanceof Pos)
            @x = Math.round x.x
            @y = Math.round x.y
            @z = Math.round x.z
        else if Array.isArray x
            @x = Math.round x[0]
            @y = Math.round x[1]
            @z = Math.round x[2]
        else
            @x = Math.round x
            @y = Math.round y
            @z = Math.round z
        log "Pos #{x} #{y} #{z}", @
        if Number.isNaN @x
            throw new Error

    vector: () -> new Vector x, y, z 
    minus: (p) -> new Pos @x-p.x, @y-p.y, @z-p.z
    plus:  (p) -> new Pos @x+p.x, @y+p.y, @z+p.z
    mul:   (f) -> new Pos @x*f, @y*f, @z*f
    div:   (d) -> new Pos @x/d, @y/d, @z/d
    eql:   (p) -> @x==p.x and @y==p.y and @z==p.z
    
    add: (p) -> 
        @x = parseInt @x + p.x 
        @y = parseInt @y + p.y 
        @z = parseInt @z + p.z
        @
        
    sub: (p) -> 
        @x = parseInt @x - p.x 
        @y = parseInt @y - p.y 
        @z = parseInt @z - p.z
        @

module.exports = Pos
