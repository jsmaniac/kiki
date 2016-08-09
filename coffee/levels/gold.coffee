module.exports =
    name:       "gold"
    scheme:     "yellow_scheme"
    size:       [3,11,3]
    intro:      "gold"
    help:       """
                $scale(1.5)mission:
                get to the exit!
                
                move the stones to reach it
                """
    player:
        position:     [0,-4,0]
    exits:    [
        name:         "exit"
        active:       1
        position:     [0,4,0]
    ]
    create: ->
        s = world.size
        for y in [2,4,6,8]
            for x in [0...3]
                for z in [0...3]
                    world.addObjectAtPos('KikiStone', x, y, z)
