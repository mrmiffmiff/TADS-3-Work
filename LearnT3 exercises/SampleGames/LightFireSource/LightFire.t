#charset "us-ascii"

/*   
 *   LIGHT & FIRE
 *
 *   This is a demonstration of the standard library light and fire classes. 
 *   It's not at all an exciting game, and playing it straight through will 
 *   not be particularly informative. You'll get more out of it by 
 *   experimenting with the different kind of light sources provided.
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
 *   VERSION INFO
 *
 *   Our game credits and version information.  This object isn't required 
 *   by the system, but our GameInfo initialization above needs this for 
 *   some of its information.
 *
 *   You'll have to customize some of the text below, as marked: the name of 
 *   your game, your byline, and so on.
 */
versionInfo: GameID
    IFID = 'f679cdf5-2cc7-6438-ca9c-175f25f2ee68'
    name = 'LightFire'
    byline = 'by Eric Eve'
    htmlByline = 'by <a href="mailto:eric.eve@hmc.ox.ac.uk">
                  Eric Eve</a>'
    version = '0.3'
    authorEmail = 'Eric Eve <eric.eve@hmc.ox.ac.uk>'
    desc = 'A demo of Light and Fire classes'
    htmlDesc = 'A demo of Light and Fire classes'
;

/*
 *   GAME MAIN
 *
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
        "You have travelled a long way to get here, but finally you arrived at
        the caves in which the legendary magic crystal is said to be concealed.
        Determined to overcome all dangers and difficulties you are ready to
        embark on your quest to recover the Crystal That Glows In The Dark!\b";
    }
;

/* 
 *   Starting location - we'll use this as the player character's initial
 *   location.  The name of the starting location isn't important to the
 *   library, but note that it has to match up with the initial location
 *   for the player character, defined in the "me" object below.
 *   
 *   Our definition defines two strings.  The first string, which must be
 *   in single quotes, is the "name" of the room; the name is displayed on
 *   the status line and each time the player enters the room.  The second
 *   string, which must be in double quotes, is the "description" of the
 *   room, which is a full description of the room.  This is displayed when
 *   the player types "look around," when the player first enters the room,
 *   and any time the player enters the room when playing in VERBOSE mode.
 *   
 *   The name "startRoom" isn't special - you can change this any other
 *   name you'd prefer.  The player character's starting location is simply
 *   the location where the "me" actor is initially located.  
 */
startRoom: Room 'Start Room'
    "The cave you came to visit stands just to the north. To the south lies the
    way back to civilization. "
    north = smallCave
    south: TravelConnector
    {
        /* 
         *   Don't allow travel this way until the PC has seen the crystal 
         *   and is carrying it.
         */
        
        canTravelerPass(traveler)
        {
            return me.hasSeen(crystal) && crystal.isIn(me);
        }
        explainTravelBarrier(traveler)
        {
            "You came all the way here to collect the crystal and you're not
            leaving without it! ";
        }
        
        /*  
         *   When travel is allowed, simply end the game with a message 
         *   saying that the player has won.
         */
        
        noteTraversal(traveler)
        {
            "The crystal recovered, you go triumphantly on your way. ";
            finishGameMsg(ftVictory, [finishOptionUndo, finishOptionAmusing]);
        }
    }
;

/*
 *   PLAYER CHARACTER
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
    desc = "You look as ready as you'll ever be. "
;

/*
 *   READABLE
 *
 *   We provide a Readable object so that you can test trying to read it in 
 *   the inadequate light (brightness = 2) provided by a matchstick.
 */
++ Readable 'handwriten note' 'note'
    "It's a handwritten note from the friend who tipped you off about the
    magic crystal. "
    readDesc = "It says, <q>You should find the crystal in the deepest
        cave.</q> "
;

/*  
 *   MATCHBOOK
 *
 *   A Matchbook is a special kind of Dispenser for Matchsticks.
 */

++ matchbook: Matchbook 'amber matchbox/matchbook/book/(matches)' 'matchbook'
    "It's amber in colour, but otherwise unremarkable. "
;

