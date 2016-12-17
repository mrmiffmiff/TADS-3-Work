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
    IFID = '6f375102-43df-4f89-ac94-a7d46f2f1c52'
    name = 'Goldskull'
    byline = 'by Robert Eisenman'
    htmlByline = 'by <a href="mailto:robert.t.eisenman@gmail.com">
                  Robert Eisenman</a>'
    version = '1'
    authorEmail = 'Robert Eisenman <robert.t.eisenman@gmail.com>'
    desc = 'A simple two room game from Getting Started with TADS 3'
    htmlDesc = 'A simple two room game from Getting Started with TADS 3'
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
startroom: Room 'Outside Cave' /*We could call this anything we like, this format automatically sets the roomName property */
    "You're standing in the bright sunlight just outside
    of a large, dark, foreboding cave, which lies to the north. " //Obviously, this auto-sets the desc property
    north = cave //The room called "cave" lies to the north.
    
    enteringRoom(traveler)
    {
        if(goldSkull.isIn(gPlayerChar))
           {
           "You have succeeded in retrieving the prize.";
           
            finishGameMsg(ftVictory, [finishOptionUndo]);
           }
    }  
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

cave: Room
    roomName = 'Cave' //Also a valid syntax
    desc = "You're inside a dark and musty cave. Sunlight pours in from a passage to the south. "
    south = startroom //Case sensitive     
;

pedestal: Surface, Fixture //Various classes in adv3 to help with behavior; First takes precedence
    //Can't be both surface and container due to the how the library makes distinctions between in and on
    //or, rather, doesn't
    name = 'pedestal'
    desc = "A small, colorless pedestal. Not majestic at all. "
    noun = 'pedestal'
    location = cave
;

goldSkull: Thing
    name = 'gold skull'
    desc = "A rather grotesque golden skull. "
    noun = 'skull' 'head'
    adjective = 'gold' //Shortcut: vocabWords = 'gold skull/head'
    location = pedestal
    
    actionDobjTake()
    {   
        if(location != pedestal ||      //Am I off the pedestal?
           smallRock.location == pedestal ) //Or is the rock there?
            inherited;
        else
        {
            "As you lift the skull, a volley of poisonous
            arrows is shot from the walls! You try to dodge
            the arrows, but they take you by surprise!";
        
            finishGameMsg(ftDeath, [finishOptionUndo]);
        }
    }
;

smallRock: Thing
    name = 'small rock'
    desc = "A regular small rock. Nothing too special."
    vocabWords = 'small rock'
    location = cave
    
    actionDobjTake()
    {
        if (location != pedestal || goldSkull.location == pedestal)
            inherited;
        else{
            "As you lift the rock, a volley of poisonous
            arrows is shot from the walls! You try to dodge
            the arrows, but they take you by surprise!";
        
            finishGameMsg(ftDeath, [finishOptionUndo]);
        }
    }
;