#charset "us-ascii"

/*   
 *   BEDSITTERLAND
 *
 *   A demonstration of the TADS 3 NestedRoom classes.
 *
 *   This is only minimally a game; there's nothing for the player to do but 
 *   try out the various kinds of NestedRoom. The 'game' is also fairly 
 *   minimal in that very little has been implemented apart from what's 
 *   necessary to show the various NestedRoom classes.
 */


/*
 *   Copyright (c) 1999, 2002 by Michael J. Roberts.  Permission is
 *   granted to anyone to copy and use this file for any purpose.  
 *   
 *   This is a starter TADS 3 source file.  This is a complete TADS game
 *   that you can compile and run.
 *   
 *   To compile this game in TADS Workbench, open the "Build" menu and
 *   select "Compile for Debugging."  To run the game, after compiling it,
 *   open the "Debug" menu and select "Go."
 *   
 *   This is the "advanced" starter game - it has only the minimum set of
 *   definitions needed for a working game.  If you would like some more
 *   examples, create a new game, and choose the "introductory" version
 *   when asked for the type of starter game to create.  
 */

/* 
 *   Include the main header for the standard TADS 3 adventure library.
 *   Note that this does NOT include the entire source code for the
 *   library; this merely includes some definitions for our use here.  The
 *   main library must be "linked" into the finished program by including
 *   the file "adv3.tl" in the list of modules specified when compiling.
 *   In TADS Workbench, simply include adv3.tl in the "Source Files"
 *   section of the project.
 *   
 *   Also include the US English definitions, since this game is written
 *   in English.  
 */
#include <adv3.h>
#include <en_us.h>

/*
 *   Our game credits and version information.  This object isn't required
 *   by the system, but our GameInfo initialization above needs this for
 *   some of its information.
 *   
 *   You'll have to customize some of the text below, as marked: the name
 *   of your game, your byline, and so on.
 */
versionInfo: GameID
    IFID = '6143aa2f-80cf-2cd5-270f-1fb483da24e1'
    name = 'Bedsitterland'
    byline = 'by Eric Eve'
    htmlByline = 'by <a href="mailto:eric.eve@hmc.ox.ac.uk">
                  Eric Eve</a>'
    version = '0.5'
    authorEmail = 'Eric Eve <eric.eve@hmc.ox.ac.uk>'
    desc = 'A demonstration of TADS NestedRoom classes'
    htmlDesc = 'A demonstration of TADS NestedRoom classes'
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
        "This bedsit was the best accommodation you could find at short notice;
        now it looks like you'll be stuck here for at least the next few months,
        so you may as well try out the furniture.\b";
    }
    
    /* 
     *   Reverse the current normal order of before and check routines. This 
     *   normally gives better results.
     */
    
    beforeRunsBeforeCheck = nil
;

//==============================================================================
/* 
 *   A MODIFICATION TO NESTED ROOM
 *
 *   By default the library enforces no reachability conditions when the 
 *   actor is in an ordinary NestedRoom, but this can seem a bit 
 *   unrealistic. For example the standard library behaviour would allow the 
 *   PC to open the wardrobe while lying on the bed, and this is surely 
 *   rather implausible.
 *
 *   The following modification to NestedRoom changes that behaviour by 
 *   making an actor leave a NestedRoom in order to perform an action that 
 *   requires touching an object that's not in the NestedRoom.
 * 
 */
 