/*
 *   MATCHSTICK
 *
 *   A Matchstick can be lit and will stay alight for a short number of 
 *   turns, during which it will give enough light to see by, but not to 
 *   read by. While it's alight it can be used to light other objects, such 
 *   as the candle and the oil lamp below.
 *
 *   Before putting ten Matchsticks in our Matchbook, we'll modify the 
 *   Matchstick class to add some vocab words and a name. We could of course 
 *   modify other properties to change the standard behaviour if we wanted, 
 *   but we'll stick with the library defaults here. 
 */

modify Matchstick 
    vocabWords = 'match*matches' 
    name = 'match'
;

+++ Matchstick;
+++ Matchstick;
+++ Matchstick;
+++ Matchstick;
+++ Matchstick;
+++ Matchstick;
+++ Matchstick;
+++ Matchstick;
+++ Matchstick;
+++ Matchstick;


/*  ENTERABLE */

+ Enterable -> smallCave 'narrow cave entrance' 'cave entrance'
    "The cave entrance just to the north is narrow, but wide enough for you to
    enter. "
;

//------------------------------------------------------------------------------
/*  DARKROOM */

smallCave: DarkRoom 'Small Cave'
    "It's fortunate you didn't bring a cat, because there'd hardly be room to
    swing it in here. The exit lies to the south, and you could also squeeze
    through the narrow gap to the northwest. "
    south = startRoom
    out asExit(south)
    northwest = largeCave
;

/*  
 *   FIRE SOURCE & CANDLE 
 *
 *   A Candle is an object that can be lit and will stay alight for a certain
 *   length of time before going out. FireSource is a mix-in class which 
 *   will allow a lit candle to set light to other things (such as the oil 
 *   lamp defined below).
 */

+ FireSource, Candle 'red candle' 'red candle'
    initSpecialDesc = "A red candle lies on the ground. "
    
    /* 
     *   We'll make this candle a bit dimmer than the library default to 
     *   illustrate another object that's not bright enough to read by.
     */
    brightnessOn = 2
;

/*  
 *   ENTRY PORTAL
 *
 *   Since we mentioned a narrow gap in the room description we should 
 *   probably implement it.
 */

+ EntryPortal -> largeCave 'narrow gap' 'narrow gap'
    "It's lucky you went on a diet before you came here; you should just about
    be able to get through it. "
;

//------------------------------------------------------------------------------

largeCave: DarkRoom 'Large Cave'
    "This cave is so large you could almost get lost in it; even so it's clear
    enough that the only viable exits are to southeast, northeast and west. "
    southeast = smallCave
    northeast = roundCave
    west = deadEnd
;

/*  
 *   FUELED LIGHT SOURCE 
 *
 *   A FueledLightSource is a light source that consumes fuel as it burns. 
 *   The Library provides quite a bit of the implementation for this class, 
 *   but we need to do more work to make it function in a particular object 
 *   (unless we use the Candle subclass). Here we'll use a FueledLightSource 
 *   to implement an oil lamp. 
 */

+ oilLamp: FueledLightSource 'fine old brass oil lamp' 'oil lamp'
    "It's a fine old brass oil lamp. "
        
    /* 
     *   We need to define dobjFor(BurnWith) to provide some means of 
     *   lighting the oil lamp. This definition will allow us to ligh the 
     *   lamp either with the candle or with a match.
     */
    
    dobjFor(BurnWith)
    {
        verify() {}
        action()
        {
            "You light the lamp with {the iobj/him}. ";
            makeLit(true);
        }
    }
    
    /*  
     *   We also want the player to be able to extinguish the lamp once it's 
     *   lit.
     */
    
    dobjFor(Extinguish)
    {
        verify() {}
        action()
        {
            "You douse the lamp. ";
            makeLit(nil);
        }
    }
    
    /*  
     *   We'll start the lamp very low on oil, so we'll need to allow it to 
     *   be refueled. We'll assume it can be refuelled by pouring oil into 
     *   it, so we add an action handler for the PourInto action with the 
     *   lamp as the indirect object.
     */
        
    iobjFor(PourInto)
    {
        verify() 
        {
            if(fuelLevel == maxFuelLevel)
                illogicalAlready('The oil lamp is already full. ');
            if(isLit)
                illogicalNow('You can\'t pour anything into the lamp while
                    it\'s lit. ');
        }
        check()
        {
            if(gDobj != oilCan)
                failCheck('That won\'t do much good! ');
        }
        action()
        {
            "You pour enough oil into the lamp to fill it. ";
            fuelLevel = maxFuelLevel;
        }
    }
    
    /* Start the lamp off nearly out of fuel. */
    
    fuelLevel = 4
    
    /* 
     *   This is a custom property we are defining for our own use, not a 
     *   library property.
     */
    maxFuelLevel = 50
    
    /*  
     *   By default, the library version of the burnDaemon() reduces the 
     *   fuelLevel by 1 each time the FueledLightSource is lit, and makes it 
     *   go out once the fuelLevel reaches 0. We can override this to display
     *   messages when the lamp is about to go out, before calling the 
     *   inherited behaviour (which we still need).
     */
    
    burnDaemon()
    {
        switch(fuelLevel)
        {
            case 3: "<.p>The lamp starts to dim. "; break;
            case 2: "<.p>The lamp flickers, as if it's about to go out. "; break;
            case 1: "<.p>The lamp flame gutters; it really is about to go out."; 
            break;
        }
        inherited;
    }
    
    
    /* Customize the message for the lamp running out of fuel. */    
    sayBurnedOut()
    {
        "The oil lamp flickers and goes out. ";
    }
