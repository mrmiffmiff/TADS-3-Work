#charset "us-ascii"

/*   
 *   CONNECTORS.T
 *
 *   Demonstration of Room and Connector classes. A real game would be much 
 *   more fully implemented. Here we've kept the number of 
 *   non-Room-or-Connector objects to the minimum needed to demonstrate the 
 *   use of the various kinds of room and connector.
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
    IFID = 'bf1fea6f-f375-9cae-4504-f1f0905510b2'
    name = 'Connectors'
    byline = 'by Eric Eve'
    htmlByline = 'by <a href="mailto:eric.eve@hmc.ox.ac.uk">
                  Eric Eve</a>'
    version = '0.5'
    authorEmail = 'Eric Eve <eric.eve@hmc.ox.ac.uk>'
    desc = 'Demonstration of Room and TravelConnector classes.'
    htmlDesc = 'Demonstration of Room and TravelConnector classes.'
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
        "You've just bought a new property, so you thought you'd take a quick
        look round the house and grounds.<.p>";
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
hall: Room 'Hall'
    "The hall is empty, but a passage runs south, and there's an archway to the
    east as well as the front door to the north. A flight of stairs leads down.
    "
    /* 
     *   Only the east property points directly to another room; the other 
     *   three directional properties point to various other kinds of 
     *   TravelConnector: a ThroughPassage, a StairwayDown, and a Door.
     */
    south = hallPassage
    down = hallStairs
    north = frontDoorInside
    east = lounge
    
    /* A simple illustration of the enteringRoom() method */
    
    enteringRoom(traveler)
    {
        if(traveler == bicycle)
            "It occurs to you that you'd better not ride your bike into the hall
            too often, or you'll leave tyre marks on the floor. ";
    }
;

/*
 *   ACTOR  - PLAYER CHARACTER
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
    desc = "You look splendidly equipped to explore the area. "
;

/*
 *   STAIRWAY DOWN
 *
 *   A StairwayDown is something you can climb down, so a flight of stairs 
 *   is an obvious example. We can't a bicycle or push a trolley down a 
 *   staircase, though, so we'll attach a couple of travel barriers to the 
 *   stairway to prevent this. For the definition of these traval barrier 
 *   objects see below. For the moment note how defining them as objects 
 *   allows them to be used on many different TravelConnectors.
 *
 *   Nome of the three TravelConnectors we go on to define here (hallStairs, 
 *   hallPassage and frontDoorInside) apparently state where they lead to. 
 *   Their destinations are the locations of the objects which form their 
 *   other ends, which are defined later on.
 */


+ hallStairs: StairwayDown 'flight/stairs' 'flight of stairs'
    travelBarrier = [bikeBarrier, trolleyBarrier]
;

/*  
 *   THROUGH PASSAGE 
 *
 *   This is simply a passage the Player Character can ENTER or GO THROUGH. 
 *   The Player Character will automatically go through this passage if s/he 
 *   leaves the hall to the south. 
 */

+ hallPassage: ThroughPassage 'narrow passage' 'passage'
    "The narrow passage leads off to the south. "
;

/*  
 *   DOOR 
 *
 *   This is a very basic door, without any kind of lock. The player 
 *   character can GO THROUGH IT explicitly, or will be taken through it if 
 *   s/he leaves the hall to the north. If the door is closed it will be 
 *   opened with an implicit action. 
 *
 */

+ frontDoorInside: Door 'front door' 'front door'
;

/* 
 *   ENTRY PORTAL
 *
 *   An EntryPortal is something we can go through. The -> lounge in the 
 *   template points to the travel connector that's traversed when we go 
 *   through the arch. In this case the connector is simply the destination 
 *   room (the lounge). 
 */

+ hallArch: EntryPortal -> lounge 'carved painted white wood arch/archway' 'arch'
    "It's a carved wood arch, painted white. "
;

//------------------------------------------------------------------------------
/* Another ROOM */

kitchen: Room 'Kitchen'
    "The kitchen has been stripped of everything, pending its total
    refurbishment. A passage leads off to the north, and there's a laundry chute
    in the west wall<<secretPanel.isOpen ? ', and a large square opening in the
        east one' : '' >>. "
    north = kitchenPassage
    west = laundryChute
    east = secretPanel
;

/* 
 *   TRAVEL PUSHABLE
 *
 *   We need to supply a TravelPushable in order to demonstrate the use of 
 *   PushTravelBarrier.
 */

