#  0000000  000   000  000  000000000   0000000  000   000
# 000       000 0 000  000     000     000       000   000
# 0000000   000000000  000     000     000       000000000
#      000  000   000  000     000     000       000   000
# 0000000   00     00  000     000      0000000  000   000

log        = require "/Users/kodi/s/ko/js/tools/log"
Quaternion = require './lib/quaternion'
Vector     = require './lib/vector'
Action     = require './action'
Light      = require './light'
Item       = require './item'

class Switch extends Item

    isSpaceEgoistic: -> true
    
    constructor: (active=false) ->

        super
    
        @angle = 0
        @light = null
        @active = null
        @sound_on  = 'SWITCH_ON'
        @sound_off = 'SWITCH_OFF'
        
        @SWITCH_OFF_EVENT = @addEventWithName "off"
        @SWITCH_ON_EVENT  = @addEventWithName "on"
        @SWITCHED_EVENT   = @addEventWithName "switched"
    
        @addAction new Action @, Action.TOGGLE, "toggle", 0
        @addAction new Action @, Action.ROTATE, "rotation", 2000, Action.CONTINUOUS
    
        @setActive active

    createMesh: () ->
        torusRadius = 0.05
        t1 = new THREE.TorusGeometry 0.5-torusRadius, torusRadius, 16, 32
        @mat  = new THREE.MeshPhongMaterial 
            color:          0x0000ff
            side:           THREE.FrontSide
            shading:        THREE.SmoothShading
            shininess:      5
        @mesh = new THREE.Mesh t1, @mat
     
        t2 = new THREE.TorusGeometry 0.5-torusRadius, torusRadius, 16, 32
        t3 = new THREE.TorusGeometry 0.5-torusRadius, torusRadius, 16, 32
        t2.rotateY Vector.DEG2RAD 90 
        t3.rotateX Vector.DEG2RAD 90 
        t2.merge t3
        @tors = new THREE.Mesh t2, @mat
        @mesh.add @tors
        @mesh
        
    bulletImpact: -> @setActive not @active
    
    del: () -> @light?.del()
    
    lightDeleted: () -> @light = null
    
    setActive: (status) ->
        log "switch #{@name} active:#{status}"
        if @active != status
            @active = status
            
            if @active
                # start the orbit rotation
                @startTimedAction @getActionWithId Action.ROTATE 
                world.playSound @sound_on
                @events[@SWITCH_ON_EVENT].triggerActions()
                @light = new Light @position, 10.0
                @light.on 'deleted', @lightDeleted
            else
                @stopAction @getActionWithId Action.ROTATE
                
                world.playSound @sound_off
                @events[@SWITCH_OFF_EVENT].triggerActions()
    
                if @light 
                    @light.del()
                    @light = null
            
            @events[@SWITCHED_EVENT].triggerActions()
    
    setPosition: (pos) ->
        super pos
        @light?.setPosition @position
    
    animate: (f) ->
        @angle += f * 360
        @mesh.quaternion.copy Quaternion.rotationAroundVector @angle, new Vector 0,1,0
        @tors.quaternion.copy Quaternion.rotationAroundVector @angle/2, new Vector 0,0,1
        # @tort.quaternion.copy Quaternion.rotationAroundVector @angle/2, new Vector 0,0,1
        
    performAction: (action) ->
        
        if action.id == Action.TOGGLE
            @toggle()
            log "Switch.performAction 'toggle'"
        else
            @animate action.getRelativeDelta()
    
module.exports = Switch
