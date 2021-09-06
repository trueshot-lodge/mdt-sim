https://wago.io/Yya4XBbl-
Exports MDT routes into simc raid events for simming realistic dungeon runs.

Requires the MythicDungeonTools addon https://github.com/Nnoggie/MythicDungeonTools

Typical usage:
"export solo" exports all mobs with a fraction of their hp to attempt to simulate a single character's dps contribution to the dungeon using just one character profile. Currently set to 27% based on an average from logs.

Advanced usage:
"export full" exports all mobs with full hp, as they are found in-game, this should only be used if a full 5 character profile sim is being ran in order to replicate an actual dungeon run.

The exported string contains sim options and a raid event list that matches the active route, for the full raid event documentation see https://github.com/simulationcraft/simc/wiki/RaidEvents#pull

To ensure an accurate sim, this resulting string should not be modified other than for a few exceptions for more advanced configuration:

- The buff overrides at the top can be modifed to enable any buffs that your desired group composition will provide.
- For each raid event in the resulting list, the delay and bloodlust options can be adjusted for an even more accurate representation of the dungeon. These delay values should ideally come from logs of past dungeon runs to establish approximate travel times to the pulls. The bloodlust option forces a bloodlust cast at the start of the pull.
