
#    0000000   0000000   00000000   000000000  000   000  00000000   00000000  0000000  
#   000       000   000  000   000     000     000   000  000   000  000       000   000
#   000       000000000  00000000      000     000   000  0000000    0000000   000   000
#   000       000   000  000           000     000   000  000   000  000       000   000
#    0000000  000   000  000           000      0000000   000   000  00000000  0000000  

module.exports =

    name:       "captured"
    design:     'Niko Boehm'
    scheme:     "default"
    size:       [9,9,9]
    help:       """
                to get to the exit,
                move the stones.
                """
    player:     
        coordinates:    [2,3,2]
        orientation:    minusZdownX
    exits:      [
        name:         "exit"
        active:       1
        position:     [0,0,0]
    ]
    create: ->
        s = world.size
        
        for i in [-2, 2]
            world.addObjectPoly 'Stone', [world.decenter(1, 1, i), world.decenter(1, -1, i), world.decenter(-1, -1, i), world.decenter(-1, 1, i)]
            world.addObjectPoly 'Stone', [world.decenter(1, i, 1), world.decenter(1, i, -1), world.decenter(-1, i, -1), world.decenter(-1, i, 1)]
            world.addObjectPoly 'Stone', [world.decenter(i, 1, 1), world.decenter(i, 1, -1), world.decenter(i, -1, -1), world.decenter(i, -1, 1)]
        
        for i in [-4, -2, 2, 4]
            world.addObjectAtPos 'Stone', world.decenter i, 0, 0
            world.addObjectAtPos 'Stone', world.decenter 0, i, 0
            world.addObjectAtPos 'Stone', world.decenter 0, 0, i