+ trolley: TravelPushable, Surface 'trolley' 'trolley'
    /* 
     *   Without a specialDesc the trolley wouldn't show up in a room 
     *   description, since TravelPushable inherits from NonPortable.
     */
    specialDesc = "There's a trolley here. "
    
    /* 
     *   By default pushing a TravelPushable results in a plain-vanilla 
     *   message "You push the trolley into the area. " We can override 
     *   describeMovePushable() to provide a more specific message.
     */
    
    describeMovePushable(traveler, connector)
    {
        "You push the trolley into <<traveler.location.destName>>. ";
    }
;

/* 
 *   FLASHLIGHT
 *
 *   We need to supply some kind of light source, otherwise it will be 
 *   impossible to explore the DarkRoom example (the cellar)
 */

++ torch: Flashlight 'red plastic flashlight/torch/light' 'flashlight'    
    "It's made of red plastic. "
;

/* 
 *   THROUGH PASSAGE (again)
 *
 *   Note that we link the kitchenPassage to the hallPassage so that when we 
 *   enter one we arrive in the location of the other.
 */

+ kitchenPassage: ThroughPassage ->hallPassage 'passage' 'passage'
;

/* 
 *   THROUGH PASSAGE, ROOM PART ITEM & TRAVEL WITH MESSAGE
 *
 *   Since the laundry chute is described as being on the west wall, we'll 
 *   make it a RoomPartItem and set it up so that it's described in response 
 *   to EXAMINE WEST WALL.
 *
 *   Since travelling via a laundry chute is a little unusual, we should 
 *   probably describe the travel here. One way of doing this is by adding 
 *   TravelWithMessage to the class list and defining the travelDesc property.
 *
 *   A more complete implementation of the laundry chute might allow the 
 *   player to put things in it which then fall down into the cellar, but we 
 *   don't need that complication for this demo game, so it's left as an 
 *   exercise for the interested reader. 
 */

+ laundryChute: RoomPartItem, TravelWithMessage, ThroughPassage 
    'laundry chute' 'laundry chute'
    "Although it's intended for laundry, it's large enough for a person to fit
    into as well. "
    specialNominalRoomPartLocation = defaultWestWall
    specialDesc = "A laundry chute is set in the west wall. "
    travelBarrier = [bikeBarrier, trolleyBarrier]
    travelDesc = "You find yourself tumbling rapidly down the laundry chute
        until you are unceremoniously ejected from its lower end, landing with a
        bone-shaking bump. ";
;

/*   
 *   HIDDEN DOOR
 *
 *   A HiddenDoor is one that doesn't reveal its presence at all (it can't be
 *   sensed) unless it's open.
 */

+ secretPanel: HiddenDoor ->bookcase 'large square opening' 'opening'
;

//------------------------------------------------------------------------------

/* DARK ROOM */

cellar: DarkRoom 'Cellar'    
    "The cellar is bare, since the last owners moved all their rubbish out and
    you haven't moved your own rubbish in yet. A flight of stairs leads up, and
    the end of the laundry chute protrudes from the west wall. "
    
    /* 
     *   By default a DarkRoom displays "In the dark" and "It's pitch black" 
     *   as its name and description respectively, but we can change that on 
     *   individual dark rooms by overriding the following two properties.
     */
    roomDarkName = 'Cellar (in the dark) '
    roomDarkDesc = "It's too dark to see anything in here, but you can just make
        out some stairs leading up. "
    up = cellarStairs
    west = cellarChute
;

/*  
 *   STAIRWAY UP 
 *
 *   Note that this points to the hallStairs StairwayDown object as its other
 *   end, so climbing these stairs will take us to the location of the 
 *   hallStairs (i.e. the hall) whereas climbing down the hall stairs will 
 *   bring us here (to the cellar).      
 */

+ cellarStairs: StairwayUp -> hallStairs 'flight/stairs' 'flight of stairs'
    /* 
     *   By giving the stairs a brightness of 1 we make them dimly visible 
     *   even when the cellar is dark. This will allow the player to climb 
     *   the stairs even if s/he arrives in the cellar via the laundry chute 
     *   without a light source (which would otherwise leave the player 
     *   character totally stuck). Note that giving the stairs a brightness 
     *   of 1 makes only the stairs visible in the dark; they will not 
     *   illuminate anything else/
     */
    brightness = 1
;

  /* 
   *   EXIT ONLY PASSAGE
   *
   *   This is where we emerge from if we enter the laundry chute in the 
   *   kitchen. It's an ExitOnlyPassage since we can't climb back up the 
   *   chute. The purpose of this passage is thus to provide the other end 
   *   of the laundry chute that starts in the kitchen.
   */

