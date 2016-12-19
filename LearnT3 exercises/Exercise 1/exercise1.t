#charset "us-ascii"

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
    IFID = '08b87938-74fc-4cb3-b5a7-fc2aeafe2a4e'
    name = 'Learning T3 - Exercise 1'
    byline = 'by Robert Eisenman'
    htmlByline = 'by <a href="mailto:robert.t.eisenman@gmail.com">
                  Robert Eisenman</a>'
    version = '1'
    authorEmail = 'Robert Eisenman <robert.t.eisenman@gmail.com>'
    desc = 'A larger map than we\'ve seen so far; layout of my childhood home.'
    htmlDesc = 'A larger map than we\'ve seen so far; layout of my childhood home, with inaccurate directions that are correct at a relative angle..'
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
robRoom: Room 'Robert\'s Room'
    "This is the author's room. The hall is to the south. "
    south = hall1
;

/*
 *   Define the player character.  The name of this object is not
 *   important, but it MUST match the name we use to initialize
 *   gameMain.initialPlayerChar above.
 *   
 *   Note that we aren't required to define any vocabulary or description
 *   for this object, because the class Actor, defined in the library,
 *   automatically provides the appropriate definitions for an Actor when
 *   the Actor is serving as the player character.  Note also that we don't
 *   have to do anything special in this object definition to make the
 *   Actor the player character; any Actor can serve as the player
 *   character, and we'll establish this one as the PC in main(), below.  
 */
+ me: Actor
;


hall1: Room 'Hall'
    "This is a hallway. There is more hallway to the east and west. You can get back to the author's room to the north. "
    north = robRoom
    east = hall2
    west = hall3
;

hall3: Room 'Hall'
    "This is a hallway, there's more hallway to the east and northwest. The Guest Room is to the North. 
    The Master Bedroom is to the southwest. "
    east = hall1
    north = guestRoom
    southwest = masterRoom
    northwest = hall4
;

hall4: Room 'Hall'
    "This is a hall. Continue to the southeast. There's a bathroom north. "
    southeast = hall3
    north = mBath
;

mBath: Room 'Master Bathroom'
    "This is a bathroom. Exit to the south. "
    south = hall4
;

guestRoom: Room 'Guest Bedroom'
    "This is where guests sleep. The hall is to the south. "
    south = hall3
;

masterRoom: Room 'Master Bedroom'
    "This is the master bedroom. The hall is back northeast. "
    northeast = hall3
;

hall2: Room 'Hall'
    "This is a hallway. There is a bedroom to the north, a bathroom to the northeast, and the dining room to the south. 
    The living room is to the east. "
    west = hall1
    north = broRoom
    south = dineRoom
    northeast = gBath
    east = livingRoom
;

broRoom: Room 'A Bedroom'
    "The Author's brother once lived in this room when he was younger. The exit is to the south. "
    south = hall2
;

gBath: Room 'A Bathroom'
    "This bathroom is near the bedrooms. You can leave southwest or southwards. "
    south = hall2
    southwest = hall2
;

dineRoom: Room 'Dining Room'
    "The dining room. You can get back to the hall to the north, or to the Living Room to the Northeast. "
    north = hall2
    northeast = livingRoom
;

livingRoom: Room 'Living Room'
    "While there is an exit to the house here, you can't leave. The hallway is to the west, and the kitchen is to the east.
    YOu can find the dining room to the south or southwest. "
    south = dineRoom
    southwest = dineRoom
    west = hall2
    east = kitchen
;

kitchen: Room 'Kitchen'
    "This is a rather large kitchen. The family room is to the south(east), and the living room to the north.
    A mini-foyer can be found to the east. "
    east = foyer
    west = livingRoom
    south = famRoom
    southeast = famRoom
;

foyer: Room 'Mini-Foyer'
    "Nothing to see here. Kitchen to the west, laundry room to the south. "
    west = kitchen
    south = laundry
;

laundry: Room 'Laundry Room'
    "Leave north back to the way to the kitchen, or south to a bathroom. "
    north = foyer
    south = fBath
;

fBath: Room 'A Bathroom'
    "This is a bathroom. The laundry room is to the north. The family room is to the south. "
    north = laundry
    south = famRoom
;

famRoom: Room 'Family Room'
    "This is a room for the family. A bathroom is to the north, the kitchen is to the northwest. "
    north = fBath
    northwest = kitchen
;