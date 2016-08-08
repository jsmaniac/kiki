module.exports =
    name:       "energy"
    scheme:     "default_scheme"
    size:       [9,17,9]
    intro:      "energy"
    help:       """
                $scale(1.5)mission:
                activate the exit!
                
                to activate the exit,
                shoot the 4 switches
                """
    player:   
        position:         [0,1,0]
        orientation:      roty90
    exits:    [
        name:         "exit"
        active:       0
        position:     [0,0,0]
    ],
    create: ->

        s = world.getSize()
        
        world.addObjectLine(KikiWall, [0, s.y/2, s.z/2], [s.x, s.y/2, s.z/2])
        world.addObjectLine(KikiWall, [s.x/2, s.y/2, 0], [s.x/2, s.y/2, s.z])
        world.deleteObject(world.getOccupantAtPos(world.decenter(0,0,0)))
        
        world.addObjectAtPos(KikiWall(), world.decenter(0, 3, 0))
        world.addObjectAtPos(KikiWall(), world.decenter(0, 6, 0))
        
        world.addObjectAtPos(KikiWall(), world.decenter(0, -4, 0))
        world.addObjectAtPos(KikiWall(), world.decenter( 2,-5, 1))
        world.addObjectAtPos(KikiWall(), world.decenter(-1,-5, 2))
        world.addObjectAtPos(KikiWall(), world.decenter(-2,-5,-1))
        world.addObjectAtPos(KikiWall(), world.decenter( 1,-5,-2))
        
        world.addObjectAtPos(KikiMutant(), world.decenter( 2,-5, 2))
        world.addObjectAtPos(KikiMutant(), world.decenter(-2,-5,-2))
        world.addObjectAtPos(KikiMutant(), world.decenter( 1,-5, 1))
        world.addObjectAtPos(KikiMutant(), world.decenter(-1,-5,-1))
        world.addObjectAtPos(KikiMutant(), world.decenter( 2,-5,-2))
        world.addObjectAtPos(KikiMutant(), world.decenter(-2,-5, 2))
        world.addObjectAtPos(KikiMutant(), world.decenter( 1,-5,-1))
        world.addObjectAtPos(KikiMutant(), world.decenter(-1,-5, 1))
        
        world.addObjectAtPos(KikiWall(), world.decenter( 0,  3, s.z/2))
        world.addObjectAtPos(KikiWall(), world.decenter( 0,  5, s.z/2))
        world.addObjectAtPos(KikiWall(), world.decenter( 1,  4, s.z/2))
        world.addObjectAtPos(KikiWall(), world.decenter(-1,  4, s.z/2))
        
        world.addObjectAtPos(KikiWall(), world.decenter(s.x/2, 3,  0))
        world.addObjectAtPos(KikiWall(), world.decenter(s.x/2, 5,  0))
        world.addObjectAtPos(KikiWall(), world.decenter(s.x/2, 4,  1))
        world.addObjectAtPos(KikiWall(), world.decenter(s.x/2, 4, -1))
        
        world.addObjectAtPos(KikiWall(), world.decenter( 0,  3, -s.z/2+1))
        world.addObjectAtPos(KikiWall(), world.decenter( 0,  5, -s.z/2+1))
        world.addObjectAtPos(KikiWall(), world.decenter( 1,  4, -s.z/2+1))
        world.addObjectAtPos(KikiWall(), world.decenter(-1,  4, -s.z/2+1))
        
        world.addObjectAtPos(KikiWall(), world.decenter(-s.x/2+1, 3,  0))
        world.addObjectAtPos(KikiWall(), world.decenter(-s.x/2+1, 5,  0))
        world.addObjectAtPos(KikiWall(), world.decenter(-s.x/2+1, 4,  1))
        world.addObjectAtPos(KikiWall(), world.decenter(-s.x/2+1, 4, -1))
        
        world.switch_counter = 0
        
        switched = (swtch) ->
            world.switch_counter += swtch.isActive() and 1 or -1
            exit = kikiObjectToGate (world.getObjectWithName("exit"))
            exit.setActive(world.switch_counter == 4)
        
        switch1 = KikiSwitch()
        switch1.getEventWithName("switched").addAction(continuous(()-> sw=switch1: switched(sw)))
        switch2 = KikiSwitch()
        switch2.getEventWithName("switched").addAction(continuous(()-> sw=switch2: switched(sw)))
        switch3 = KikiSwitch()
        switch3.getEventWithName("switched").addAction(continuous(()-> sw=switch3: switched(sw)))
        switch4 = KikiSwitch()
        switch4.getEventWithName("switched").addAction(continuous(()-> sw=switch4: switched(sw)))
        
        world.addObjectAtPos(switch1, world.decenter(-s.x/2+1, 4, 0))
        world.addObjectAtPos(switch2, world.decenter( s.x/2, 4, 0))
        world.addObjectAtPos(switch3, world.decenter(0, 4, -s.z/2+1))
        world.addObjectAtPos(switch4, world.decenter(0, 4,  s.z/2))
        