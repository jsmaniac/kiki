#  0000000    0000000  000000000  000   0000000   000   000
# 000   000  000          000     000  000   000  0000  000
# 000000000  000          000     000  000   000  000 0 000
# 000   000  000          000     000  000   000  000  0000
# 000   000   0000000     000     000   0000000   000   000

class Action
    
    constructor: (o, i, n, d, m) ->

        @action_object = o
        @action_name   = n
        @action_id     = i
        @mode          = m
        @duration      = d
        @event         = null
        @delete_flag_ptr = false
        @reset()

# KikiAction (KikiActionObject* o, int d, int m ) 
# { 
    # action_object = o
    # action_id     = 0
    # mode          = m
    # duration      = d
    # event         = null

    # delete_flag_ptr = null

    # @reset()
# }

    del: ->
        if @event           then @event.removeAction @
        if @action_object   then @action_object.removeAction @
        if @delete_flag_ptr then @delete_flag_ptr = true

    init: () ->    @action_object.initAction @
    perform: () -> @action_object.performAction @
    finish: () ->  @action_object.finishAction @
    finished: () -> 
        @action_object.actionFinished @
        return if @delete_flag_ptr
    
        if @current == @getDuration() # if keepRest wasn't called -> reset start and current values
            @reset()

    reset: () ->
        @start   = 0
        @rest    = 0
        @last    = 0
        @current = 0

    takeRest: (action) ->
        @current = action.rest
        @start   = action.start
        @last    = 0
        @rest    = 0

    keepRest: () ->
        if @rest != 0
            @current = @rest
            @rest = 0

    getRelativeTime: () ->
        return @current / @getDuration() 
 
    getDuration: ()  ->
        return Controller.mapMsTime @duration 

    performWithEvent: (event) ->
        eventTime = event.getTime()
    
        if @start == 0
            @start   = eventTime
            @current = 0
            @rest    = 0
            @last    = 0
            if @duration == 0 and @mode == ONCE
                event.removeAction @
    
            @perform()
            
            @last = @current
            
            if @duration == 0 and @mode == ONCE
                @finished()
        else
            currentDiff = eventTime - @start
            if currentDiff >= @getDuration()
                @current = @getDuration()
    
                @start  += @current
                @rest    = eventTime - @start
                @perform()
                @last    = 0
                
                if @mode == CONTINUOUS
                    @current = @rest
                    return
                if @mode == ONCE
                    event.removeAction @
                
                @finish()
    
                if @mode == REPEAT
                    if @current == @getDuration() # if keepRest wasn't called -> reset start and current values
                        @reset()
                    return
                
                event.addFinishedAction @
            else
                @current = currentDiff
                @perform()
                @last    = @current
        
module.exports = Action