modify NestedRoom
     
    /* 
     *   checkTouchViaPath() is a standard library method defined on Thing 
     *   (and on some of Thing's subclasses). Here we use it to enforce the 
     *   condition that an actor in NestedRoom can't touch anything outside 
     *   that NestedRoom (apart from author-defined exceptions).
     */
    
    checkTouchViaPath(obj, dest, op)
    {
        /* 
         *   Allow an actor in this NestedRoom to touch the NestedRoom 
         *   itself, plus anything defined as being reachable from inside the
         *   NestedRoom, but nothing else that's not in the NestedRoom.
         */
        if(op == PathOut && dest != self && !canReachFromInside(obj, dest))
           return new CheckStatusFailure(cannotReachFromInsideMsg(dest), dest);
                           
        return inherited(obj, dest, op);
    }
    
    /* 
     *   Display a suitable message explaining why the actor (obj) can't 
     *   touch the object (dest) that's outside this NestedRoom. Note, this 
     *   is not a standard method on NestedRoom - we've "borrowed" it from 
     *   OutOfReach.
     */
    
    cannotReachFromInsideMsg(dest)
    {
        return 'You can\'t reach ' + dest.theName + ' from ' + theName + '. ';
    }
   
    /*  
     *   canReachFromInside() is likewise a custom method (on NestedRoom), 
     *   though the library does define it on OutOfReach. Here we use it to 
     *   determine which objects outside this NestedRoom (if any) an actor 
     *   can reach from inside. Here obj is the actor doing the reaching and 
     *   dest is the object the actor is trying to reach. 
     *
     *   By default, we don't allow an actor inside us to reach anything 
     *   outside us.
     */
    
    canReachFromInside(obj, dest) { return nil; }
   
    
    /*  
     *   This is a standard library method which is called when someone can't
     *   touch through us. Here we assume that since the problem is limited 
     *   reach from within this NestedRoom the way to remove the obstructor 
     *   (i.e. to bring the target object within reach) is simply to leave 
     *   this NestedRoom.
     */
    
    tryImplicitRemoveObstructor(sense, obj)
    {       
        return tryRemovingFromNested();
    }
      
;

/* 
 *   ROOM
 *
 *   Starting location - we'll use this as the player character's initial 
 *   location.  The name of the starting location isn't important to the 
 *   library, but note that it has to match up with the initial location for 
 *   the player character, defined in the "me" object below.
 *
 *   Our definition defines two strings.  The first string, which must be in 
 *   single quotes, is the "name" of the room; the name is displayed on the 
 *   status line and each time the player enters the room.  The second 
 *   string, which must be in double quotes, is the "description" of the 
 *   room, which is a full description of the room.  This is displayed when 
 *   the player types "look around," when the player first enters the room, 
 *   and any time the player enters the room when playing in VERBOSE mode.
 *
 *   The name "startRoom" isn't special - you can change this any other name 
 *   you'd prefer.  The player character's starting location is simply the 
 *   location where the "me" actor is initially located.  
 */
startRoom: Room 'Your Bedsit'
    "One thing that can be said for this room is that it is at least reasonably
    large. Whoever furnished it seems to have been in two minds about sleeping
    arrangements, since in addition to the conventional bed over in one corner,
    there's a bunk high up on one wall, over a short wooden bench. Fortunately
    the bench is not the only thing to sit on, since there's also a comfortable
    armchair and a long sofa. There's also a large desk, situated under a
    bookshelf that's fixed inconveniently high up the wall, and a built-in
    wardrobe large enough to walk into. "
    north = door
        
;

/*
 *   ACTOR
 *
 *   Define the player character.  The name of this object is not important, 
 *   but it MUST match the name we use to initialize 
 *   gameMain.initialPlayerChar above.
 *
 *   Note that we aren't required to define any vocabulary or description 
 *   for this object, because the class Actor, defined in the library, 
 *   automatically provides the appropriate definitions for an Actor when 
 *   the Actor is serving as the player character.  Note also that we don't 
 *   have to do anything special in this object definition to make the Actor 
 *   the player character; any Actor can serve as the player character, and 
 *   we'll establish this one as the PC in main(), below.  
 */
+ me: Actor
    desc = "You can't bear to look at yourself right now; you've come down so
        far in the world to end up in this place! "
    
    
    /*  
     *   There's a bed here, to the player might reasonably try to sleep. If 
     *   the PC is not already on the bed when the command is issued, it 
     *   makes sense to move him/her there with an implicit command first.
     */
    goToSleep()
    {
        bed.checkMovingActorInto(true);
        "You drop off to sleep and dream of better times. You wake up again
        after an indeterminate period. ";
    }
;

