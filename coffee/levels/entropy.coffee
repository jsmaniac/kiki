# level design by Michael Abel

module.exports =

    name:       "entropy"
    scheme:     "green_scheme"
    size:       [9,9,9]
    intro:      "entropy"
    help:       """
                $scale(1.5)mission:
                get to the exit!
                
                use the stones to reach it
                """
    player:   
        coordinates:     [4,3,4]
        nostatus:         0
    exits:    [
        name:         "exit"
        active:       1
        position:     [0,0,0]
    ]
    create: ->
        s=world.size
        d=2
        # for (i,j,l) in [ (m,n,o) for m in range(s.x) for n in range(s.y) for o in range(s.z)]
        for i in [0...s.x]
            for j in [0...s.y]
                for o in [0...s.z]
                    if Math.pow(-1, i+j+l)==1  and not (d<=i<=s.x-d-1 and d<=j<=s.y-d-1 and d<=l<=s.z-d-1)
                        world.addObjectAtPos(KikiStone(KColor(0,0.8,0.2,0.8), true), KikiPos(i,j,l))

