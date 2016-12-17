#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

/*
 *   SENSE & SENSIBILITY
 *
 *   A demonstration of Senses, SensoryEmanations, SensoryEvents, 
 *   SenseConnectors, MultiLocs and the like.
 */


versionInfo: GameID
    IFID = 'd5025e2b-5181-8cbf-ec27-2858383d50a8'
    name = 'Sense and Sensbility'
    byline = 'by Eric Eve'
    htmlByline = 'by <a href="mailto:eric.eve@hmc.ox.ac.uk">
                  Eric Eve</a>'
    version = '0.3'
    authorEmail = 'Eric Eve <eric.eve@hmc.ox.ac.uk>'
    desc = 'A demonstration of Senses, Multilocs and the like in TADS.'
    htmlDesc = 'A demonstration of Senses, Multilocs and the like in TADS.'
;

/*
 *   The "gameMain" object lets us set the initial player character and
 *   control the game's startup procedure.  Every game must define this
 *   object.  For convenience, we inherit from the library's GameMainDef
 *   class, which defines suitable defaults for most of this object's
 *   required methods and properties.  
 */
gameMain: GameMainDef
    /* the initial player character is 'me' */
    initialPlayerChar = me
    showIntro()
    {
        "It looks a fine day now, but there have been several days of
        exceptionally heavy rain. The water is now pouring off the hills,
        swelling the river, and several severe flood warnings are in place.
        Your job is to make sure there's no one left in this part of town.\b";
    }
;

/*  
 *   We'll define a custom SquareRoom class to save ourselves a bit of 
 *   typing on each of the rooms representing the four corners of the square.
 */

class SquareRoom: OutdoorRoom
    /* 
     *   corner is a custom property. It will be used to hold a string saying
     *   which corner of the square this is: northeast, northwest, 
     *   southeast, or southwest.
     */
    corner = ''
    
    /*   
     *   We next use the custom corner property to construct the destName (a 
     *   standard library property) of this square).
     */
    destName = ('the ' + corner + ' corner of the square')
    
    /*   
     *   inRoomName is another library property. It's used to provide a 
     *   phrase describing something being in this room from the point of 
     *   view of another room. For example, if an object is in the northeast 
     *   corner of the square, then in the room description of any other 
     *   part of the square we want it described as being 'in the northeast 
     *   corner of the squaue', rather than just listed as if it were 
     *   immediately present.
     */
    inRoomName(pov) { return 'in ' + destName; }
;

//------------------------------------------------------------------------------
/*  
 *   We now create a square comprising four corners. These will be joined by 
 *   a DistanceConnector (see below) so that the player character can see 
 *   from any part of the square into any other part.
 */

squareNW: SquareRoom 'Main Square (NW)'
    "This square is said to date from the fourteenth century, and from the state
    of the surrounding buildings you can well believe it. The square continues
    to south and east, with a large ornamental fountain at the centre of the
    square blocking the way diagonally across the square to the southeast.
    A long building runs along the north side of the square; its entrance is
    off to the east, though a small window overlooks this corner of the square.
    To the west lies the way into the park. "
    
    corner = 'northwest'
    south = squareSW
    east = squareNE
    west = parkS
    
    /*  
     *   Below we shall be defining a SenseConnector representing a window 
     *   between this room and a chamber in the building to the north. This 
     *   means that when the PC is in squareNW objects inside the chamber 
     *   will also be listed. To make it clear where they are and how the PC 
     *   can see them we want them to be listed specially, preceded by 
     *   "Through the window, you see...". We do this be overriding 
     *   remoteRoomContentsLister().
     */
    
    remoteRoomContentsLister(other) 
    { 
        if(other == chamber)
            
            /*  
             *   CUSTOM ROOM LISTER
             *
             *   A lister that can be customized very simply by supplying two
             *   strings: a prefix string that comes before the list of 
             *   objects listed in the other location (here 'Through the 
             *   window you see') and a suffix string that comes after it 
             *   (here just a full-stop/period).
             */
            return new CustomRoomLister('Through the window, {you/he} see{s}', 
                                        '. '); 
        else
            return inherited(other);
    } 
    
;

/*  The Player Character */
+ me: Actor
    desc = "You're a young police officer. "    
;

+ Fixture 'old crumbling building*buildings' 'building'
    "It's very old, and looks a bit crumbling, but it's been there quite a few
    centuries now and will probably be around for several centuries to come. 
    Immediately to the north a window looks out from the building over the
    square. "
;


//------------------------------------------------------------------------------