/*  
 *   CHAIR
 *
 *   A chair is something that you would normally sit on. By default you can 
 *   also stand on it. GET ON CHAIR will be treated as SIT ON CHAIR.
 *
 *   We'll make this Chair an Immovable, since it's not something the PC is 
 *   meant to walk around with. 
 *
 *   By default the allowedPostures on a Chair are sitting and standing, but 
 *   the only obvious posture is sitting. This means that the parser find 
 *   standing on a chair to be nonObvious (in the verify routine) so it will 
 *   never choose such a chair as a default direct object of a Stand On 
 *   command, or as a possible direct object on an ambiguous Stand On 
 *   command. This can have seemingly perverse consequences, in that if the 
 *   player types an ambiguous command like STAND ON CHAIR, the parser will 
 *   select a chair for which standing is not an allowed posture in 
 *   preference to one for which it's an allowed but not obvious posture.
 *
 *   You'll see this seemingly odd behaviour exemplified in this game; try 
 *   STAND ON CHAIR and you'll find that the parser complains that you can't 
 *   stand on the swivel chair (defined below) rather than choosing this 
 *   armchair which you would be allowed to stand on.
 */
 

+ armchair: Chair, Immovable 'arm neutral grey gray comfortable
    chair/armchair*chairs*furniture*seating' 
    'armchair'
    "It's a neutral gray in colour, but looks comfortable enough. "
    cannotTakeMsg = 'You could take the armchair, but it would be a bulky thing
        to walk around with, so you\'d rather not bother. '
;

/*   
 *   CHAIR 
 *
 *   By default a Chair cannot be lain on, but a sofa might be long enough to
 *   allow someone to lie on, so here we'll override allowedPosture to allow
 *   this. We'll make the sofa a Heavy as well, since something that size 
 *   would presumably be too heavy to pick up.
 */

+ sofa: Chair, Heavy 'long sofa/settee*chairs*furniture*seating' 'sofa'
    "It could easily sit three people; alternatively there's plenty of room for
    you to stretch yourself out on it. "
    allowedPostures = [sitting, standing, lying]
;

/*  
 *   BED
 *
 *   A bed is something that you would normally lie on, although by default 
 *   you can also sit or stand on a Bed. Since people are more likely to sit 
 *   on a bed than stand on one, sitting is also among the obviousPostures 
 *   but standing is not. 
 *
 *   GET ON BED is equivalent to LIE ON BED.
 */


+ bed: Bed, Heavy 'single bed*beds*furniture' 'bed'
    "It's just a standard size single bed, about three feet wide and six long.
    The space underneath it is taken up with a drawer in which you could store
    some of your things. "
    nothingUnderMsg = 'The space under the bed is taken up by the drawer. '
;

/*  
 *   OPENABLE CONTAINER
 *
 *   Since we described the bed as having a drawer underneath, we should 
 *   implement it.
 */

++ drawer: OpenableContainer, Component 'long drawer' 'drawer'    
    "It would have made more sense to put a pair of drawers under the bed, but
    there's only one. "
;

+++ pillow: Thing 'spare pillow' 'spare pillow'
    bulk = 3
;


/*  
 *   BOOTH
 *
 *   A Booth is something an actor can enter. By default GET IN BOOTH is 
 *   treated as STAND ON (i.e. IN) BOOTH, but sitting or lying are regarded 
 *   as both allowed and obvious.
 */

+ wardrobe: Openable, Booth, Fixture 'built-in white painted large wardrobe' 
    'wardrobe'
    "It's painted white, and looks large enough to walk into. <<isOpen ? 'Inside
        the wardrobe is a metal hanging rail. ' : ''>>"      
    
    /* 
     *   Openable defines its own version of tryImplicitRemoveObstructor() 
     *   which tries to open the object. That's unlikely to be helpful here, 
     *   since this method will probably be called when an actor inside the 
     *   wardrobe is trying to reach something outside the wardrobe, for 
     *   which the NestedRoom behaviour (defined above) is more appropriate.
     */    
    tryImplicitRemoveObstructor(sense, obj) 
        { return inherited NestedRoom(sense, obj); }
;


/*  
 *   Just to make a wardrobe slightly less boring, we'll put a couple of 
 *   things inside it.
 */