+ cellarChute: RoomPartItem, ExitOnlyPassage ->laundryChute 
    'laundry end/chute' 'laundry chute'
    dobjFor(Climb) asDobjFor(TravelVia)
    dobjFor(TravelVia)
    {
       action()
        {
            reportFailure('There\'s no way you can climb back up the chute. ');
        }
    }
    
    specialNominalRoomPartLocation = defaultWestWall
    specialDesc = "The end of the laundry chute protrudes from the north wall. "
;

//------------------------------------------------------------------------------

  /* 
   *   A WALL (A ROOM PART)
   *
   *   In the lounge we'll demonstrate one way of modeling two exits in the 
   *   same direction, in this case two doors leading through the south 
   *   wall. We'll start by providing a customized south wall that describes 
   *   the two doors when it is examined.
   */

loungeSouthWall: defaultSouthWall
    desc = "Two doors, one oak and the other pine, lead through the south wall.
        "
;

/*  Another ROOM */

lounge: Room 'Lounge' 
    "This will be a comfortable enough room once it is furnished, no doubt. At
    the moment, though, there's nothing here except an exit to the west and a
    pair of doors (one oak, one pine) leading south. "
    
    /* 
     *   TRAVEL MESSAGE
     *
     *   TravelMessage is a subclass of TravelConnector that displays a 
     *   message (travelDesc) when the player characters traverses it. The 
     *   two properties defined in the template used below are the 
     *   destination and travelDesc.
     */
    
    west: TravelMessage { ->hall "You <<travelMethod()>> back out into the hall. " }
    
    /* 
     *   ASK CONNECTOR
     *
     *   If the player types SOUTH it's unclear which of the two doors 
     *   leading south s/he wants to go through. We handle this with an 
     *   AskConnector, which asks which of its travelObjs the player wants 
     *   to go through.
     *
     *   Note, however, that if one door is open and the other closed, the 
     *   parser will automatically choose the open door without asking 
     *   (whether or not you think that's a good idea, that's how the 
     *   standard library behaves).
     */
    
    south: AskConnector {
        travelObjs = [pineDoor, oakDoor]
        travelAction = GoThroughAction
        promptMessage = "There are two doors you could go through to the south. "
        travelObjsPhrase = 'of them'
    }
    
    /* Replace the defaultSouthWall with our own customized version. */
    
    roomParts = static inherited - defaultSouthWall + loungeSouthWall
;

/* 
 *   AUTO-CLOSING DOOR
 *
 *   We'll make the oak door auto-closing, which means it'll close itself 
 *   after anyone goes through it.
 */

+ oakDoor: AutoClosingDoor 'oak door*doors' 'oak door'    
;

/*  An ordinary DOOR */

+ pineDoor: Door 'pine door*doors' 'pine door'
    /* 
     *   A Door is a subclass of TravelConnector, so we can attach travel 
     *   barriers to it directly.
     */
    travelBarrier = [bikeBarrier, trolleyBarrier]
;

//------------------------------------------------------------------------------

/*  Yet Another ROOM */

study: Room 'Study'
    "This long, rectangular room is currently unfurnished, but you've earmarked
    it for your study. There's an oak door to the north, and an empty bookcase
    <<bookcase.isOpen ? 'has swung open from' : 'rests against'>> the west
    wall. "
    north = studyDoor    
    out asExit(north)
    west =  bookcase
;

/*  The other side of the AUTO-CLOSING DOOR */

+ studyDoor: AutoClosingDoor -> oakDoor 'oak door*doors' 'oak door'    
;
    
  /* 
   *   SECRET DOOR
   *
   *   A SecretDoor is something that doesn't look like a door at all unless 
   *   it's open. Here we'll use a bookcase as a secret door. When closed, 
   *   it'll just look like a bookcase; when open, the player can go through 
   *   it to the kitchen.  
   *
   *   Since it's described as a bookcase people might try to put things on 
   *   it or in it, so we'll make it a Surface to allow this. Note that 
   *   making a Container wouldn't have worked, since the isOpen property of 
   *   Container would conflict with the isOpen property of SecretDoor.
   */