squareNE: SquareRoom 'Main Square (NE)'
    "From this corner of the square a door leading into the building to the
    north. The square continues to south and west, with the fountain at its
    centre lying to the southwest. "
    corner = 'northeast'
    south = squareSE
    west = squareNW
    
    north = doorOutside
;

+ Enterable ->doorOutside 'grand building' 'building'
    "The building runs along the entire north side of the square, and looks
    rather grand, in a slightly faded sort of way. The door into the building
    is just to the north. "
;

++ doorOutside: Door ->doorInside 'door/entrance*doors' 'door'
;


//------------------------------------------------------------------------------

squareSW: SquareRoom 'Main Square (SW)'
    "The main street out of the square runs off to the south from here. The
    aquare continues to north and east, with the fountain at its centre
    blocking the way northeast. "
        
    corner = 'southwest'
    north = squareNE
    east = squareSE
    south: FakeConnector { "You can't leave until you make sure you've got
        everyone safely away from the area. " }
;

/*  
 *   TRAVEL PUSHABLE
 *
 *   A TravelPushable is an object that can be pushed from one location to 
 *   another but not picked up and carried.
 */
+ barrelOrgan: TravelPushable 'gaudy red barrel organ' 'barrel organ'
    "It's painted a gaudy red and has a handle that can be turned to crank out
    a tune. "
    
    /* 
     *   A TravelPushable is a NonPortable, so by default it would not be 
     *   listed in a room description, but since this one is moveable we'd 
     *   like it to me, so we override isListed to make it so.
     */
    isListed = true
    
    /*   
     *   By overriding these two messages we can customise what's shown when 
     *   the barrel organ is pushed from one place to another. The first 
     *   message is displayed just before the new room description is shown 
     *   and the second at the end of the new room description.
     */
    beforeMovePushable (traveler, connector, dest)
    { 
        "You push <<theName>> into <<dest.destName>>. ";
    }
    describeMovePushable (traveler, connector) 
    { 
        "<.p>\^<<theName>> comes to a stop. ";
    }
    
    dobjFor(Play) remapTo(Turn, handle)
;

++ handle: Component 'handle' 'handle'
    dobjFor(Turn)
    {
        verify() { }
        action()
        {
            "You turn the handle of the barrel organ a few times; it cranks out
            a wheezy version of some Verdi aria. ";
            
            /* When the music plays, trigger the associated SoundEvent. */
            organEvent.triggerEvent(self);
        }
    }
;

/*  
 *   SOUND EVENT 
 *
 *   A SoundEvent is a kind of SensoryEvent, the other kinds being SightEvent
 *   and SmellEvent. There'll be several SoundEvents in this game: this one 
 *   represents the playing of the barrel organ. A SoundEvent is something a 
 *   SoundObserver can react to, and we'll be defining a couple of those 
 *   below, as well as a few more SoundEvents. We shan't also be 
 *   demonstrating SightEvents and SmellEvents, since they work in almost 
 *   exactly the same way.
 *
 *   Note that organEvent doesn't represent a continuous sound, but rather 
 *   the event of the organ suddenly making a noise when we turn its handle. 
 */

organEvent: SoundEvent   
;

//------------------------------------------------------------------------------
squareSE: SquareRoom 'Main Square (SE)'
    "A long wooden bench stands in the southeast corner of the square, for the
    benefit of those who want to rest their legs. The square continues to north
    and west, but direct access to the northwest corner from here is blocked by
    the fountain at the centre of the square. "
    corner = 'southeast'
    north = squareNE
    west = squareSW    
;

+ Chair, Heavy 'long weatheredwooden bench' 'bench'
    "It looks well weathered, and you vaguely recall it was placed there in
    memory of some local worthy at the beginning of the last century. "
    bulkCapacity = 30
;

/*   
 *   SOUND OBSERVER /  PERSON 
 *
 *   Although any object can be a SoundObserver (or SightObserver or 
 *   SmellObserver), the objects most likely to respond to sensory stimuli 
 *   are animate ones, the obvious example of SoundObserver to give is a 
 *   Person, even though this isn't primarily a demo of NPCs. We'll keep 
 *   this NPC about as simple as possible except for the features we need to 
 *   demonstrate a SoundObserver. 
 */
++ oldLady: SoundObserver, Person 'wizzened old lady/woman/someone/person' 
    'old lady'
    "She looks rather wizzened. You wonder if she's as old as the bench she's
    sitting on. "
    posture = sitting
    isHer = true
    
    /*  
     *   The notifySoundEvent method is where we put the code defining the 
     *   SoundObserver's response to a SoundEvent.
     */
    notifySoundEvent(event, source, info) 
    { 
        /*  
         *   We'll make the old lady's response differ according to whether 
         *   the source of hand is close by or in a different corner of the 
         *   square.
         */
        if(source.isIn(getOutermostRoom))
            /* 
             *   There are a number of different soundEvents in the game, 
             *   and we'd like them to provoke different responses. We could 
             *   do this with a series of if statements or a switch 
             *   statement here, but it's neater and more in common with 
             *   TADS 3 programming style to farm actor responses out to 
             *   TopicEntry objects as possible, and we can do that by 
             *   calling initiateTopic here and defining the different 
             *   responses on a series of InitiateTopics.
             */
            initiateTopic(event);
        else
        {
          "<.p>The woman starts, wakes up momentarily, looking confused, then
          settles down to snooze again. ";
        }
    }
    uselessToAttackMsg = 'You\'ll be dismissed from the force and lose your
        pension if you start attacking old ladies. '
;

/*   
 *   ACTOR STATE
 *
 *   We could almost use a HermitActorState here, except that we want the 
 *   InitiateTopics to work.
 */

+++ ActorState
    /*  The old lady starts out in this ActorState. */
    isInitState = true
    
    /*  This will be appended to her description. */
    stateDesc = "She looks profoundly asleep. "
    
    /*  
     *   This is how she will be listed in a room description when the player
     *   character is in the same room as her.
     */
    specialDesc = "An old lady is snoozing on the bench.<.reveal lady> "
    
    /*   
     *   This is how she will be listed in a room description when the PC is 
     *   in a different part of the square.
     */
    remoteSpecialDesc(actor) 
    { 
        /*  
         *   When the PC first sees the old lady from a distance, it's not 
         *   clear who or what she is, so we just describe her as 'someone'. 
         *   Once the PC has seen the old lady close too, it'll be apparent 
         *   even from a distance that she's still the same old lady, so 
         *   we'll switch to calling her that.
         */        
        "<<gRevealed('lady') ? 'The old lady' : 'Someone'>> is sitting on the
        bench in the southeast corner of the square. "; 
    }
    
;

/*   
 *   INITIATE TOPIC
 *
 *   An InitiateTopic is executed in response to calling initateTopic() on 
 *   the actor. In this game we're doing that in response to SoundEvents.
 */
++++ InitiateTopic @whistleEvent
    "<.p>The old woman opens her eyes and covers her ears. Giving you a furious
    stare she snaps, <q>Do stop that <i>terrible</i> noise, officer! Can\'t
    you see I\'m trying to sleep?</q> Without waiting for a reply, she dozes
    off again. "
;

++++ InitiateTopic @yellEvent
    "<.p>The old lady wakes with a start and glares at you fiercely. <q>There's
    no need to shout!</q> she tells you, <q>It's quite unnecessary! When I was a
    girl, young people used to treat their elders with respect!</q>\b
    Her rebuke delivered, she dozes off agains traight away. "
;    


/*  
 *   Playing the trumpet in the presence of the old lady finally succeeds in 
 *   getting her attention, and so wins the game.
 */
++++ InitiateTopic @trumpetEvent
    topicResponse()
    {
        "<.p>The old woman wakes up with a start and springs smartly to
        attention. Now that you have her attention you explain about the
        imminent flooding, and the two of you leave the square together.<.p>";
        finishGameMsg(ftVictory, [finishOptionUndo]);
    }
;

/*  
 *   DEFAULT INITIATE TOPIC 
 *
 *   We use this DefaultInitiateTopic to deal with any SoundEvent for which 
 *   we haven't defined an InitiateTopic above.
 */

++++ DefaultInitiateTopic
    "<.p>The old woman wakes up and throws you a baleful glance. <q>Can't you
    let an old woman sleep?</q> she complains. Without waiting for a reply, she
    leans back, closes her eyes, and dozes straight off again. "
;

/*   
 *   DEFAULT ANY TOPIC
 *
 *   We use this DefaultAnyTopic to provide a response to any conversational 
 *   command addressed to the old lady.
 */
++++ DefaultAnyTopic
    "She ignores you, preferring to snooze on. "
;

//------------------------------------------------------------------------------

/*   
 *   DISTANCE CONNECTOR
 *
 *   The four corners of the square are in visual, auditory and olfactory 
 *   contact with each other (someone in one corner of the square can see 
 *   into the other three corners and hear what's going on there, and smells 
 *   could in principle cross from one corner of the square to the others). 
 *   We can represent that by using a DistanceConnector to join the four 
 *   corners of the square. It's a *Distance*Connector because although 
 *   there is sensory contact between the four corners of the square, it's 
 *   contact at a distance, rather then immediate (or 'transparent' in TADS 
 *   3 terminology), and that will effect the sensory information that is 
 *   passed (e.g. you can't touch distant objects or see the details of 
 *   smaller distant objects).
 */
DistanceConnector [squareNW, squareNE, squareSW, squareSE];

/*  
 *   MULTILOC
 *
 *   The fountain stands at the centre of the square, and is thus equally 
 *   accessible from all four corners. We can represent this by making the 
 *   fountain a MultiLoc (which must be mixed-in with one or more 
 *   Thing-derived classes in order to represent a physical object) and 
 *   locating it in all four corners of the square.
 */
fountain: MultiLoc, Container, Fixture 'stone fountain/figure/pool' 'fountain'
    "Whatever the stone figure originally was at the centre of the fountain, it
    has long since been worn unrecognizable by the water constantly pouring from
    it into the pool. "   
    locationList = [squareNW, squareNE, squareSW, squareSE]
;

/*  
 *   Note that while this coin is in the fountain it can be taken from any 
 *   corner of the square.
 */
+ coin: Thing 'old copper coin/penny' 'copper coin'
    "It's just an old penny. "
;

/*  
 *   SIMPLE NOISE
 *
 *   The sound of the fountain doesn't need to be described different under 
 *   different circumstances, so we can use a SimpleNoise to represent it.
 */
+ SimpleNoise 'gentle tinkling sound' 'tinkling'
    "A gentle tinkling sound comes from the fountain. "
;

+ Decoration 'water' 'water'
    "It's pretty transparent, and undoubtedly wet. "
    notImportantMsg = 'You\'re happy to leave the water alone. '
;

/*  
 *   MULTILOC, DISTANT
 *
 *   We can also use a MultiLoc to represent a distant object that can be 
 *   seen (and looks much the same) from a number of different locations. 
 *   One obvious example would be the sun, which should be visible from 
 *   every outdoor location.
 */
MultiLoc, Distant 'bright shining sun' 'sun'
    "The sun is shining bright today -- far too bright to look at directly. "
    
    /*  
     *   Rather than listing each OutdoorRoom, we can simply specify that 
     *   the sun should appear in every OutdoorRoom.
     */
    initialLocationClass = OutdoorRoom
;


//------------------------------------------------------------------------------

hall: Room 'Hall'
    "This hall is almost empty; whoever lives here has obviously taken the
    precaution of packing everything away and putting it in safe storage in
    anticipation of the flood. A door leads out to the south, and a second exit
    leads west. "
    south = doorInside
    west = chamber
    out asExit(south)
;

+ doorInside: Door 'door' 'door'
;

+ ladder: Platform 'long wooden sturdy ladder' 'ladder'
    "It's quite long, and looks reasonably sturdy. "
    initSpecialDesc = "A long wooden ladder leans against the wall. "
    dobjFor(Climb) asDobjFor(StandOn)
    dobjFor(ClimpUp) asDobjFor(StandOn)
    dobjFor(ClimbDown) asDobjFor(GetOffOf)
    bulk = 8
    
    /*  
     *   You can't lie down on a ladder, and you wouldn't normally think of 
     *   sitting on one.
     */
    allowedPostures = [standing, sitting]
    obviousPostures = [standing]
;


//------------------------------------------------------------------------------

chamber: Room 'Chamber'
    "This chamber is almost as bare as the hall, and presumably for much the
    same reasons; just about everything has been safely packed away elsewhere in
    case of flooding. From the shape and size of the room and the style of the
    wallpaper you'd guess that in normal times it might be a sitting-room. A
    window overlooks the square to the north, but the only way out is to the
    east. "
    east = hall
    out asExit(east)
;

+ Decoration 'green striped wallpaper' 'wallpaper'
    "It's striped, in alternativing shades of green. "
;

+ OpenableContainer 'large packing wooden case/box*boxes' 'large wooden box'
    "It might be a packing case of some sort. "
    /*  
     *   By specifying that the box is made of 'paper' we allow sounds and 
     *   smells (but not sight or touch) to pass through it even when it's 
     *   closed. This means that we can hear the radio (when it's on) even 
     *   when it's shut in the box.
     */
    material = paper
    bulkCapacity = 4
;

/*  
 *   SWITCH
 *
 *   A Switch is something that can be switched on and off. Here we use it to
 *   implement a radio that makes a noise only when it's turned on.
 */
++ radio: Switch 'radio' 'radio'
    isOn = true
    makeOn(stat)
    {
        inherited(stat);
        if(stat)
        {
            "Turning on the radio makes a sudden burst of loud music pour forth.
            ";
            /* 
             *   When the radio is turned on, trigger a SoundEvent to 
             *   represent the sudden incidence of a loud noise that wasn't 
             *   there before.
             */
            musicEvent.triggerEvent(radio);
        }
        else
            "The radio falls silent. ";
    }
;

/*  
 *   NOISE
 *
 *   We can create a Noise object to represent the sound the radio makes when
 *   it's turned on. Note the distinction between this Noise (which 
 *   represents the ongoing SensoryEmanation that occurs for as long as the 
 *   radio is on) and the musicEvent SensoryEvent which represents the event 
 *   of the radin being turned on (a continuously playing radio might fade 
 *   into the background of our consciousness; a radio suddenly turned on is 
 *   likely to burst in on our consciousness; the Noise represents the 
 *   former and the SoundEvent the latter.
 */
+++ Noise 'loud operatic sound/noise/music/wagner' 'music'
    /*  The noise is only audible when the radio is turned on. */
    isEmanating = (radio.isOn)
    
    /*  The description to be added to the description of the radio. */
    sourceDesc = "It's playing music. "
    
    /*  The response to LISTEN TO MUSIC when we can see the radio. */
    descWithSource = "The radio is playing something loud and operatic -- Wagner
        perhaps. "
    
    /*  The response to LISTEN TO MUSIC when we can't see the radio. */
    descWithoutSource = "The music sounds loud and operatic -- Wagner
        perhaps. "
    
    /*  The response to LISTEN when we can see the radio. */
    hereWithSource = "The radio is playing some loud music. "
    
    /*  The response to LISTEN when we can't see the radio. */
    hereWithoutSource = "There's some loud music playing. "
    
    /*  
     *   A message to display when we could hear the music but can't any 
     *   longer because it's just gone out of scope.
     */
    noLongerHere = "You can no longer hear the music. "
    
    /*  
     *   Show the hereWithSource or hereWithoutSource message with decreasing
     *   frequency.
     */
    displaySchedule = [2, 4, 8, 16]
    
    /*  We want the parser to refer to 'music' not 'a music'. */
    aName = (name)
;

+ whistle: Instrument 'silver whistle' 'whistle'
    "It's silver in colour, a bit like a policeman's whistle. "
    
    /*  
     *   The following two properties are custom properties we define on our 
     *   custom Instrument class, for which see below. Since there are two 
     *   musical instruments in the game -- this whistle and a trumpet -- we 
     *   can save ourselves some work by defining a new class to implement 
     *   their common behaviour and then just customizing individual 
     *   Instruments with these two properties. 
     *
     *   When the whistle is blown, whistleEvent will be triggered, and the 
     *   message "You bloe a shrill blast on the whistle" displayed.
     */
    soundEvent = whistleEvent
    playDesc = 'You blow a shrill blast on the whistle. '
;

/*  The two SoundEvents referred to above. */

musicEvent: SoundEvent;
whistleEvent: SoundEvent;

//------------------------------------------------------------------------------
/*  
 *   SENSECONNECTOR,  INTANGIBLE
 *
 *   A SenseConnector can be used to pass any combination of senses between 
 *   two or more locations in a variety of ways. Here we'll keep it simple 
 *   and define a SenseConnector that passes sound (or smells) between the 
 *   hall and the chamber (so that the radio can be heard from the hall when 
 *   it's playing in the chamber).
 *
 *   A SenseConnector needs to be mixed in with some Thing-derived class, 
 *   and if we don't want it to represent a particular physical object we 
 *   can use Intangible to mix it with (one of the few things the Intangible 
 *   class is useful for). We probably don't need to give it a vocabWords 
 *   and name property, but we do so just in case the parser needs to refer 
 *   to it for some reason.
 */
SenseConnector, Intangible 'wall' 'wall'
    /* We want this connector to pass sound (and smell) only. */
    connectorMaterial = paper
    locationList = [hall, chamber]
;

/*  
 *   SENSECONNECTOR, OCCLUDER 
 *
 *   Both squareNW and chamber mention a window - the same window, in fact, 
 *   seen from different sides. A window is something one would expect to be 
 *   able to see through, so it's another good candidate for a 
 *   SenseConnector. This time, though, the SenseConnector is a physical 
 *   object (the window).
 *
 *   But there's a limit to what can be seen through the window. You probably
 *   couldn't see in through the window from any part of the square except 
 *   that immediately adjoining it, and though you could probably see out of 
 *   it onto most of the square, you might not be able to see the northeast 
 *   corner of the square. To limit what can be seen through the window we 
 *   can make an Occluder as well.
 *
 *   One can often open and close windows, so we should make it an Openable 
 *   too.
 */


window: SenseConnector, Occluder, Openable,  Fixture 'small window' 'window'
    
    /* 
     *   If the window is open you'd expect to be able to hear through it 
     *   (and smell through it) as well as see through it; if it's closed 
     *   you might only be able to see through it, so we vary its 
     *   connectorMaterial according to whether the window is open or closed.
     */
    connectorMaterial = (isOpen ? fineMesh : glass)
    
    locationList = [chamber, squareNW]
    
    /*   
     *   The occludeObj method is used to decide what objects can't be sensed
     *   through the window; if this method returns true for any obj, then 
     *   that obj can't be sensed.
     *
     *   Writing occludeObj methods that do what you want can be tricky; it 
     *   can be very easy to get them wrong, introducing strange bugs that 
     *   make objects disappear for no apparent reason.
     */
    occludeObj(obj, sense, pov)
    {
        /* 
         *   If the pov is inside the chamber, we probably can't see what's 
         *   in the northeast corner of the square
         */
        if(pov.isIn(chamber) && obj.isIn(squareNE))
            return true;
        
        /*  
         *   If the pov is out in the square, it's most unlikely we could 
         *   see in through the window except from the northwest corner.
         */
        if(pov.getOutermostRoom.ofKind(SquareRoom) && !pov.isIn(squareNW) &&
           obj.isIn(chamber) && sense == sight)
            return true;
        
        /*   
         *   This is a bit of a hack to restrict what the player character 
         *   can see when looking through the window. The idea is to occlude 
         *   eveything on the actor's side of the window so he only seens 
         *   what's on the other side when he looks through. But we must not 
         *   occlude the actor himself.
         */        
        if(gActionIs(LookThrough) && gDobj==self && obj != gActor
           && ((pov.isIn(chamber) && obj.isIn(chamber))
               || (!pov.isIn(chamber) && !obj.isIn(chamber))))
            return true;        
        
        return inherited(obj, sense, pov);
    }
    
    /*  
     *   One obviously ought to be able to Look Through a window, but we 
     *   need to define handling for this specially.
     */         
    dobjFor(LookThrough)
    {
        action()
        {
            /* 
             *   First print some introductory text depending on the 
             *   location of the actor who's doing the looking.
             */
            "You look <<gActor.isIn(chamber) ? 'out' : 'in'>> through the
            window and see <<gActor.isIn(chamber) ? 'the square' : 'a
                chamber'>>.\b";
            
            /*   
             *   Then list the objects that can be seen through the window 
             *   from the point of view of the actor. Here we do this my 
             *   calling a method that would normally list all the objects 
             *   visible to the actor; we use occludeObj() to exclude the 
             *   ones we don't want listed here (such as those in the same 
             *   room as the actor, which s/he won't see when s/he's looking 
             *   through the window.)
             */
            gActor.lookAround(LookListSpecials | LookListPortables);
        }
    }
    
        
    cannotGoThroughMsg = 'The window is not big enough for you to fit through. '
    cannotEnterMsg = (cannotGoThroughMsg)
;

//------------------------------------------------------------------------------
/*  
 *   DISTANCE CONNECTOR 
 *
 *   We're about to implement a park comprising two locations, so we'll 
 *   start by joining them together with a DistanceConnector, so that we can 
 *   see from one end of the park into the other. 
 */

DistanceConnector [parkS, parkN];

parkS: OutdoorRoom 'Park (South)'
     "The park occupies a large area, peppered with trees, shrubs and bushes.
     An abandonded bonfire is smouldering down by the swollen river. The park
     continues to the north, and the way back to the square lies eastwards. "
    east = squareNW
    north = parkN
    
    /*  
     *   The phrase to use to describe the location of objects left here when
     *   viewed from the other end of the park.
     */
    inRoomName(pov) { return 'in the south end of the Park'; }
;

+ Fixture 'smouldering bonfire/fire' 'bonfire'
    "It's still smouldering nicely, giving off lots of smoke. But it won't be
    for much longer if the river bursts its banks. "
    feelDesc = "It feels hot. "
;

/*  
 *   VAPOROUS
 *
 *   Vaporous is just the class to use for visible not quite tangible things 
 *   like smoke. 
 */
++ Vaporous 'billowing  thick smoke' 'smoke'
    "Thick smoke is billowing up from the smouldering fire. "
    
    /* We don't want the parser referring to 'a smoke' or even 'some smoke' */
    aName = (name)
    
    /*  The smoke should be clearly visible from a distance. */
    sightSize = large
;

/*  
 *   SIMPLE ODOR
 *
 *   We can use the same description for the smell of the smoke under any 
 *   circumstances we want to describe it (as a response to SMELL, SMELL 
 *   SMOKE or SMELL ACRID SMELL), so a SimpleOdor will do to represent the 
 *   smell of the smoke.
 */
+++ SimpleOdor 'acrid smell/(smoke)' 'smell'
    "The acrid smell of smoke wafts from the bonfire down by the river. "
    isAmbient = nil
    
    /* The smell should be quite apparent at a distance. */
    smellSize = large
    displaySchedule = [2, 4, 8]
;

//------------------------------------------------------------------------------


parkN: OutdoorRoom 'Park (North)'
    "The park occupies a large area, peppered with trees, shrubs and bushes,
    bounded by the swollen river to the west. The park continues to the south. "
    
    south = parkS
    
    /*  
     *   The phrase to use to describe the location of objects left here when
     *   viewed from the other end of the park.
     */
    inRoomName(pov) { return 'in the north end of the Park'; }
;

+ Fixture 'tall elm tree' 'elm tree'
    "It's really quite tall. "
    sightSize = large
;


/*  
 *   OUT OF REACH
 *
 *   We don't want the player character to be able to reach the trumpet 
 *   without the ladder, so we can put it out of reach using the OutOfReach 
 *   class, mixed in with a Surface and Fixture used to represent the branch.
 */
++ OutOfReach, RestrictedSurface, Fixture 'branch' 'branch'
    "It's about half way up the tree. "
    
    /*  
     *   The PC can only reach this branch if s/he's standing and on the 
     *   ladder/
     */
    canObjReachContents(obj)
    {
        return obj.posture == standing && obj.isIn(ladder);
    }
    
    /* 
     *   We won't allow anything other than the trumpet to be put on the 
     *   branch.
     */
    validContents = [trumpet]
;

/*  
 *   The trumpet is the second instrument in the game. Once again we'll use 
 *   our custom Instrument class (defined below).
 */
+++ trumpet: Instrument 'brass trumpet/object/instrument' 'trumpet'
    "Despite its sojourn up an elm tree, it looks in perfectly good working
    order. "
    
    /*  The description of the trumpet until it's moved. */
    initDesc = "It's a strange place for a trumpet, perhaps someone left it
        there for a prank, or perhaps someone felt a strange urge to play their
        trumpet halfway up an elm tree. "
    
    /*  
     *   The initial (until moved) description of the trumpet in a room 
     *   description when it's viewed from a remote location (the other end 
     *   of the park).
     */
    remoteInitSpecialDesc (actor)
    {
        "The sun glints off a brass object somewhere up a tree in the north end
        of the park. ";
    }
    initSpecialDesc = "For some reason, there's a trumpet hanging from a branch
        half-way up the elm tree. "
    
    /*  The sound event that's triggered when the trumpet is played. */
    soundEvent = trumpetEvent
    
    /*  The text that's displayed when the trumpet is played. */
    playDesc = 'You blast out a stirring rendition of the National Anthem. '
;

+ basket: OpenableContainer 'small wicker basket' 'small wicker basket'
    "It looks like the sort of basket that might be used by a fisherman. "
    /* 
     *   By specifying the material of the basket as paper we make it 
     *   possible to smell what's inside even when the basket is closed.
     */
    material = paper
    bulkCapacity = 2
    initSpecialDesc = "A small wicker basket lies abandoned by the river. "
    
    /*  
     *   Another way of specifying how the basket should be listed in a room 
     *   description when viewed from afar.
     */
    distantInitSpecialDesc = "Through the trees and shrubs you can just make out
        a basket sitting by the river in the far end of the park. "
;


/* Something smelly in the basket */
++ fish: Thing 'rotting fish/herring' 'rotting fish'
    "It's hard to tell what it was -- a herring perhaps (possibly a red one). "
    cannotEatMsg = 'It looks far too far gone to be edible. '
    tasteDesc = "<<cannotEatMsg>>"
    
;

/*  
 *   ODOR
 *
 *   We use an Odor object to represent the smell of the fish. This object 
 *   can describe the smell of the fish in a number of ways, as illustrated 
 *   below.
 */

+++ Odor 'terrible rotting smell/stink/stench/(fish)' 'terrible rotting smell'
    
    /* 
     *   The response to SMELL FISH (when we can see the fish); it's also 
     *   appended to the description of the fish when we EXAMINE FISH
     */
    sourceDesc = "It smells horribly. "
    
    /* The response to SMELL STENCH when we can see the fish */
    descWithSource = "It's the now quite unmistakeable smell of rotting fish. "
    
    /* The response to SMELL STENCH when we can't see the fish */
    descWithoutSource = "It's a truly horrible smell; something rotting -- a
        fish perhaps. "
    
    /* The response to SMELL when we can see the fish */
    hereWithSource = "A terrible rotting smell comes from the fish. "
    
    /* The response to SMELL when we can't see the fish */
    hereWithoutSource = "There's a terrible smell of something rotting. "
    
    /* As horrible as the smell is, we probably can't smell it at a distance */
    smellSize = small
    
    /* 
     *   The intervals at which we mention the smell of the fish; first 
     *   every two turns, then every four turns, then every eight turns, 
     *   then every sixteen turns. This is meant to represent the fact that 
     *   the smell of the fish would tend to fade from the foreground of the 
     *   PC's attention as s/he grew more used to it.
     */
    displaySchedule = [2, 4, 8, 16]
;

/*  The SoundEvent associaated with playing the trumpet. */

trumpetEvent: SoundEvent
;

//------------------------------------------------------------------------------
/*  
 *   MULTIFACETED
 *
 *   A MultiFaceted object is one that runs through several locations, such 
 *   as this river that runs along the west side of the park. Whereas the 
 *   MultiLoc statue in the square was one physical object in one location 
 *   accessible from all four corners of the square (because it lay on their 
 *   joint boundaries at the centre of the square, in the case of the river 
 *   we have two segments of the same object (the river) that are 
 *   nevertheless physically distinct.
 */

MultiFaceted
    locationList = [parkS, parkN]
    instanceObject: Fixture { 'river/bank/banks/water' 'river' 
         "The river running along the west side of the park is flowing much
         faster than usual, and looks exceptionally high; it could burst its
         banks at any moment. "
      }    
;

/*  
 *   MULTI INSTANCE    SOUND OBSERVER
 *
 *   A MultiInstance is very like a MultiFaceted, expect that it is used to 
 *   represent similar but numerically distinct objects in different 
 *   locations, like trees in a forest (or here, flora in a park). 
 *
 *   We also use these MultiInstance trees to show that an inanimate object 
 *   can be used as a SoundObserver (though here it's notionally the birds 
 *   nesting in these trees that respond to sudden sounds) .
 */

MultiInstance
    locationList = [parkS, parkN]
    instanceObject: SoundObserver, Decoration
    {
        'tree/shrub/bush/trees/shrubs/bushes' 'trees, shrubs and bushes'
        "A variety of trees, shrubs and bushes have been tastefully distributed
        around the park, and carefully tended over the years. You only hope that
        they won't be damaged by the flood waters if and when the river bursts
        its banks. "
        isPlural = true
        
        /*  
         *   The response we get from the trees if a SoundEvent is triggered 
         *   in their vicinity.
         */
        notifySoundEvent(event, source, info) 
        {
            "The sudden noise makes a flock of birds take flight and flutter
            away from the trees. ";
        }
    }
;

//==============================================================================

/*  
 *   We've defined a couple of Musical Instruments, now we need to define a 
 *   custom Play action so they can be played or blown.
 */
DefineTAction(Play)
;

VerbRule(Play)
    ('play' | 'blow') singleDobj
    : PlayAction
    verbRule = 'play/playing (what)'
;


/*  We need to ensure that there's handling for the PlayAction on Thing. */
modify Thing
    dobjFor(Play)
    {
        preCond = [touchObj]
        verify() { illogical('You/he} can\'t play {that dobj/him}. '); }
    }
;


/*  
 *   Finally, we define our custom Instrument class, so that it knows how to 
 *   handle a Play command.
 */
class Instrument: Thing
    dobjFor(Play)
    {
        /* We need to hold a wind instrument in order to play it. */
        preCond = [objHeld]
        verify() {}
        action()
        {
            /* Display the custom playDesc property. */
            mainReport(playDesc);
            
            /* trigger the SoundEvent associated with this instrument. */
            if(soundEvent)
                soundEvent.triggerEvent(self);
        }
    }
    
    /*  The SoundEvent associated with this instrument. */
    soundEvent = nil
    
    /*  The description of this instrument being played. */
    playDesc = nil     
;

/*  
 *   Yelling also makes a noise, so we'll associate a SoundEvent with that too.
 */

modify YellAction
    execAction()
    {
        inherited;
        yellEvent.triggerEvent(gActor);
    }
;

yellEvent: SoundEvent;