
#   00000000   000       0000000   000   000  00000000  00000000 
#   000   000  000      000   000   000 000   000       000   000
#   00000000   000      000000000    00000    0000000   0000000  
#   000        000      000   000     000     000       000   000
#   000        0000000  000   000     000     00000000  000   000
{
clamp
}           = require './tools/tools'
log         = require './tools/log'
Bot         = require './bot'
Action      = require './action'
Timer       = require './timer'
Vector      = require './lib/vector'
Camera      = require './camera'
Quaternion  = require './lib/quaternion'
 
class Player extends Bot
    
    constructor: ->
        
        super
        @name = 'player'
        @key =
            forward:  'w'
            backward: 's'
            left:     'a'
            right:    'd'
            lookUp:   'up'
            lookDown: 'down'
            shoot:    'enter'
            jump:     'space'
            view:     'c'
            push:     'shift'

        @camera = new Camera @,
            aspect: world.view.offsetWidth / world.view.offsetHeight

        @look_action = null
        @look_angle  = 0.0
        @new_dir_sgn = 1.0
        @rotate      = 0
        
        @recorder    = null
        @playback    = null
        
        @addAction new Action @, Action.LOOK_UP,    "look up",    220
        @addAction new Action @, Action.LOOK_DOWN,  "look down",  220
        @addAction new Action @, Action.LOOK_RESET, "look reset", 60
    
        @addEventWithName "landed"
    
    bulletHitSound: -> 'BULLET_HIT_PLAYER'
            
    #    0000000    0000000  000000000  000   0000000   000   000
    #   000   000  000          000     000  000   000  0000  000
    #   000000000  000          000     000  000   000  000 0 000
    #   000   000  000          000     000  000   000  000  0000
    #   000   000   0000000     000     000   0000000   000   000
    
    initAction: (action) ->
        # log "initAction #{action.id} #{action.name}"
        switch action.id
            when Action.CLIMB_DOWN
                # @addMoves 1 
                world.playSound 'BOT_CLIMB'
            when Action.FORWARD
                # @addMoves 1 
                world.playSound 'BOT_MOVE'
            when Action.TURN_LEFT, Action.TURN_RIGHT
                world.playSound 'BOT_TURN'
            when Action.JUMP
                # @addMoves actionId == Action.JUMP and 1 or 2
                world.playSound 'BOT_JUMP'
        
        super action
        
    #   00000000   00000000  00000000   00000000   0000000   00000000   00     00
    #   000   000  000       000   000  000       000   000  000   000  000   000
    #   00000000   0000000   0000000    000000    000   000  0000000    000000000
    #   000        000       000   000  000       000   000  000   000  000 0 000
    #   000        00000000  000   000  000        0000000   000   000  000   000

    performAction: (action) ->
        relTime = action.getRelativeTime()
        switch action.id
            when Action.NOOP      then return
            when Action.LOOK_UP   then @look_angle = relTime * 90.0
            when Action.LOOK_DOWN then @look_angle = relTime * -90.0
            when Action.LOOK_RESET
                if @look_angle > 0 then @look_angle = Math.min @look_angle, (1.0-relTime) * 90.0
                else                    @look_angle = Math.max @look_angle, (1.0-relTime) * -90.0
            else
                super action 
    
    #   00000000  000  000   000  000   0000000  000   000
    #   000       000  0000  000  000  000       000   000
    #   000000    000  000 0 000  000  0000000   000000000
    #   000       000  000  0000  000       000  000   000
    #   000       000  000   000  000  0000000   000   000
    
    finishAction: (action) ->
    
        if action.id == Action.LOOK_RESET
            @look_action = null
            @look_angle  = 0.0
        else
            if action.id == @move_action?.id # move finished, update direction
                @dir_sgn = @new_dir_sgn
            
            if action.id != Action.LOOK_UP and action.id != Action.LOOK_DOWN
                super action
            
            if action.id == Action.TURN_LEFT or action.id == Action.TURN_RIGHT
                if @rotate
                    @rotate_action = @getActionWithId @rotate
                    @rotate_action.reset()
                    Timer.addAction @rotate_action
    
    die: () ->
                
    #   000   000  00000000  000   000
    #   000  000   000        000 000 
    #   0000000    0000000     00000  
    #   000  000   000          000   
    #   000   000  00000000     000   
        
    modKeyComboEventDown: (mod, key, combo, event) ->
                    
        # log "player.modKeyComboEventDown mod:#{mod} key:#{key} combo:#{combo}"
        
        switch key
            when @key.forward, @key.backward
                @push = mod == @key.push
                @move = true # try to move as long as the key is not released
                if not @move_action?
                    @new_dir_sgn = @dir_sgn = (key == @key.backward) and -1 or 1 
                    @moveBot() # perform new move action (depending on environment)
                else
                    if @move_action.id == Action.JUMP and @move_action.getRelativeTime() < 1                        
                        if world.isUnoccupiedPos(@position.plus(@getUp()).plus(@getDir())) and
                            world.isUnoccupiedPos(@position.plus(@getDir())) # forward and above forward also empty
                                action = @getActionWithId Action.JUMP_FORWARD
                                action.takeOver @move_action                                
                                Timer.removeAction @move_action
                                @move_action = action
                                Timer.addAction @move_action                          
                    @new_dir_sgn = (key == @key.backward) and -1 or 1
                return true
        
            when @key.left, @key.right
                @rotate = (key == @key.left) and Action.TURN_LEFT or Action.TURN_RIGHT
                if not @rotate_action? # player is not performing a rotation
                    @rotate_action = @getActionWithId @rotate
                    Timer.addAction @rotate_action
                return true
            
            when @key.jump
                @jump = true # switch to jump mode until jump_key released
                @jump_once = true
                if not @move_action? 
                    @moveBot() # perform jump action (depending on environment)
                    @jump_once = false
                else
                    # log 'jump:moving'
                    if @move_action.id == Action.FORWARD and @move_action.getRelativeTime() < 0.6 or 
                        @move_action.id == Action.CLIMB_DOWN and @move_action.getRelativeTime() < 0.4
                            # abort current move and jump instead
                            # log 'jump:move or climb down'
                            if world.isUnoccupiedPos @position.plus @getUp()
                                # log 'jump:can do'
                                if world.isUnoccupiedPos @position.plus @getUp().plus @getDir()  
                                    action = @getActionWithId Action.JUMP_FORWARD
                                else 
                                    action = @getActionWithId Action.JUMP
                                action.takeOver @move_action                                
                                Timer.removeAction @move_action
                                @move_action = action
                                @jump_once = false
                                Timer.addAction @move_action 
                    else if @move_action.id in [Action.JUMP, Action.JUMP_FORWARD]
                        @jump_once = false
                return true
            
            when @key.push
                @push = true
                return true
            
            when @key.shoot
                if not @shoot
                    @shoot = true
                    Timer.addAction @getActionWithId Action.SHOOT
                return true
            
            when @key.lookUp, @key.lookDown
                if not @look_action
                    @look_action = @getActionWithId (key == @key.lookUp) and Action.LOOK_UP or Action.LOOK_DOWN
                    @look_action.reset()
                    Timer.addAction @look_action
                return true
            
            when @key.view
                world.changeCameraMode()
                return true
        
        false
    
    #   00000000   00000000  000      00000000   0000000    0000000  00000000
    #   000   000  000       000      000       000   000  000       000     
    #   0000000    0000000   000      0000000   000000000  0000000   0000000 
    #   000   000  000       000      000       000   000       000  000     
    #   000   000  00000000  0000000  00000000  000   000  0000000   00000000
    
    modKeyComboEventUp: (mod, key, combo, event) ->
        @push = false if @key.push == 'shift'
        # log "player.modKeyComboEventUp mod:#{mod} key:#{key} combo:#{combo}"
        switch key    
            when @key.shoot
                Timer.removeAction @getActionWithId Action.SHOOT
                @shoot = false
                return true
            
            when @key.forward, @key.backward
                @move = false
                return true
            
            when @key.jump
                @jump = false
                return true
            
            when @key.left, @key.right
                @rotate = 0
                return true
            
            when @key.push
                @push = false
                return true
            
            when @key.lookDown, @key.lookUp
                if @look_action and @look_action.id != Action.LOOK_RESET
                    Timer.removeAction @look_action
                @look_action = @getActionWithId Action.LOOK_RESET
                Timer.addAction @look_action
                return true
            
            when @key.view 
                return true
            
        false
    
module.exports = Player