+ bookcase: Surface, SecretDoor 
    'large square wooden empty (book) bookcase/case/shelf/shelves' 'bookcase'
    "It's a large, square, wooden bookcase, currently empty. <<isOpen ? 'It has
        swung open, revealing a secret exit behind' : ''>> "
    
    /* 
     *   Since this is a secret door, it won't respond to OPEN and CLOSE 
     *   commands, so we need to provide some other means of opening and 
     *   closing it. This could be with a concealed lever or secret button, 
     *   but since we want to keep the use of other objects to a minimum 
     *   here, we'll just let the player PULL the bookcase open and PUSH it 
     *   closed.    
     */
    
    dobjFor(Pull)
    {
        verify()
        {
            if(isOpen)
                illogicalAlready('It\'s already fully open. ');
        }
        action()
        {
            makeOpen(true);
            "The bookcase swings open, revealing an opening behind. ";
        }
    }
    
    dobjFor(Push)
    {
        verify()
        {
            if(!isOpen)
                inherited;
        }
        action()
        {
            makeOpen(nil);
            "You push the bookcase shut again. ";
        }
    }
    
    /* 
     *   We'll also make MOVE BOOKCASE act like PUSH BOOKCASE if it's open 
     *   and PULL BOOKCASE if it's closed.
     */
    
    dobjFor(Move)
    {
        verify() {  }
        action()
        {
            if(isOpen)
                replaceAction(Push, self);
            else
                replaceAction(Pull, self);
        }
    }
    
    /* Make PUT X IN BOOKCASE behave like PUT X ON BOOKCASE */
    
    iobjFor(PutIn) remapTo(PutOn, DirectObject, self)
;

 /* 
  *   HIDDEN
  *
  *   There's an opening behind the bookcase that we can only see when the 
  *   bookcase is open. We can implement that with a Hidden object.
  */

+ Hidden 'secret large square opening/exit' 'opening'
    "It's a large square opening. "
    dobjFor(Enter) remapTo(Enter, bookcase)
    dobjFor(GoThrough) remapTo(GoThrough, bookcase)
    discovered = (bookcase.isOpen)
;

//------------------------------------------------------------------------------

 /* 
  *   FLOORLESS ROOM
  *
  *   It's quite difficult to come up with a realistic example of 
  *   FloorlessRoom, since FloorlessRoom = Floorless, Room, i.e. and indoor 
  *   room without a floor, whereas the obvious kinds of floorless room 
  *   (such as the top of a tree or mast) are more likely to be outdoors. 
  *   We'll meet a more obvious Floorless, OutdoorRoom at the top of a tree 
  *   below; in the meantime this example is a little contrived.
  */

