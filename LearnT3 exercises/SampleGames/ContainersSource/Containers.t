#charset "us-ascii"

/*   
 *   This is not a proper game, but a demonstration of the container-like 
 *   classes in TADS 3. While we're at it we'll demonstrate some NonPortable 
 *   and basic Thing-related classes too.
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
    IFID = '7cccddf5-522b-1448-8e67-ad5c8518511c'
    name = 'Containers'
    byline = 'by Eric Eve'
    htmlByline = 'by <a href="mailto:eric.eve@hmc.ox.ac.uk">
                  Eric Eve</a>'
    version = '0.6'
    authorEmail = 'Eric Eve <eric.eve@hmc.ox.ac.uk>'
    desc = 'A demonstration of TADS 3 container-type classes'
    htmlDesc = 'A demonstration of TADS 3 container-type classes'
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
        "Now your kitchen's been refurbished, you want to take a look
        around.<.p> ";
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
 */
kitchen: Room 'Kitchen'
    "Much of the space is taken up with a wooden table in the middle of the
    kitchen. There's a cabinet on one wall, a cooker next to another, with a
    peg placed conveniently by. A long work surface runs under the cabinet,
    with a kitchen roll mounted on the wall just above it. The opposite wall is
    adorned with a cheerful poster. The way out is to the north, but you're not
    interested in the rest of the house just now. "
    north: FakeConnector { "There's no need to go wandering round the rest of
        the house; it's the kitchen you want to investigate right now. " }    
;

/*
 *   ACTOR -- PLAYER CHARACTER
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
    /* 
     *   We'll limit the PC's bulkCapacity in order to demonstrate a 
     *   BagOfHolding.
     */
    bulkCapacity = 20
;

//------------------------------------------------------------------------------

/*  
 *   DISTANT
 *
 *   We'll start with a simple Distant object. In practice the PC could 
 *   probably reach the light bulb by standing on the kitchen table, but 
 *   that's a complication beyond what we want to illustrate in this demo.
 */

+ Distant 'naked light bulb' 'naked light bulb'
    "A naked light bulb hangs from the ceiling. "
    specialDesc = (desc)
    specialNominalRoomPartLocation = defaultCeiling
;

/*  
 *   DECORATION
 *
 *   By making this a RoomPartItem we ensure its specialDesc is only shown 
 *   if the east wall is examined.
 */

+ RoomPartItem, Decoration 'large cheerful sunny landscape poster' 'poster'
    "You put it there because it's cheerful. It depicts a sunny landscape. "
    specialNominalRoomPartLocation = defaultEastWall
    specialDesc = "A large poster has been attached to the east wall. "
;

//------------------------------------------------------------------------------
/*
 *   A SIMPLE SURFACE
 *
 *
 *   About the simplest kind of container object is a simple surface. We'll 
 *   make this one a CustomFixture too, since it obviously can't be moved.
 */

+ workTop: Surface, CustomFixture 'work long surface/top/counter' 'work surface'
    cannotTakeMsg = 'The builder seems to have done his job with the work
        surface, at any rate; it\'s so firmly fixed in place that you can\'t
        budge it by as a much as a nanometer. '
;


/*  
 *   SINGLE CONTAINER,  RESTRICTED CONTAINER
 *
 *   A SingleContainer is a container that can only hold one thing at a 
 *   time; if something else is inserted, the first object is removed. To 
 *   function as a SingleContainer the container must either be rather small 
 *   (so that there's only room for one object at a time) or some kind of 
 *   RestrictedContainer that will only take objects of a particular type. 
 *   The latter is pehaps the more natural kind of example, so we'll provide 
 *   a pencil sharpener that can only take pencils (and only one pencil at a 
 *   time). To ensure that it only takes pencils, it will need to be a 
 *   RestrictedContainer as well. 
 *
 *   This definition of the pencilSharpener is fairly minimal, but below we 
 *   shall define a custom Pencil class which will make the sharpener work 
 *   in a fairly basic fashion.
 */
 
++ pencilSharpener: SingleContainer, RestrictedContainer
    'small pencil sharpener' 'small pencil sharpener'
    
    /* Allow only Pencils to be put in me. */
    canPutIn(obj) { return obj.ofKind(Pencil); }
    bulkCapacity = 1
    bulk = 2
    
    /* 
     *   If the player tries to turn the sharpener when there's a pencil in 
     *   it, turn the pencil instead.
     */
    dobjFor(Turn) maybeRemapTo(contents.length() > 0, Turn, contents[1])
;

/*   RESTRICTED UNDERSIDE
 *    
 *   It's unlikely that you'll use RestrictedUnderside much, but here's one 
 *   example: a book under which a note has been concealed. There's no reason
 *   why the note can't be put under the book, but nothing else will be. 
 *   Note that the note will stay behind when the book is taken. 
 */

++ redBook: RestrictedUnderside, Readable 'big red cookery book' 'big red book'
    "It's a cookery book. "
    readDesc = "You flick through some of the pages, but none of the recipes
        take your fancy right now. "    
    validContents = [note]
    
    /* 
     *   It only makes sense to put the note back under the book if the book 
     *   is resting on a surface.
     */
    
    allowPutUnder = (location.ofKind(Surface))
    iobjFor(PutUnder)
    {
        check()
        {
            if(!allowPutUnder)
                failCheck('You can\'t put anything under the book unless it\'s
                    resting on something. ');
            inherited();
        }
    }
    bulk = 3
;

/*  HIDDEN, READABLE */

+++ note: Hidden, Readable 'yellow piece/paper/note' 'piece of yellow paper'
    "Someone's scribbled a note on it. "
    readDesc = "It reads: <q>I just realized there was a slight error in my
        original estimate for fitting this kitchen. Nothing to worry about --
        just add another nought.\b
        Buck Swindler (builder)</q>"
;

/*  
 *   RESTRICTED SURFACE
 *
 *   A simple example of a RestrictedSurface might be a peg on which we can 
 *   hang (here just PUT) an apron, but nothing else.
 */


+ peg: RestrictedSurface, Fixture 'peg/hook' 'peg'
    validContents = [apron]
;

/*   WEARABLE */

++ apron: Wearable 'blue and red striped apron' 'striped apron'
    "It's striped blue and red. "
    bulk = 4
;

/*  
 *   REAR CONTAINER
 *
 *   RearContainers are used less often. The point to remember is that when 
 *   they're moved their contents doesn't move with them, so the bag and the 
 *   sack will remain put.
 *
 *   Normally we'd be able to open a large brown box, but to keep this 
 *   RearContainer simple we'll just display a message showing why we don't 
 *   want to open it just yet.
 */


+ brownBox: RearContainer 'large brown square box*boxes' 'large brown box'
    "It's about two foot square. "
    initSpecialDesc = "A large brown box sits in the corner. "
    cannotOpenMsg = 'It\'s full of your china and cutlery, but you don\'t want
        to start unpacking them yet. '
    lookInDesc = "<<cannotOpenMsg>>"
    
    notASurfaceMsg = 'You don\'t want to put anything on the box in case you
        damage the china inside. '
    bulk = 8
    
    /* 
     *   This isn't really an openable container, but it looks like one so 
     *   the player might try to put something in it. To cater for this we 
     *   add stub iobjFor(PutIn) handling that makes it logical to put 
     *   something in the brown box, but will fail on the attempt to open 
     *   the brown box that will be triggered by the objOpen precondition.
     */
    iobjFor(PutIn)
    {
        preCond = [objOpen]
        verify() {}
    }
;

/*  
 *   STRETCHY CONTAINER
 *
 *   We make the sack and the bag Hidden so that the player doesn't find them
 *   until s/he either looks behind or takes the brown box.
 */


++ sack: Hidden, StretchyContainer 'old brown sack' 'old brown sack'
    minBulk = 3
;

/*   
 *   BAG OF HOLDING
 *
 *   To try out the BagOfHolding, take it early on, then take as many other 
 *   objects as you can.
 */

++ bag: BagOfHolding, Hidden, Container 'old beige bag' 'old beige bag'
    
    /* 
     *   Making the bulk smaller than the bulk capacity may seem 
     *   unrealistically Tardis-like, but if we don't do that the 
     *   BagOfHolding can't do its job, since the whole purpose of it is to 
     *   carry more bulk than the PC can hold in his/her hands.
     */
    bulk = 4
    bulkCapacity = 100
;


/* 
 *   COMPLEX CONTAINER
 *
 *   An cooker is something you can typically put things on top of and 
 *   inside, so it's a good candidate for illustrating ComplexContainer. 
 *   While we're at it, we'll give it a subRear as well with something 
 *   hidden behind.
 */


+ oven: ComplexContainer, Fixture 'oven/cooker/stove' 'cooker'
    "It's not quite hard against the wall. "
    subSurface: ComplexComponent, Surface {}
    subContainer: ComplexComponent, OpenableContainer {}
    subRear: ComplexComponent, RearContainer { bulkCapacity = 1 }   
;

/*  
 *   CONTAINER DOOR
 *
 *   A ContainerDoor is normally only used on a ComplexContainer, as here.
 */

++ ContainerDoor '(oven) (cooker) (stove) door*doors' 'oven door'
;

/*  COMPLEX CONTAINER CONTENTS */

++ cake: Food 'large round chocolate delicious brown cake' 'chocolate cake'
    "It's large, round and brown. "
    /* 
     *   Note the special syntax for locating something initially in a 
     *   subXXXX of a ComplexContainer. 
     */
    subLocation = &subContainer
    
    dobjFor(Eat)
    {
        action()
        {
            "You take one bite and it's delicious, so you take a whole slice;
            then another, and another and another and another until the whole
            cake is gone and your waistline threatens to bulge beyond acceptable
            limits. ";
            inherited;
        }
    }
    
    tasteDesc = "It tastes deliciously chocolately. "
    bulk = 3
;

++ leaflet: Readable, Hidden '(cooker) instruction leaflet' 'leaflet'
    "It looks like the instruction leaflet for the cooker. "
    initDesc()
    {
        desc();
        "It must have fallen down behind. ";
    }
    readDesc = "You can't make head nor tail of the instructions. It looks like
        they've been translated from Chinese with the aid of a
        Portugese-Swahili phrasebook by someone whose first language was
        Sanskrit. "
    dobjFor(Read) { preCond = [objVisible, objHeld] }
    subLocation = &subRear
;


++ saucepan: Container 'stainless steel sauce saucepan/pan' 'saucepan'
    "It's made of stainless steel. "
    
    subLocation = &subSurface
    bulkCapacity = 3
    bulk = 4
    canContainSoup = true
;

/*  
 *   COMPLEX CONTAINER WITH LID
 *
 *   Rather more complicated than a simple saucepan is a pot which is open or
 *   closed by removing or replacing its lid. In order to allow the lid to 
 *   be put ON it while other things can be put IN it, we need to make it a 
 *   ComplexContainer.
 */

++ pot: ComplexContainer 'large orange casserole pot' 'large casserole pot'
    "It's a large orange pot with a black handle. "
    subSurface: ComplexComponent, RestrictedSurface 
    {
        validContents = [potLid]
    }
    subContainer: ComplexComponent, Container
    {
        isOpen = (!potLid.isIn(lexicalParent.subSurface))
        bulkCapacity = 5
        cannotOpenMsg = dobjMsg('It\'s already open. ')
        dobjFor(Open) maybeRemapTo(!isOpen, Take, potLid) 
        dobjFor(LookIn) { preCond = [objOpen] }
    }
    bulk = 6     
    canContainSoup = true
    subLocation = &subSurface
;

/* THE LID */

+++ potLid: Thing 'lid' 'lid'
    bulk = 3
    subLocation = &subSurface
    dobjFor(Take)
    {
        action()
        {
            if(isIn(pot.subSurface))
                "You take the lid off the pot. ";
            inherited;
        }
    }
;

/*  
 *   COMPONENT
 *
 *   Since the pot is already a ComplexContainer, its easy to add a Component
 *   like a handle. You couldn't do this directly on an OpenableContainer.
 */

+++ Component 'black handle' 'black handle'
;


/*
 *   A COMPLEX CONTAINER YOU CAN STAND ON
 *
 *   A table could just be a straightforward Surface, but since it's 
 *   reasonable to put things under a table as well as on top of it, we can 
 *   also make it a ComplexContainer to allow this. A further complication 
 *   is that people might be able to sit, stand, or lie on a large kitchen 
 *   table: this example shows one way of allowing that with a 
 *   ComplexContainer.
 *
 *   Note that we also make the table inherit from Heavy, since it's too 
 *   heavy to pick up or move around.
 */

+ table: Heavy, ComplexContainer 'wooden table' 'table'
    subSurface: ComplexComponent, Platform 
        { stagingLocations = [lexicalParent.location] }
    subUnderside: ComplexComponent, Underside {}
    
    dobjFor(StandOn) remapTo(StandOn, subSurface)
    dobjFor(Board) asDobjFor(StandOn)
    dobjFor(SitOn) remapTo(SitOn, subSurface)
    dobjFor(LieOn) remapTo(LieOn, subSurface)
    dobjFor(GetOffOf) remapTo(GetOffOf, subSurface)
;

/* 
 *   OPENABLE CONTAINER
 *
 *   The red box is a straightforward OpenableContainer 
 */

++ redBox: OpenableContainer 'big red box*boxes' 'big red box'
    subLocation = &subUnderside
    bulk = 10
    bulkCapacity = 10
;

/*  We'll see how this can opener is used below. */

+++ canOpener: Thing 'tin can opener' 'can opener'
    iobjFor(OpenWith)
    {
        verify() {}
    }
;

/*  
 *   Some pencils for the sharpener; we'll define the Pencil class below. 
 *
 *   Note that objects inherit vocabWords from their superclass. The '-' in 
 *   the vocabWords of these Pencils is a placeholder for the 
 *   'pencil*pencils' that they all inherit from the Pencil class. 
 */

+++ Pencil 'red -' 'red pencil';
+++ Pencil 'blue -' 'blue pencil';
+++ Pencil 'green -' 'green pencil';
+++ Pencil 'black -' 'black pencil';
+++ Pencil 'yellow -' 'yellow pencil';



/* 
 *   LOCKABLE CONTAINER
 *
 *   The cabinet is also a straightforward LockableContainer, but it's also 
 *   fixed in place. Note that we don't need a key to unlock a 
 *   LockableContainer (which makes the class almost pointless in practice.
 */
 

+ cabinet: LockableContainer, CustomFixture 'cabinet/cupboard' 'cabinet'
    cannotTakeMsg = 'The cabinet is firmly fastened to the wall. '
;

/*  TRANSPARENT OPENABLE CONTAINER */

++ glassJar: OpenableContainer 'glass jar' 'glass jar'
    /*  
     *   By giving the glass jar a material of glass, we make it possible to 
     *   see what's inside even when it's closed.
     */

    material = glass
    
    /* 
     *   The following methods prevent our putting anything but fairly small 
     *   objects into the jar, even though it has quite a large bulkCapacity.
     */
    
    canFitObjThruOpening(obj) { return obj.bulk < 3; }
    bulkCapacity = 10
    canContainSoup = true
;

/*  
 *   CLASS DEFINITION
 *
 *   Note that since we can define the SugarCube class here without 
 *   upsetting the object containment hierarchy.
 */

class SugarCube: Food 'sugar cube*cubes' 'sugar cube'
    isEquivalent = true
;

/*  These ten SugarCubes will be in the glassJar, not the SugarCube class! */

+++ SugarCube;
+++ SugarCube;
+++ SugarCube;
+++ SugarCube;
+++ SugarCube;
+++ SugarCube;
+++ SugarCube;
+++ SugarCube;
+++ SugarCube;
+++ SugarCube;


/*  
 *   A CUSTOMISED CONTAINER
 *
 *   The soup can is a more complicated example of a container; it starts off
 *   closed and can only be opened in a special way, using the can opener. 
 *   This requires some custom coding.
 */


++ soupCan: Container 'can/tin/soup' 'can of soup'
    isOpen = nil    
    dobjFor(OpenWith)
    {
        preCond = [objHeld]
        verify() 
        {
            if(isOpen)
                illogicalAlready('The can is already open. ');
        }
        check()
        {
            if(gIobj != canOpener)
                failCheck('{You/he} can\'t open the can with {the iobj/him}. ');
        }
        action()
        {
            isOpen = true;
            "You open the can with {the iobj/him}. ";
            local tab;

            /* get the table of visible objects */
             tab = gActor.visibleInfoTable();
                
            /* show my contents list, if I have any */
             openableOpeningLister.showList(gActor, self, contents, ListRecurse,
                                       0, tab, nil);

            /* mark my contents as having been seen */
             setContentsSeenBy(tab, gActor);
        }
    }
    cannotOpenMsg = dobjMsg('You\'ll need something to open it with. ')
    bulk = 3
    bulkCapacity = 2
    canContainSoup = true
;

/*  
 *   A SIMPLE LIQUID
 *
 *   The soup in the can is also an odd kind of object, since it can't 
 *   simply be picked up, although it should be possible to transfer it from 
 *   one container to another. 
 */

+++ soup: Food 'red orange thick tomato soup' 'tomato soup'
    "It looks quite thick, and its colour is somewhere between red and orange. "
    isMassNoun = true
    dobjFor(Take)
    {
        verify() { illogical('It\'s liquid; you can\'t pick it up. '); }
    }
    
    dobjFor(PutIn)
    {
        preCond = [touchObj]
        check()
        {
            /* 
             *   canContainSoup is a custom property we defined on those few 
             *   containers above we're prepared to allow the soup to be 
             *   poured into.
             */
            if(!gIobj.canContainSoup)
                failCheck('It would make too much of a mess to pour the soup in
                    there. ');
        }
    }
        
    dobjFor(PutOn)
    {
        preCond = [touchObj]
        check()
        {
            failCheck('You don\'t want to make a mess. ');
        }
    }
    dobjFor(PutUnder) asDobjFor(PutOn)
    dobjFor(PutBehind) asDobjFor(PutOn)
    dobjFor(PourOnto) asDobjFor(PutOn)
    dobjFor(PourInto) remapTo(PutIn, self, IndirectObject)
    bulk = 2
    dobjFor(Drink) asDobjFor(Eat)
    dobjFor(Eat)
    {
        preCond = [touchObj]
        action()
        {
            "It tastes okay, but it would have been better hot. ";
            inherited;
        }
    }
    tasteDesc = "It tastes of tomato. "
;

/*   
 *   DISPENSER AND DISPENSABLES 
 *
 *   A Dispenser is a container for a special type of item. By default its 
 *   contents can be taken but not returned. A roll of kitchen towels 
 *   provides a good example of this; you can take a towel from the roll, 
 *   but you can't but it back.
 *
 *   We'll make the roll a CustomImmovable; it's not obvious that you 
 *   couldn't tale the whole roll, but in this case we won't allow it.
 */
 

+ roll: Dispenser, CustomImmovable '(towel) (kitchen) roll/holder' 'kitchen roll'
    "It's a<<contents.length == 0 ? 'n empty roll' : ' roll of paper towels'>>,
    mounted on the wall. "
    myItemClass = PaperTowel
    cannotTakeMsg = 'You can\'t detach the roll from its holder; the builder
        must have fitted it wrong. '
;

  /* 
   *   Once again we can define the class between the container and its 
   *   contents -- we don't have to define it here, but doing so does no harm.
   */

class PaperTowel: Dispensable 'plain paper white square (kitchen) towel*towels' 
    'paper towel'
    "It's a plain, white, square paper towel. "
    
    isEquivalent = true
    
    /* 
     *   It's a bit unrealistic to see reports like "In the kitchen roll are 
     *   ten paper towels" so we override the isListedInContents property so 
     *   that the towels are not listed while they're still on the roll.
     */
    isListedInContents = (!isIn(roll))
;

++ PaperTowel;
++ PaperTowel;
++ PaperTowel;
++ PaperTowel;
++ PaperTowel;
++ PaperTowel;
++ PaperTowel;
++ PaperTowel;
++ PaperTowel;
++ PaperTowel;



/*  
 *   RESTRICTED REAR SURFACE
 *
 *   This clock has a label attached to the rear. Because this is a 
 *   RearSurface and not a RearContainer the label will move with the clock. 
 *   We make it a RestrictedRearContainer because the label is the only 
 *   thing that can go behind the clock.
 */

+ clock: RestrictedRearSurface 'round white clock' 'clock' 
   "It's white and round, and shows the current time as <<showTime()>>. "
        
    dobjFor(LookBehind)
    {
        preCond = [objHeld]
    }
    
    iobjFor(PutOn) remapTo(PutBehind, DirectObject, self)
    iobjFor(AttachTo) remapTo(PutBehind, DirectObject, self)
    
    validContents = [blueLabel]
    initSpecialDesc = "A clock hangs on the north wall. "
    initNominalRoomPartLocation = defaultNorthWall
    
    bulk = 3
    
    /* 
     *   There's no need to worry too much about the showTime() method below;
     *   what it does it read the system time and then report it as the 
     *   time shown on the clock.
     */
    
    showTime()
    {
        local minute = getTime()[7];
        local hour = getTime()[6];
        
        /* 
         *   If the minute is more than 30, then we want to report the time 
         *   as so many minutes to the hour, otherwise we'll report it as so 
         *   many minutes past the hour.
         */
        local prep = minute > 30 ? 'to' : 'past';
        
        /*   
         *   If the minute it more than 30, subtract it from 60 to get the 
         *   number of minutes to the next hour.
         */
        minute = minute > 30 ? 60 - minute : minute;
        
        /*   
         *   If we're reporting so many minutes to the hour, we need to add 
         *   one to the hour ( 10:35 is 25 minutes to 11). 
         */
        hour = prep == 'to' ? hour + 1 : hour;
        
        /*   
         *   If the hour is more than 12, deduct 12 so it's on a 12 hour 
         *   rather than 24 hour clock.
         */
        hour = hour > 12 ? hour - 12 : hour;
        
        /*   Finally spell the time out in words, not numbers. */
        
        if(minute == 0)
            "<<spellInt(hour)>> o'clock";
        else
            "<<spellInt(minute)>> minute<<minute > 1 ? 's' :''>> <<prep>>
            <<spellInt(hour)>>";
    }
;

/*  
 *   The label starts hidden, since we obviously can't see it while the 
 *   clock is hanging on the wall.
 */

++ blueLabel: Hidden 'blue label' 'blue label'
    "It says <q>Made in TADS 3</q>. "    
;



/* 
 *   MODIFIED WALL
 *
 *   The clock starts out on the north wall, but can be taken. We ought to 
 *   allow the player to replace it there. Normally, we'd need to create a 
 *   custom north wall object for this, but since there's only one room in 
 *   the game, we can just customise defaultNorthWall instead. 
 */

modify defaultNorthWall
    /* 
     *   Allow this wall to be the indirect object of a PUT ON command when 
     *   the direct object is the clock.
     */
    iobjFor(PutOn)    
    {
        verify() {}
        check()
        {
            if(gDobj != clock)
                failCheck('You can\'t hang {that dobj/him} on the wall. ');
        }
        action()
        {
            /* 
             *   Restore the clock to its original state so that it's 
             *   reported as hanging on the wall.
             */
            gDobj.moveInto(kitchen);
            gDobj.moved = nil;
            "You put {the dobj/him} back on {the iobj/him}. ";
        }
    }
;

//==============================================================================
/* The PENCIL class */

class Pencil: Thing 'sharp blunt pencil*pencils' 'pencil'
    "It's <<getState.stateTokens[1]>>. "
    dobjFor(Turn)
    {
        verify() 
        {
            /* 
             *   It's most useful to turn a pencil when it's in the 
             *   sharpener, so we'll boost the logical rank of such a pencil.
             */
            
            if(isIn(pencilSharpener))
                logicalRank(120, 'sharpening');
        }
        action()
        {
            if(isIn(pencilSharpener))
            {
                "You turn the <<theName>> a few times, sharpening it nicely. ";
                getState = sharpState;
            }
            else
                "You twiddle <<theName>> around, but it doesn't do much. ";
        }
    }
    
    /* 
     *   Assigning a ListGroup to the Pencil class will ensure that Pencils 
     *   are listed together in a sensible way in room descriptions, 
     *   inventory listings and the like.
     */
    listWith = [pencilGroup]
    allStates = [sharpState, bluntState]
    getState = bluntState
    
;

/*  
 *   THING STATE
 *
 *   ThingStates allow us to vary the vocabulary an object will match 
 *   depending on its state. Here we define a sharpState and a bluntState 
 *   for the Pencil class. A blunt pencil will then match 'blunt' and sharp 
 *   pencil 'sharp.'
 */

sharpState: ThingState
    stateTokens = ['sharp']
;

bluntState: ThingState
    stateTokens = ['blunt']
;
    
pencilGroup: ListGroupParen
;

//==============================================================================
/*  
 *   CUSTOM ACTIONS AND GRAMMAR
 *
 *   Define the custom OpenWith action plus default action handlers for it. 
 */


DefineTIAction(OpenWith)
;

VerbRule(OpenWith)
    'open' dobjList 'with' singleIobj
    : OpenWithAction
    verbPhrase = 'open/opening (what) (with what)'
;

modify Thing
    dobjFor(OpenWith)
    {
        preCond = [touchObj]
        verify()
        {
            illogical(&cannotOpenMsg);
        }
    }
    iobjFor(OpenWith)
    {
        preCond = [objHeld]
        verify()
        {
            illogical(cannotOpenWithMsg);
        }
    }
    cannotOpenWithMsg = '{You/he} can\'t open anything with {that iobj/him}. '
    
    /* 
     *   By default the library doesn't allow anything to be the indirect 
     *   object of a PourOnto command -- the library simply responds with 
     *   "You can't pour anything onto that" -- but it's obviously possible 
     *   to pour stuff onto anything (even if we're going to stop the 
     *   soup being poured for other reasons) so we'll override the library 
     *   default.
     */

    
    iobjFor(PourOnto) { verify() {} }
;

modify Openable
    dobjFor(OpenWith)
    {
        verify()
        {
            illogical('You don\'t need {the iobj/him} to open {that dobj/him}.
                ');
        }   
       
    }
;

modify ComplexContainer
    dobjFor(OpenWith) maybeRemapTo(subContainer != nil, OpenWith, subContainer,
                                   IndirectObject)
;

/* 
 *   With both the clock and the apron a player might try HANG CLOCK ON WALL 
 *   or HANG APRON ON PEG, so it would be good to allow this grammar. The 
 *   best way to do this is to make HANG ON a synonym for PUT ON. There are 
 *   two ways to do this: modify the existing VerbRule or create a new one. 
 *   Here we'll demonstrate the second method.
 */


VerbRule(HangOn)
    'hang' dobjList 'on' singleIobj
    : PutOnAction // this makes it a synonym for PUT ON
    verbPhrase = 'hang/hanging (what) (on what)'
;