++ RestrictedSurface, Component 'metal hanging rail/rod' 'metal rail'
    "The metal hanging rail runs the length of the wardrobe. "
    validContents = [hanger]
;

+++ hanger: Thing 'wire (coat) hanger/coathanger/coat-hanger'
    'wire coat-hanger'
;

/*  
 *   NOMINAL PLATFORM 
 *
 *   NominalPlatform is frankly a slightly strange class. It's meant to be an
 *   object without any vocabWords that can be used to describe an actor 
 *   within it as being in a particular place, such 'standing in the 
 *   doorway' or 'sitting on the rug'. In many cases it would be more 
 *   straightforward to achieve this effect by using the specialDesc 
 *   property of the actor's current ActorState, but this is a 
 *   NestedContainers demo, not an Actor demo, so we'll stick to showing how 
 *   it can be done with a NominalPlatform.
 *
 *   To make the example as simple as possible, we'll have a cat sleeping on 
 *   the floor beneath the bunk. We'll be defining a separate bunk object 
 *   later on as a Bed object, but the real bunk bed will have no concept of 
 *   'the floor beneath it', so we'll use a NominalPlatform for that. 
 */
   
+ NominalPlatform 
    /* 
     *   This combination of property definitions will ensure that any actor 
     *   located in/on this NominalPlatform will be described as being 'on 
     *   the floor beneath the bunk'
     */
    
    name = 'bunk'
    actorInPrep = 'on the floor beneath'
;

/*
 *   UNTAKEABLE ACTOR
 *
 *   To demonstrate NominalPlatform we need at Actor to put on it, but to 
 *   keep it as simple as possible we'll make the Actor a sleeping cat, who 
 *   never actually does anything. We'll make the cat an UntakeableActor so 
 *   that he remains on his NominalPlatform throughout (and so that we don't 
 *   have to worry about him waking up when he's moved).
 */


