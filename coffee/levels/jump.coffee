
#       000  000   000  00     00  00000000 
#       000  000   000  000   000  000   000
#       000  000   000  000000000  00000000 
# 000   000  000   000  000 0 000  000      
#  0000000    0000000   000   000  000      

module.exports =
    name:       "jump"
    scheme:     "default"
    size:       [7,5,11]
    help:       """
                $scale(1.5)mission:
                get to the exit!
                
                to get to the exit,
                jump on the stone
                to jump,
                press "$key(jump)" while moving
                to move, press "$key(move forward)" or "$key(move backward)"
                to turn, press "$key(turn left)" or "$key(turn right)"
                """
    player:   
        coordinates:   [1,0,4]
        orientation:   minusXupY
    exits:    [
        name:         "exit"
        active:       1
        position:     [0,0,3]
    ]
    create: ->

        world.addObjectAtPos 'Wall', world.decenter 0,0,-2
        world.addObjectAtPos 'Wall', world.decenter 0,0,-4
        world.addObjectAtPos 'Wall', world.decenter 0,0, 1
        