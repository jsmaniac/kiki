# level design by Michael Abel

module.exports = 
    name:       "edge"
    scheme:     "candy_scheme"
    size:       [7,7,7]
    intro:      "edge"
    help:       "$scale(1.5)mission:\nget to the exit!"
    player:
        coordinates:  [3,0,0]
        nostatus:     0
        orientation:  rot0
    exits:    [
        name:         "exit"
        active:       1
        position:     [0,0,0]
    ]
    create: ->
        s=world.size
        
        # for (i,j,l) in [ (m,n,o) for m in range(3) for n in range(3) for o in range(3)]
        for i in [0...3]
            for j in [0...3]
                for l in [0...3]
                    if (i==2 or j==2 or l==2) and i>=1 and j>=1 and l >=1
                        c = 0.6 - (0.3)*Math.pow(-1, i+j+l)
                        d = 0.6 + (0.3)*Math.pow(-1, i+j+l)
                        world.addObjectAtPos(KikiStone(KColor(c ,0, d, 0.8), false), i,j,l)
                        world.addObjectAtPos(KikiStone(KColor(c ,0, d, 0.8), false), s.x-i-1,s.y-j-1,s.z-l-1)
                        world.addObjectAtPos(KikiStone(KColor(c ,0, d, 0.8), false), s.x-i-1,j,l)
                        world.addObjectAtPos(KikiStone(KColor(c ,0, d, 0.8), false), i,s.y-j-1,s.z-l-1)
    