# level design by Michael Abel

module.exports =
    
    name:       "flower"
    scheme:     "metal_scheme"
    size:       [7,7,11]
    intro:      "flower"
    help:       """
                $scale(1.5)mission:
                get to the exit!
                
                the green stone is slicky
                you can't grab it while falling
                """
    player:
        coordinates:     [3,0,1]
        nostatus:         0
        orientation:     rot0
    exits:    [
        name:         "exit"
        active:       1
        position:     [0,0,0]
    ]
    create: ->
        s = world.size
        Stone = require './stone'
        for m in [[1,'Wall'], [2,'Stone']]
            for k in [-1*m[0],1*m[0]] 
                for l in [-1*m[0],1*m[0]]
                    world.addObjectLine m[1], s.x/2+k, s.y/2+l ,0, s.x/2+k, s.y/2+l ,3
                    world.addObjectLine m[1], s.x/2+k, s.y/2+l ,8, s.x/2+k, s.y/2+l ,s.z
               
        
        world.addObjectAtPos new Stone(KColor(0,1,0,0.5), true), world.decenter(1,0,0)
        world.addObjectAtPos new Stone(KColor(0,1,0,0.5), true), world.decenter(-1,0,0)
        world.addObjectAtPos new Stone(KColor(0,1,0,0.5), true), world.decenter(0,1,0)
        world.addObjectAtPos new Stone(KColor(0,1,0,0.5), true), world.decenter(0,-1,0)
    