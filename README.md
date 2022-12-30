## MDT Sim https://wago.io/Yya4XBbl-

Requires MythicDungeonTools https://github.com/Nnoggie/MythicDungeonTools

## How To Use:

STEP 1 - BUILD A ROUTE IN MDT
You obviously need a route to sim, build one or import one. Make sure the keystone level is set to a level you want. Be sure to include all the bosses you will do and all the trash you need to fill that 100% trash completion.

STEP 2 - EXPORT FROM MDT
The Simc Export button shown in the image examples will create the text you need, Ctrl-A to select everything in the box that is shown then Ctrl-C to copy it. Esc will then hide it.

STEP 3 - INSERT INTO RAIDBOTS
On any sim page that supports Expert Mode, find the toggle button to enable it. The last of the new boxes will be the Footer box, Ctrl-V to paste what was copied into that box.

PUTTING THE TEXT IN THE FOOTER AND ONLY THE FOOTER BOX IS EXTREMELY IMPORTANT.

Now do everything else in the sim like normal.

## Overview:

Exports MythicDungeonTools routes into simc raid events. Discord Jayeasy#5077 to report problems.

Makes use of the DungeonRoute fightstyle to spawn mobs using raw hp amounts and grouped together in realistic pulls. The mob lifetimes are then determined by how fast the sim actors actually deal damage to the spawned enemies.

For an alternative source of the pull event sim input that this would provide, try the "Simulate" option on https://keystone.guru/ for easy to use predefined routes and simc export all in one. For patreon subs they also have advanced features like distance based pull delays for even more realistic dungeon sims.

## Options:

Change these options as you see fit in custom options:
Thundering Mark Duration: How long to keep the Mark of Lightning if it is applied on the pull. By default every pull will use the value of this option but can be changed individually in the text output.
Minimum/Maximum Delay: A range of seconds that will be used to generate random delays that simulate running to each pull in the route.

Placing the export result in the Footer box is an extremely important part of this process to make sure certain default options are overridden like they need to be.

## Advanced:

The export contains sim options and a raid event list that matches the active route, for the full raid event documentation see the SimC Wiki:
https://github.com/simulationcraft/simc/wiki/RaidEvents#pull

Each pull can be configured with these options for a more realistic run:

- The buff overrides at the top beginning with override. should be changed to 1 if your group composition will provide that party buff.
- The delay values on each raid event line should ideally come from logs of past dungeon runs to establish approximate travel times to the pulls.
- The bloodlust option on each raid event line forces a bloodlust cast at the start of that pull.
- The mark_duration option on each raid event line will set the length in seconds to apply the Thundering Affix Mark of Lightning damage buff if it happens during that pull. A value from 0 to 15.

By default the "Simc Export" button exports all mobs with a fraction of their hp to simulate a single player's dps contribution to the dungeon using just one character profile. This currently defaults to 27% which is a rough average based on logs, but can be configured with the "mob health %" input box. This value must be from 0 to 100 and should only be changed if you're sure you know what you're doing.

For example, this set to 100 would export all mobs with full hp in the case you were going to sim a full dungeon run with 5 character profiles. In the case of simming multiple profiles together, the single_actor_batch option should be changed to 0 and the mob health % input should be increased (doubled for 2 dps players etc.) accordingly to increase the mob hp.