;

//------------------------------------------------------------------------------

deadEnd: DarkRoom 'Dead End'
    "The passage from the Large Cave rapidly peters out to this dead end. The
    way back is to the east. "
    east = largeCave
    out asExit(east)
;

+ oilCan: Thing 'oil can/oil/oilcan' 'can of oil'
    initSpecialDesc = "A can of oil rests on the floor. "
    dobjFor(PourInto)
    {
        preCond = [objHeld]
        verify() {}
    }
    
    /* 
     *   This is a bit of a hack: when we're pouring oil from this lamp into 
     *   something we want it referred to as 'oil' rather than 'the can of 
     *   oil'
     */
    theName = (gActionIs(PourInto) ? 'oil' : inherited)
;

//------------------------------------------------------------------------------

roundCave: DarkRoom 'Round Cave'   
    "The cave is roughly round, and looks like it once had exits in all
    directions, but rockfalls have blocked all but two of them, those to east
    and southwest. "
    east = squareCave
    southwest = largeCave
;

/*  
 *   FLASHLIGHT 
 *
 *   A Flashlight is a LightSource that can be turned on and off. 
 */

+ Flashlight 'old black plastic flashlight/torch' 'flashlight'
    "It's an old black plastic torch. "
    initSpecialDesc = "A flashlight lies abandoned in at the centre of the cave.
        "
;

/*  
 *   DECORATION 
 *
 *   Since we mentioned rockfalls in the room description we'll give them a 
 *   minimal implementation - as a Decoration.
 */

+ Decoration 'rock falls/rockfalls/exits' 'rockfalls'
    "Rockfalls block all the exits except those to the east and southwest. "
    isPlural = true
;

//------------------------------------------------------------------------------

squareCave: DarkRoom 'Square Cave'
    "This cave is so perfectly square that you suspect it must be artificial.
    The only way out is to the west. "
    west = roundCave
    out asExit(west)
;

/*  
 *   OPENABLE CONTAINER 
 *
 *   Rather than leaving the crystal in plain view we'll put it in a box.
 */

+ OpenableContainer 'rusty old iron box' 'iron box'
    "It's started to rust. << moved ? '' : 'It looks like it may have been here
        quite a while'>>. "
    initSpecialDesc = "An iron box nestles against a wall. "  
    
;

/*  
 *   LIGHT SOURCE
 *
 *   A plain LightSource is a Thing that gives off constant light. To make 
 *   this one more interesting we'll make it light up only when it would 
 *   otherwise be dark.
 */