floorlessChamber: FloorlessRoom 'Floorless Chamber'
    "For some reason this room has no floor, <<shoes.wornBy == me ? 'but since
        you are wearing the special shoes, you float effortlessly in the air' :
      'so you are forced to hang onto the door to stop yourself falling'>>. "
       
    bottomRoom = cellar
    north = chamberDoor
    out asExit(north)
    
    /* 
     *   the receiveDrop() method of a floorless room defines what happens 
     *   to an object that's dropped here. Normally the object falls to the 
     *   location defined in bottomRoom, but we want to treat the shoes as a 
     *   special case, so we override receiveDrop() to make the shoes remain 
     *   the Floorless Chamber when dropped, while using the inherited 
     *   handling for everything else.
     */
    
    receiveDrop(obj, desc)
    {
        if(obj == shoes)
        {
            "The special shoes remain hovering in the air. ";
            shoes.moveInto(self);
        }
        else
            inherited(obj, desc);
    }
    
    /*
     *   A demonstration of roomBeforeAction and roomAfterAction. You 
     *   obviously can\'t jump in a room without a floor, so Jumping is a 
     *   good candidate for an action to rule out in a roomBeforeAction().  
     */
    
    roomBeforeAction()
    {
        if(gActionIs(Jump))
            
            /* 
             *   Using failCheck(msg) is a shortcut way of writing:
             *
             *       reportFailure(msg); 
             *       exit;
             *
             *   Where the exit stops the action in its track. failCheck() is
             *   defined as a method of Thing, so can only be used on 
             *   Thing-derived classes.
             */
            failCheck('You can\'t; there\'s no floor, so your feet aren\'t
                touching it. ');
    }
    
    roomAfterAction()
    {
        if(gActionIs(Yell))
            "Your shout echoes strangely round the floorless chamber. ";
    }
;

/*  Another ordinary DOOR */

+ chamberDoor: Door ->pineDoor 'pine door*doors' 'pine door'
    noteTraversal(traveler)
    {
        if(shoes.wornBy == me)
            "The shoes seem to lose some of their levitational effect as
            you step out of the floorless chamber, and you find yourself
            firmly back on the ground. ";
    }
;

/* 
 *   WEARABLE
 *
 *   These shoes will be useful both for this FloorlessRoom and for the 
 *   example of a RoomConnector below, where they are used in connection 
 *   with a canTravelerPass() method. Although they don't strictly belong in 
 *   a game demonstrating rooms and connectors, it's almost impossible to 
 *   demonstrate every type of connector without at least a few other 
 *   objects. 
 */

+ shoes: Wearable 'anti-gravity special brown pair/shoes' 'pair of brown shoes'
    "They're brown in colour, and marked <q>water-repellant levitationals</q>. "
    isInInitState = (isDirectlyIn(floorlessChamber))
    initSpecialDesc =  "A pair of shoes hover in the air, defying gravity. "    
    isPlural = true
    dobjFor(Wear)
    {
        action()
        {
            if(gActor.isIn(floorlessChamber))
                "Putting on the shoes allows you to float in the floorless
                chamber without having to hang on to the door. ";
            inherited;
        }
    }
    
    dobjFor(Doff)
    {
        action()
        {
            if(gActor.isIn(floorlessChamber))            
                "You hang tightly on the door with one hand while gingerly
                removing the shoes with the other.";
           
            inherited;
        }
    }
    
;

//------------------------------------------------------------------------------

/* 
 *   OUTDOOR ROOM
 *
 *   The drive is the first OutdoorRoom defined in this game. It's an 
 *   OutdoorRoom because it models an exterior location (i.e. one without 
 *   walls, and with a sky instead of a ceiling.
 */

drive: OutdoorRoom 'Front Drive'
    "The drive opens out into a busy road to the north. A path leads off to the
    east, while to the east stand some dense woods. The south side of the drive
    is occupied by a large house, while a tall oak tree grows right in the
    middle of the drive. "
    south = frontDoorOutside
    in asExit(south)
    up = oakTree
    
    /* 
     *   FAKE CONNECTOR & DEAD END CONNECTOR
     *
     *   Note the difference between the FakeConnector and the 
     *   DeadEndConnector that follow. The FakeConnector models travel that 
     *   is not even attempted (although there's no physical barrier 
     *   preventing it), while the DeadEndConnector models travel into and 
     *   back out of an area that's not actually implemented in the game.
     */
    
    north: FakeConnector { "You don't want to wander out into the road right
        now; at this time of day the traffic is so busy that it's just not safe
        for << me.isIn(bicycle) ? 'cyclists' : 'pedestrians'>>. " }
    west: DeadEndConnector { -> 'the woods' "You <<travelMethod()>> into the
        woods, but the paths become so confusing that for a while you are 
        lost. Eventually you find your way back onto a familiar path and manage
        to return to your starting point. " }
    east = drivePath
    
    /* 
     *   ATMOSPHERE LIST
     *
     *   The atmosphereList can be used for a series of atmospheric messages 
     *   that the room will automatically display when this property is 
     *   defined. We attach a ShuffledEventList to this property to make the 
     *   messages display in shuffled-random order.
     */   
    
    atmosphereList: ShuffledEventList
    {
        [
            'A lorry rumbles past on the road. ',
            'The sound of a loud siren wails from the road. ',
            'A pair of rabbits scuttle off into the woods. ',
            'A flock of pigeons flies overhead. ',
            'The sun comes out from behind a cloud. ',
            'A gust of wind rustles the oak tree. '
        ]
        
        /* 
         *   We probably don't want to see one of these messages every turn, 
         *   so we'll set them to display only once every two turns on 
         *   average.
         */        
        eventPercent = 50
    }
;

/*  
 *   ENTERABLE 
 *
 *   We use an Enterable to represent the outside of the house. Thus can be 
 *   entered via the front door, so we point the house's connector property 
 *   to the frontDoorOutside object using the -> section of the template.
 */

+ house: Enterable -> frontDoorOutside 'large house' 'large house'
    "It's a large house with a front door that\'s <<frontDoorOutside.isOpen ?
      'invitingly open' : 'firmly closed'>>. "
;

++ frontDoorOutside: Door ->frontDoorInside 'front door' 'front door'
;

/* 
 *   A less conventional STAIRWAY UP
 *
 *   A StairwayUp can be used for things other than stairs; anything 
 *   climbable is a candidate for a StairwayUp, including a tree.
 *
 *   But note that we can hardly ride a bicycle up a tree, or push a trolley 
 *   up one, so we attach the appropriate travel barriers to prevent this.
 */     


+ oakTree: StairwayUp 'large oak tree' 'large oak tree'
    travelBarrier = [bikeBarrier, trolleyBarrier]
    canTravelerPass(traveler) { return !bicycle.isIn(traveler); }
    explainTravelBarrier(traveler)
    {
        "You can hardly climb the tree carrying the bicycle. ";
    }
;

/* PATH PASSAGE */

+ drivePath: PathPassage 'path' 'path'
    "The path leads off to the east. "
;

/* 
 *   VEHICLE combined with CHAIR
 *
 *   We need a Vehicle to demonstrate VehicleBarriers, so we'll provide this 
 *   bicycle.
 */

+ bicycle: Chair, Vehicle 'old cycle/bicycle/bike' 'bicycle'
    "It's old, but it looks functional enough. "
    initSpecialDesc = "An old bicycle leans against the front of the house. "
    
    /* 
     *   The bike is perfectly usable without the following action handling, 
     *   but RIDE BIKE and RIDE BIKE <direction> (e.g. RIDE BIKE NORTH) are 
     *   such obvious commands to try that it seems worth implementing them.
     *
     *   We start by implementing RIDE BIKE. If the player character is not 
     *   already on the bike we make this equivalent to SIT ON BIKE, 
     *   otherwise we ask the player which direction the bike should be 
     *   ridden in. 
     */
    
    dobjFor(Ride)
    {
        verify() { }
        action()
        {
            if(!gActor.isIn(self))
                replaceAction(SitOn, self);
            else
                "Which way do you want to ride the bike? ";
        }
    }
    
    /*
     *   The other obvious form of command is RIDE BIKE <dir> (e.g. RIDE BIKE
     *   NORTH). We implement that next. 
     */
    
    dobjFor(RideDir)
    {
        /* 
         *   Adding this precondition makes the player character sit on the 
         *   bike as an implicit action before moving the bike if the player 
         *   types RIDE BIKE <dir> while the player character isn't on the 
         *   bike.
         */
        
        preCond = [actorDirectlyInRoom]
        verify() { }
        
        /* 
         *   There doesn't seem to be a very straightforward way to remap 
         *   RIDE BIKE NORTH to GO NORTH, so we use this slightly more 
         *   complicated way instead. Basically we find which 
         *   TravelConnector lies in the direction of the proposed travel 
         *   and then attempt to Travel Via that connector.
         */
        
        action()
        {
            local conn;
            
            /* ask the actor's location for the connector in our direction */
            conn = gActor.location.getTravelConnector(gAction.dirMatch.dir, gActor);
            
            /* perform a nested TravelVia on the connector */
            nestedAction(TravelVia, conn);            
        }      
        
    }
;

/* 
 *   ENTERABLE
 *
 *   We want ENTER WOODS to behave the same way as WEST. We do that by 
 *   pointing the associated connector to the location's west property.
 */

+ Enterable ->(location.west) 'dense woods/wood/trees' 'dense woods'
    isPlural = true
;

//------------------------------------------------------------------------------
/*  
 *   FLOORLESS
 *
 *   Here we combine Floorless with OutdoorRoom since this location has no 
 *   walls either; the only room part applicable at the top of the tree is 
 *   the defaultSky.
 */

topOfTree: Floorless, OutdoorRoom 'Top of Tree' 'the top of the tree'
    "The top of the tree doesn't afford much of a view, since the leaves and
    branches get in the way. "
    bottomRoom = drive
    down = trunk
;

/*  An unconventional STAIRWAY DOWN to match the StairwayUp at the bottom */

+ trunk: StairwayDown -> oakTree 'trunk/tree' 'trunk'
;

//------------------------------------------------------------------------------
/*   Another OUTDOOR ROOM */

lawn: OutdoorRoom 'Lawn'
    "This large lawn is enclosed to east and south by a bend in a river, though
    you could board the boat that's moored up just to the east. A path leads
    west back to the main drive. "
    west = gardenPath    
    east = mainDeck
    south = riverConnector
    
    /* 
     *   NO TRAVEL MESSAGE
     *
     *   The NoTravelMessage provides a custom message to explain why travel 
     *   is not possible in a particular direction. In a real game we'd 
     *   doubtless need to implement the shrubbery object too.
     */
    
    north: NoTravelMessage { "Even if you could force your way through the think
        shrubbery, which you can't, on the far side of it runs the main road,
        which you'd rather avoid right now. "}
;

/*  TRAVEL WITH MESSAGE combined with PATH PASSAGE */

+ gardenPath: TravelWithMessage, PathPassage ->drivePath
    'path' 'path'
    travelDesc = "You <<travelMethod()>> back down the path. "
;

/* 
 *   ENTERABLE
 *
 *   We'll provide a boat here in order to give examples of ShipBoard rooms. */


+ boat: Enterable ->mainDeck 'large boat' 'large boat'
    "It's about fifteen feet long. "
   specialDesc = "A large boat is moored up on the river at the bottom of the
       garden, just to the east. "
    dobjFor(Board) asDobjFor(Enter)
    getFacets = [boat2] // see below
;

//------------------------------------------------------------------------------

 /* 
  *   A MULTILOC DECORATION
  *
  *   The river is not strictly essential in this demonstration game, but 
  *   since it's mentioned rather prominently, it would seem needlessly 
  *   sloppy not to implement it, albeit in minimal form.
  */


MultiLoc, Decoration 'swollen river' 'river'
    "Swollen by recent heavy rain, the river runs broad and fast. "
    locationList = [lawn, meadow]
;

 /* 
  *   ROOM CONNECTOR
  *
  *   A RoomConnector provides a two-way connection between neighbouring 
  *   locations. Since in the simplest case this can be done simply by 
  *   pointing the appropriate direction properties of the two rooms to link 
  *   the rooms to each other, there's no point exemplifying the simplest 
  *   case. A RoomConnector is only useful if it embodies a travel barrier 
  *   or some side-effect of travel, such as displaying a message, so here 
  *   we'll exemplify both.
  */


riverConnector: RoomConnector
    /* 
     *   The room1 and room2 properties contain the two locations connected 
     *   by this RoomConnector.
     */
    room1 = lawn
    room2 = meadow
       
    /*
     *   Note that if the PC is riding the bicycle, the traveler will be the 
     *   bicycle, not the PC, and the bicycle can never wear the shoes; thus 
     *   this canTravelerPass() method will only allow the PC to pass on foot
     *   wearing the shoes. It will also prevent the trolley from being 
     *   pushed across the river, since the trolley can never where the 
     *   shoes either (nor can the PushTravel object created to handle 
     *   moving the trolley).
     */
    canTravelerPass(traveler) { return shoes.wornBy == traveler; }
    explainTravelBarrier(traveler)
    {
        
        /* 
         *   The tricky case is where we're trying to push the trolley 
         *   across the river. At that point the first object trying to 
         *   travel via this connector will be an temporary PushTraveler 
         *   object created to handle the push travel action. We need to 
         *   make a special test for this condition.
         */       
        
        switch(traveler)
        {
        case me:
            "You aren't equipped for walking on water. "; break;
        case bicycle:
            "You can hardly cycle across the river. "; break;
        default:
            if(traveler.ofKind(PushTraveler))
               "You can't push <<traveler.obj_.theName>> across the river. "; 
            else
                "You can't cross the river. "; 
            break;
        }
    }
    
    /* 
     *   We can use noteTraversal() to describe what happens when an actor 
     *   crosses the river. Note that this message will display for *any* 
     *   actor crossing the river, not just the player character. In this 
     *   game the player character is the only actor, so that's okay; the 
     *   effect is exactly the same as if we'd added TravelWithMessage to the
     *   class list and defined a travelDesc. In a game which had mobile 
     *   actors in addition to the player character, using TravelWithMessage 
     *   and travelDesc would be a better choice.
     */
    
    noteTraversal(traveler)
    {
        "Aided by the special shoes, you are able to walk across the river. ";
    }
;

//------------------------------------------------------------------------------
/*  Another OUTDOOR ROOM */

meadow: OutdoorRoom 'Meadow' 
    "This vast meadow stretches as far as you can see in every direction except
    north, where it is bounded by the river. "
    
    /* 
     *   Here we override the standard "You can't go that way" message and 
     *   provide our own version instead.
     */
    
    cannotGoThatWayMsg = 'It\'s your own property you want to explore, and this
        meadow clearly isn\'t part of it. '
    north = riverConnector
;

//------------------------------------------------------------------------------

 /*  
  *   SHIPBOARD
  *
  *   We add a few locations aboard a boat to demonstrate Shipboard, 
  *   ShipboardRoom and the various shipboard directions. Since the main deck
  *   has no walls, we need to combine Shipboard with OutdoorRoom. 
  */

mainDeck: Shipboard, OutdoorRoom 'Main Deck'
    "The main deck is tidy to the point of bareness. The main cabin lies aft,
    and you can leave the boat to starboard. "
    
    /* 
     *   Since we're now aboard a boat we can now use the shipboard 
     *   directions port, starboard, fore and aft, so we'll use these to 
     *   define the direction properties on all these boat-location. Since 
     *   the boat is moored up and will never move in this game, the compass 
     *   directions will map unambiguously onto the shipboard directions, 
     *   and since the player might use these too, we'll implement them via 
     *   asExit macros. Note that it's the shipboard directions that will 
     *   show up in the exit lister, since these are the ones we define 
     *   directly.
     */
    
    starboard = lawn
    west asExit(starboard)
    out asExit(starboard)
    aft = mainCabin
    south asExit(aft)
    in asExit(aft)
    fore: NoTravelMessage { "You don't want to walk off the bow! " }
    north asExit(fore)
;

/* 
 *   EXITABLE
 *
 *   Providing this Exitable object here allows us to handle commands like 
 *   LEAVE THE BOAT or GET OUT OF THE BOAT.
 */

+ boat2: Exitable -> lawn 'boat' 'boat'
    "It's about fifteen feet long from stem to stern. <<location.desc()>>"
    dobjFor(GetOffOf) asDobjFor(GetOutOf)
    
    /* 
     *   We make boat and boat2 facets of each other so that if, for 
     *   example, the player were to type ENTER BOAT followed by LEAVE IT, 
     *   the parser would know what IT refers to (since the parser now 
     *   recognizes boat and boat2 as facets of the same object.
     */
    getFacets = [boat]
;

/*  
 *   SHIPBOARD ROOM
 *
 *   Both the main cabin and the sleeping cabin are effectively indoor 
 *   locations aboard the boat, that is they have walls, floor and ceiling, 
 *   so we can use the ShipboardRoom class for both of them.
 */

mainCabin: ShipboardRoom 'Main Cabin'
    "The main cabin is bare, since the boat is being refitted. The way back out
    to the deck is fore, while the sleeping cabin lies to port. "
    fore = mainDeck
    north asExit(fore)
    out asExit(fore)
    port = sleepingCabin
    east asExit(port)
;

sleepingCabin: ShipboardRoom 'Sleeping Cabin'
    "There would normally be a bunk here, but it's been removed while the boat
    is being refitted. The way out back to the main cabin is to starboard. "
    starboard = mainCabin
    west asExit(starboard)
    out asExit(starboard)
;

//==============================================================================
/* 
 *   VEHICLE BARRIER & PUSH TRAVEL BARRIER
 *
 *   We define a TravelBarrier and a VehicleBarier for use on a number of 
 *   TravelConnectors.
 */

modify TravelBarrier
    replace explainTravelBarrier(traveler, ...) {}
;

bikeBarrier: VehicleBarrier
    explainTravelBarrier(traveler)
    {
        "You can't ride the bike that way. ";
    }    
;

trolleyBarrier: PushTravelBarrier
    /* 
     *   This illustrates one way in which we can customise the message 
     *   explaining why the trolley can't be pushed through certain 
     *   connectors. We wouldn't want to do this for a whole lot of 
     *   different travel barriers and connectors, so in a more complicated 
     *   game we'd probably devise a more generalized scheme.
     */
    
    explainTravelBarrier(traveler)
    {
        "You can't push the trolley ";

        if(connector && connector.ofKind(ThroughPassage))
            "through <<connector.theName>>. ";        
        else if(connector && connector.ofKind(StairwayDown))
            "down <<connector.theName>>. ";
        else if(connector && connector.ofKind(StairwayUp))
            "up <<connector.theName>> ";                
        else
            "that way. ";        
    }
    /* 
     *   PushTravelBarrier doesn't provide a connector property by default; 
     *   we define it here and ensure it gets updated correctly by modifying 
     *   TravelConnector as below.
     */
    
    connector = nil
;

/*  MODIFYING TRAVELCONNECTOR */

modify TravelConnector
    checkTravelBarriers(dest)
    {
        /* 
         *   Let trolleyBarrier that we're the connector that travel is 
         *   about to be attempted via, so that 
         *   trolleyBarrier.explainTravelBarrier() can refer to us in its 
         *   message.
         */
        trolleyBarrier.connector = self;
        inherited(dest);
    }
;    


 /* 
  *   Defining a FUNCTION
  *
  *   Since we've used travel messages on several TravelConnectors that can 
  *   be traversed either on foot or on the bicycle, it's helpful to have a 
  *   utility function that gives us a verb appropriate to the means of 
  *   locomotion.
  */

travelMethod()
{
    return me.isIn(bicycle) ? 'cycle' : 'walk';
}

//==============================================================================

/*  
 *   NEW ACTIONS
 *
 *   Add a couple of new actions for riding the bike, since RIDE BIKE or RIDE
 *   BIKE EAST etc. would be such natural actions to try
 */


DefineTAction(Ride)
;

VerbRule(Ride)
    ('ride' | 'mount') singleDobj
    :  RideAction
    verbPhrase = 'ride/riding (what)'
;

DefineTAction(RideDir)
;

VerbRule(RideDir)
    'ride' singleDobj ('to' ('the'|) |) singleDir
    : RideDirAction
    verbPhrase = 'ride/riding (what) (where)'
;

modify Thing
    dobjFor(Ride)
    {
        preCond = [touchObj]
        verify() { illogical(cannotRideMsg); }
    }
    dobjFor(RideDir)
    {
        preCond = [touchObj]
        verify() { illogical(cannotRideMsg); }
    }
    
    cannotRideMsg = '{That dobj/he} {is} not something you can ride. '
;
