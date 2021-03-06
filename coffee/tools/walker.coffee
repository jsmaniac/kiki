# 000   000   0000000   000      000   000  00000000  00000000 
# 000 0 000  000   000  000      000  000   000       000   000
# 000000000  000000000  000      0000000    0000000   0000000  
# 000   000  000   000  000      000  000   000       000   000
# 00     00  000   000  0000000  000   000  00000000  000   000
{
fileExists,
dirExists,
relative,
resolve} = require './tools'
log      = require './log'
walkdir  = require 'walkdir'
path     = require 'path'
fs       = require 'fs'

class Walker

    constructor: (@cfg) ->
        
        @cfg.files       = []
        @cfg.stats       = []
        @cfg.maxDepth    ?= 3
        @cfg.dotFiles    ?= false
        @cfg.includeDirs ?= true
        @cfg.maxFiles    ?= 500
        @cfg.ignore      ?= ['node_modules', 'app', 'img', 'dist', 'build', 'Library', 'Applications']
        @cfg.include     ?= ['.konrad.noon', '.gitignore', '.npmignore']
        @cfg.ignoreExt   ?= ['.app']
        @cfg.includeExt  ?= ['.coffee', '.js', '.styl', '.css', '.pug', '.jade', '.html', 
                            '.md', '.txt', '.noon', '.json', '.cpp', '.cc', '.c', '.h', '.hpp', '.sh', '.py']
        # log "walker", @cfg
      
    #  0000000  000000000   0000000   00000000   000000000
    # 000          000     000   000  000   000     000   
    # 0000000      000     000000000  0000000       000   
    #      000     000     000   000  000   000     000   
    # 0000000      000     000   000  000   000     000   
    
    start: ->           
        # profile 'walker start'
        try
            dir = @cfg.root
            @walker = walkdir.walk dir, max_depth: @cfg.maxDepth
            onWalkerPath = (cfg) -> (p,stat) ->
                name = path.basename p
                extn = path.extname p

                if cfg.filter?(p)
                    return @ignore p
                else if name in ['.DS_Store', 'Icon\r'] or extn in ['.pyc']
                    return @ignore p
                else if cfg.includeDir? and path.dirname(p) == cfg.includeDir
                    cfg.files.push p
                    cfg.stats.push stat
                    @ignore p if name in cfg.ignore
                    @ignore p if name.startsWith('.') and not cfg.dotFiles
                else if name in cfg.ignore
                    return @ignore p
                else if name in cfg.include
                    cfg.files.push p
                    cfg.stats.push stat
                else if name.startsWith '.'
                    if cfg.dotFiles
                        cfg.files.push p
                        cfg.stats.push stat
                    else
                        return @ignore p 
                else if extn in cfg.ignoreExt
                    return @ignore p
                else if extn in cfg.includeExt or cfg.includeExt.indexOf('') >= 0
                    cfg.files.push p
                    cfg.stats.push stat
                else if stat.isDirectory()
                    if p != cfg.root and cfg.includeDirs
                        cfg.files.push p 
                        cfg.stats.push stat
                        
                cfg.path? p, stat
                if stat.isDirectory()
                    if cfg.includeDirs
                        cfg.dir? p, stat
                else
                    if path.extname(p) in cfg.includeExt or path.basename(p) in cfg.include or cfg.includeExt.indexOf('') >= 0
                        cfg.file? p, stat
                        
                if cfg.files.length > cfg.maxFiles
                    # log 'max files reached', @end?
                    @end()
            
            @walker.on 'path', onWalkerPath @cfg
            @walker.on 'end', => @cfg.done? @cfg.files, @cfg.stats
                
        catch err
            log "walker.start.error: #{err} dir: #{dir}"
            log "#{err.stack}"

    stop: -> 
        @walker?.end()
        @walker = null
    
    # 00000000    0000000    0000000  000   000   0000000    0000000   00000000
    # 000   000  000   000  000       000  000   000   000  000        000     
    # 00000000   000000000  000       0000000    000000000  000  0000  0000000 
    # 000        000   000  000       000  000   000   000  000   000  000     
    # 000        000   000   0000000  000   000  000   000   0000000   00000000
    
    @packagePath: (p) ->
        while p.length and p not in ['.', '/']            
            if fs.existsSync path.join p, 'package.noon'
                return resolve p
            if fs.existsSync path.join p, 'package.json'
                return resolve p
            if fs.existsSync path.join p, '.git'
                return resolve p
            p = path.dirname p
        null

module.exports = Walker