++ crystal: LightSource 'magic glowing dim dull blue crystal' 'magic crystal'
    "It is <<isLit ? 'glowing with a steady light' : 'a dull blue colour'>>. "
    
    /* 
     *   After each turn when the crystal is in scope, check whether it 
     *   would be light if the crystal were not lit. If it would and the 
     *   crystal was previously unlit, report that the crystal has ceased to 
     *   glow. If it would be dark without the crystal and the crystal was 
     *   previously unlit, make it lit and report the fact.
     */
    afterAction()
    {
        /* Keep track of whether the crystal was lit when we started. */
        local wasLit = isLit;
        
        /* 
         *   Make it unlit so we can test what the light would be like 
         *   without it.
         */
        isLit = nil;
        
        /*   Then test the light level. */
        if(senseAmbientMax([sight]) > 1)            
        {
            if(wasLit)
            {
               "The crystal grows dim and stops glowing. ";
               return;
            }
        }
        else if(!wasLit)
        {
            "The crystal starts glowing. ";
            isLit = true;
            return;
        }
        
        /* 
         *   Restore the crystal to its starting lit/unlit state if we didn't
         *   report any change.
         */
        isLit = wasLit;
    }
    
    getState = (isLit ? crystalLitState : crystalUnlitState)
    allStates = [crystalLitState, crystalUnlitState]
;
    
/*  
 *   THING STATES
 *
 *   The library defines lightSourceStateOn and lightSourceStateOff as the 
 *   ThingStates for a LightSource. Here we provide customized versions to 
 *   cater for the extra vocabulary (glowing, dim, dull) associated with the 
 *   two states/
 */

crystalLitState: lightSourceStateOn
    stateTokens = ['lit', 'glowing']
;

crystalUnlitState: lightSourceStateOff
    stateTokens = ['unlit', 'dim', 'dull']
;

//==============================================================================
/*   
 *   SUPPLYING THE AMUSING OPTION
 */
     

modify finishOptionAmusing
    doOption()
    {
        "Try reading the note inside the caves using different light-sources:
        a match, the candle, the oil-lamp, the flashlight and the crystal.\b";
        
        if(!oilCan.seen)
            "Try going west from the large cave and see what you find.\b";
        else if(oilLamp.fuelLevel < 5)
            "Try refilling the oil lamp.\b";
        
        "Once you've recovered the crystal, try extinguishing all the other
        light sources while you're still in the caves.\b
        
        Then try lighting one of your other light-sources again.\b";   
        
        
        
        /* 
         *   this option has now had its full effect, so tell the caller
         *   to go back and ask for a new option 
         */

        return true;
    }
;



//==============================================================================
/*   
 *   MODIFYING A VERBRULE
 *
 *   At one point the game describes a gap the PC could squeeze through, so 
 *   it would be good to make SQUEEZE THROUGH a synonym for GO THROUGH. We 
 *   can do this either with a new VerbRule or by modifying an existing one. 
 *   Here we'll illustrate the second method.
 */

modify VerbRule(GoThrough)
    ('walk' | 'go' | 'squeeze') ('through' | 'thru')
        singleDobj
    :
;

/*  
 *   The player might type FILL LAMP WITH OIL instead of POUR OIL INTO LAMP; 
 *   defining the following VerbRule makes the two synoynmous. Note how we 
 *   fill the iobj and dobj roles in this new VerbRule: FILL X WITH Y is the 
 *   same as POUR Y INTO X, so in the FILL version the normal roles of 
 *   direct and indirect object are reversed from that of the normal way of 
 *   phrasing the PourIntoAction.
 */

VerbRule(FillWith)
    'fill' singleIobj 'with' singleDobj
    : PourIntoAction
    verbPhrase = 'fill/filling (with what) (what)'
;

/*  
 *   The player might also type just FILL LAMP; this VerbRule handles that by
 *   treating it as an incomplete PourIntoAction and prompting for what 
 *   should be used to fill it.
 */

VerbRule(FillWithWhat)
    'fill' singleIobj
    : PourIntoAction
    /* 
     *   This verbPhrase looks back to front; this is a consequence of 
     *   reversing the normal dobj and iobj roles. If the player types FILL 
     *   LAMP, this VerbRule takes Lamp to be the Indirect object of a 
     *   PourInto command (effectively POUR SOMETHING INTO LAMP) and then 
     *   prompts for (or in this game, chooses a default) direct object. The 
     *   parser will then construct the default object announcement on the 
     *   assumption that the dobj comes before the iobj placeholder in the 
     *   verbPhrase string, but we want the iobj announcement to say 'filling
     *   with the oil lamp' not 'filling the oil lamp'.
     */
    verbPhrase = 'fill/filling (with what) (what)'
    askDobjResponseProd = withSingleNoun
    construct()
    {
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = withSingleNoun;
    }
;
    