++ cat: UntakeableActor 'black cat' 'cat'
    "It's a black cat, which currently looks profoundly asleep. "
    
    /*  The cat is asleep, so presumably it's lying down */
    posture = lying
    
    /*  
     *   Obviously it's possible to pick up a cat, so we'll customise the 
     *   cannotTakeMsg.
     */
    cannotTakeMsg = 'It would be kinder to let sleeping cats lie. '
    
    /*   We'll also add a custom response for attacking the cat. */   
    
    dobjFor(Attack)
    {
        check()
        {
            failCheck('You\'d rather not; you\'re actually rather fond of your
                cat, and he\'s about the only friend you\'ve got round
                here. ');
        }
    }
    
    /*  We'll make it a male cat */
    isHim = true
    
    /* But we'll allow him to be referred to as 'it' too */    
    isIt = true
    
    /*  
     *   By setting owner = me we ensure that the parser will recognize 'your
     *   cat' or 'my cat' as referring to the cat.
     */
    owner = me
    
    /*  
     *   We'll also have the cat referred to as 'your cat' rather than 'the 
     *   cat'
     */
    theName = ('your ' + name)
    
    /*   
     *   Throwing something at the cat would wake it up, which we don't want;
     *   also the default response for throwing things can look rather 
     *   ludicrous when the target is animate. So we'll override 
     *   iobjFor(ThrowAt) to disallow this, using the same failure message 
     *   as for take.
     */    
    iobjFor(ThrowAt)
    {
        check()
        {
            failCheck(cannotTakeMsg);
        }
    }
;

/*  
 *   PLATFORM
 *
 *   A Platform is something one would normally stand on, although one could 
 *   equally well sit or lie on it. 
 *
 *   GET ON PLATFORM is treated as equivalent to STAND ON PLATFORM
 *
 *   To make it a bit more interesting, we'll make our first example of a 
 *   Platform a desk which things can be put under as well as on top of 
 *   (although one might normally think of a Desk as a Surface, it's usually 
 *   possible to sit or stand on a desk, and even to lie on it if it's big 
 *   enough). To allow this we need to make the desk itself a 
 *   ComplexContainer and attach the Platform to its subSurface.
 */


+ desk: ComplexContainer, Heavy 'desk*furniture' 'desk'
    subSurface: ComplexComponent, Platform
    {
        /* 
         *   This is one additional step we need to take to ensure that an 
         *   actor can actually stand on the desk.
         *
         *   By default the stagingLocations property for a NestedRoom is 
         *   [location], but the location of a ComplexComponent is 
         *   considered to be the ComplexContainer of which it's a part, and 
         *   a ComplexContainer can't (directly) hold an actor. We therefor 
         *   need to change the stagingLocation to the ComplexContainer's 
         *   location (the staging location is the place at actor needs to 
         *   be in order to be able to enter a particular NestedRoom).          
         */
        stagingLocations = [lexicalParent.location]
        
        /* 
         *   canReachFromInside() is a custom method defined above to 
         *   determine what can be reached from within a NestedRoom. When 
         *   standing on the desk the PC can also reach the bookshelf and 
         *   anything on the bookshelk, so we need to override 
         *   canReachFromInside() to return true when the player attempts to 
         *   touch what's on the shelf (or the shelf itself). 
         */    
           
        canReachFromInside(obj, dest)
        {
            return dest == bookshelf || dest.isIn(bookshelf);
        }
        
        
    }
    subUnderside: ComplexComponent, Underside {  }
    
    
    /* 
     *   The other job that needs doing is remapping all the appropriate 
     *   actions to the subSurface.
     */
    
    dobjFor(StandOn) remapTo(StandOn, subSurface)
    dobjFor(SitOn) remapTo(SitOn, subSurface)
    dobjFor(LieOn) remapTo(LieOn, subSurface)
    dobjFor(Board) remapTo(StandOn, subSurface)
    dobjFor(GetOffOf) remapTo(GetOffOf, subSurface)
    
    
;

   /*
    *   We'll also add a more straightforward Platform: a ladder (which will 
    *   be used to access the bunk).
    */

++ ladder: Platform 'short wooden ladder' 'short ladder'
    
    /* 
     *   Put the ladder under the desk. Note the special syntax for placing 
     *   something within a subXXXXX of a ComplexContainer.
     */
    subLocation = &subUnderside
    
    /*  
     *   Normally you can sit, stand, or lie on a Platform, but in the case 
     *   of a ladder its only standing that makes much sense.
     */
    allowedPostures = [standing]
    
    /*  
     *   Since standing is the only allowedPosture, it must also be the only 
     *   obviousPosture.
     */
    obviousPostures = [standing]
    
    
    /*   
     *   It would be natural to try to climb, climb up or climb down a 
     *   ladder, so we redirect these actions appopriately.
     */
    dobjFor(Climb) asDobjFor(StandOn)
    dobjFor(ClimbUp) asDobjFor(StandOn)
    dobjFor(ClimbDown) asDobjFor(GetOffOf)
    
    /*   
     *   Add a custom property to keep track of the notional position of the 
     *   ladder.
     */    
    leaningAgainst = nil
    
    /*   
     *   We'll only allow the ladder to be used to reach the bunk when it's 
     *   leaning against the bunk, so we need to provide an action that 
     *   allows the player to put the ladder in the appropriate place. We'll 
     *   use MoveTo.
     */
    
    dobjFor(MoveTo)
    {
        action()
        {
            if(gIobj == bunk)
            {
                moveInto(bunk.location);
                leaningAgainst = bunk;
                "You lean the ladder against the bunk. ";
            }
            else
                inherited;
        }
    }
    
    /*  
     *   Whenever the ladder is taken, it can no longer be leaning against 
     *   the bunk (or anything else), so we need to override the action 
     *   handling for Take accordingly.
     */
    
    dobjFor(Take)
    {
        action()
        {
            inherited;
            leaningAgainst = nil;
        }
    }
    
    /*  If the ladder is in position, make UP equivalent to STAND ON LADDER */
    
    beforeAction()
    {
        if(gActionIs(Up) && leaningAgainst != nil)
            replaceAction(StandOn, self);
    }
    
    /* 
     *   The purpose of the ladder is to enable the player character to 
     *   reach the bunk. We need to make sure we can touch the bunk (which 
     *   is outside us) when we're the staging location for the bunk. Here 
     *   we generalize the code to allow an actor inside us to touch 
     *   anything for which we are a staging location.
     */    
    
    canReachFromInside(obj, dest)
    {
        /* 
         *   Note that we can't be sure that the object we're trying to touch
         *   will have a stagingLocations property. By using the nilToList 
         *   function we avoid the run-time error that would otherwise occur 
         *   if we tried this test on a dest object for which 
         *   stagingLocations is nil.
         */
        return nilToList(dest.stagingLocations).indexOf(self) != nil;    
    }
    
;

/*  
 *   OUT OF REACH
 *
 *   OutOfReach is a mix-in class which puts the object it's mixed in with, 
 *   together with that object's contents, out of reach (except under 
 *   conditions specified by the game author. It's not a NestedRoom class, 
 *   but it is convenient to demonstrate along with NestedRooms, not least 
 *   because an OutOfReach object will often be reached by standing on some 
 *   NestedRoom object, as here.
 *
 *   We'll use an OutOfReach to implement the bookshelf that's said to be 
 *   fixed high on the wall above the desk. The way to reach it will be by 
 *   standing on the desk.
 */


+ bookshelf: OutOfReach, Surface, CustomFixture 
    'long wooden bookshelf/shelf' 'bookshelf'
    "It's a long wooden bookshelf, fixed far too high up on the wall for
    convenient access. "
    
    /* 
     *   Define the conditions under which this OutOfReach object can be 
     *   reached. obj is the object attempting the reaching -- typically an 
     *   actor. An actor can reach this shelf if s/he's standing on the 
     *   desk, so we need to test both that the obj is standing and that the 
     *   obj is on the desk, i.e. on the desk's subSurface.
     */
    canObjReachContents(obj)
    {
        return obj.posture == standing && obj.isIn(desk.subSurface);
    }
;

/*  
 *   READABLE
 *
 *   To demonstrate OutOfReach fully we need to put something on the 
 *   bookshelf, and the obvious thing to put there is a book.
 */ 

++ book: Readable 'red book*books' 'red book'
    "It's called <i>Life in Bedsitterland</i>. "
    readDesc = "You stop reading after a few pages. Of course the book relates
        someone else's experience of life in bedsitterland, but the prospect of
        the next few months turning out anything like that for you is just too
        depressing. "
        
    /*  
     *   One would normally hold a book in order to read it, and if we don't 
     *   enforce either objHeld or touchObj here, the player would be able to
     *   read the book without taking it off the shelf.
     */
    dobjFor(Read) { preCond = [objHeld] }
;

/*   
 *   CHAIR
 *
 *   So far all our examples of NestedRooms have been NonPortable, but a 
 *   NestedRoom can also be portable, as the following Chair object 
 *   demonstrates.
 */


+ Chair 'black swivel chair*chairs*furniture*seating' 'swivel chair'
    "It's black, and it swivels. "
    specialDesc = "A swivel chair has been placed right by the desk. "
    
    /*  
     *   Since it's described as a swivel chair we'd better allow the player 
     *   to turn it.
     */    
    dobjFor(Turn)
    {
        verify() {}
        action()
        {
            "You swivel the chair round a few times. How exciting! What fun! ";
        }
    }
    
    /* 
     *   A swivel chair might not be all that safe to stand on, so we'll 
     *   restrict the allowedPostures to sitting.
     */    
    allowedPostures = [sitting]
    cannotStandOnMsg = 'Since the swivel chair swivels so easily, it\'s not safe
        to stand on. '
;

/*  
 *   HIGH NESTED ROOM
 *
 *   A HighNestedRoom is a NestedRoom that's regarded as being too high up to
 *   reach except via a special staging location (such as a ladder). Here 
 *   we'll use it to implement a bunk high up on the east wall which can 
 *   only be reached via the ladder once the ladder has been placed against 
 *   the bunk.
 *
 *   We'll also make the bunk a RoomPartItem so it's mentioned when the 
 *   player examines the east wall. 
 */

+ bunk: RoomPartItem, HighNestedRoom, Bed, Fixture 'narrow hard bunk*beds' 
    'narrow bunk'
    "It's quite narrow, and looks a bit hard, but at least it would allow you to
    have a visitor to stay. It's also quite high up the wall. "
    
    /* 
     *   Normally you could stand on a bed, but there's not enough headroom 
     *   above the bunk.
     */
    allowedPostures = [sitting, lying]
    cannotStandOnMsg = 'There\'s not enough headroom to stand here. '
    
    /*  
     *   To reach a HighNestedRoom an actor has to be the appropriate staging
     *   location, so the stagingLocations property defines how the bunk 
     *   can be reached. Note that if we just defined stagingLocations = 
     *   [ladder], then GET ON BUNK would result in the player character 
     *   getting on the bunk via the ladder without further ado, and the 
     *   player would hardly notice that the bunk was tricky to get to. So 
     *   we define stagingLocations so that the ladder can only be used as a 
     *   staging location when it's in the right state (leaning against the 
     *   bunk).
     */
    stagingLocations = [ladder.leaningAgainst == self ? ladder : nil]
    
    /*  
     *   In order to get the ladder into the right state the bunk must be a 
     *   possible target of a MoveTo command.
     */    
    iobjFor(MoveTo) 
    { 
        preCond = [touchObj]
        verify() {} 
    }
    
    specialNominalRoomPartLocation = defaultEastWall
    specialDesc = "A narrow bunk has been fixed high up on the north wall, with
        a short wooden bench underneath. "
    
    nothingUnderMsg = 'Beneath the bunk are a short wooden bench and a sleeping
        cat. '
;

/* 
 *   CHAIR 
 *
 *   Since the bunk is high up on the wall, we may as well put something 
 *   underneath it.
 */

+ bench: Chair, Fixture 'short wooden bench*chairs*furniture*seating' 
    'bench'
    "Frankly, you're not sure what it's doing there; it looks neither
    comfortable nor decorative. Your best guess is that there was once a lower
    bunk that has long since been removed, and someone put the bench there to
    take up the space (and/or cover up a mark on the wall). "
    
    allowedPostures = [sitting]
    cannotTakeMsg = 'It seems to be fixed firmly in place. '
    cannotStandOnMsg = 'There\'s not enough room to stand on the bench; you\'d
        bang your head on the bunk above. '
;

/*   
 *   DOOR
 *
 *   Even a bedsit must have a door, but we'll provide one that doesn't go 
 *   anywhere, giving a reason why the PC doesn't want to go out right now.
 */

+ door: Door 'door' 'door'
    dobjFor(Open)
    {
        check()
        {
            failCheck('You don\'t want to go out right now. You might run into
                your landlady in the hall, and she\'ll only start demanding
                some rent. ');
        }
    }                
;

//==============================================================================
/* Modifying verb grammar */

/*   
 *   MOVE LADDER TO BUNK might not be the most obvious phrasing, so we'll add
 *   some alternative phrasings in a new VerbRule, but still assign them to 
 *   the MoveTo action.
 */


VerbRule(LeanAgainst)
    'lean' singleDobj ('on' | 'against') singleIobj |
    'put' singleDobj 'against' singleIobj
    : MoveToAction
    verbPhrase = 'lean/leaning (what) (against what)'
;

/*  
 *   Since we have an object called a swivel chair it seems likely that a 
 *   player might try to SWIVEL it, so we'll add 'swivel' to the standard 
 *   grammar for TurnAction.
 *
 *   Note the slightly unusual syntax for modifying a VerbRule, with the 
 *   colon after the grammar definition line. In this case the original 
 *   VerbRule(Turn) was copied and pasted from en_us.t and 'swivel' simply 
 *   added. 
 */         

modify VerbRule(Turn)
    ('turn' | 'twist' | 'rotate' | 'swivel') dobjList
    :
;

/* 
 *   There's no particular reason why we modified VerbRule(Turn) and added a 
 *   new VerbRule(LeanAgainst), other than to illustrate both methods; but 
 *   the fact that just adding 'swivel' was a simpler change than the 
 *   additional grammar for MoveToAction helped determine that we did it 
 *   this way round.
 */

