## Overview

Discord Jayeasy#5077 to report problems.

Most existing modes for simming dungeons try to create a very generalized dungeon experience with time based add spawns. Instead, this mode spawn mobs using actual hp amounts found in game and grouped together in pulls. The mob lifetimes are then determined by how fast the sim actors actually deal damage to the spawned enemies. It also tries to make simming specific dungeons easier by allowing the pulls to be defined easily by an MythicDungeonTools export, and allows them to be configured with travel times between the pulls and per-pull bloodlust usage to further improve sim accuracy.

The exports here in the samples directory are based on logs of real timed m+ runs and should be adequate for most players just looking for more accurate dungeon sim results. I highly recommend them if you do not plan on configuring your own exports thoroughly with the options explained below under Advanced Usage.

The MDT Sim WeakAura:
https://wago.io/Yya4XBbl-

Requires the addon MythicDungeonTools:
https://github.com/Nnoggie/MythicDungeonTools

## Basic Usage:

There is one option that can be changed in custom options: Default Encrypted Relic (defaults to Urh)

Can be used with any Raidbots sim mode where Expert Mode exists. Paste your /simc profile into the inputs as usual, then enable Expert Mode and paste the entire output of the new "Simc Export" button result into the Footer section of Expert Mode.

## Advanced Usage:

The export contains sim options and a raid event list that matches the active route, for the full raid event documentation see the SimC Wiki:
https://github.com/simulationcraft/simc/wiki/RaidEvents#pull

Each pull can be configured with these options for a more realistic run:

- The buff overrides at the top beginning with **override.** should be changed to 1 if your group composition will provide that party buff.
- The **delay** values on each raid event line should ideally come from logs of past dungeon runs to establish approximate travel times to the pulls.
- The **bloodlust** option on each raid event line forces a bloodlust cast at the start of that pull.
- The **relic** option on each raid event line causes the desired encrypted buff to be applied after the first relic is killed as well as the resulting automation that is spawned. Options are urh / vy / wo.

By default the "Simc Export" button exports all mobs with a fraction of their hp to simulate a single player's dps contribution to the dungeon using just one character profile. This currently defaults to 27% which is a rough average based on logs, but can be configured with the "mob health %" input box. This value must be from 0 to 100 and should only be changed if you're sure you know what you're doing.

For example, this set to 100 would export all mobs with full hp in the case you were going to sim a full dungeon run with 5 character profiles. In the case of simming multiple profiles together, the **single_actor_batch** option should be changed to 0 and the mob health % input should be increased (doubled for 2 dps players etc.) accordingly to increase the mob hp.