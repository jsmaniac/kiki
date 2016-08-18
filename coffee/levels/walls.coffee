# level design by Michael Abel

module.exports =
    name:       "walls"
    scheme:     "default_scheme"
    size:       [7,5,5]
    intro:      "walls"
    help:       """
                $scale(1.5)mission:
                    
                get to the exit!
                
                The exit is hidden
                in the middle of
                the central wall
                """
    player:
        coordinates:    [0,0,2]
        nostatus:       0
    exits:    [
        name:           "exit"
        active:         1
        position:       [0,0,0]
    ]
    create: ->
        s=world.size
    
        middlemax = (u,v,w) ->
            s=world.size
            d= 3.0/( (u-s.x/2.0)**2+ (v-s.y/2.0)**2 + (w-s.z/2.0)**2 + 1 )
            return min(1.0 ,max(0.2,d))
            
        middlemin = (u,v,w) ->
            s=world.size
            d= 2* ( (u-s.x/2.0)**2+ (v-s.y/2.0)**2 + (w-s.z/2.0)**2  )/25
            return min(1.0 ,max(0.4,d))
            
        # for (i,j,l) in [ (m,n,o) for m in range(s.x) for n in range(s.y) for o in range(s.z)]
        for i in [0...s.x]
            for j in [0...s.y]
                for l in [0...s.z]
                    if i==s.x/2 or i==s.x/2-2 or i==s.x/2+2
                        world.addObjectAtPos(KikiStone(KColor(0.1*i,0.1*j,0.1*l,0.6) , false) , i,j,l)
    