# TheoryCraftClassic2 Fix

A maintained compatibility and correctness fork of **TheoryCraftClassic2** for
**World of Warcraft Classic Era 1.15.9**.

TheoryCraft adds detailed calculations to spell tooltips and action buttons. It
uses the character's gear, spell power, talents, buffs, target debuffs, spell
rank, mana, and other relevant stats to estimate damage, healing, efficiency,
and related values.

## Features

- Expected spell damage and healing
- Damage or healing per second
- Damage or healing per mana
- Critical-strike contribution
- Spell-power coefficients and efficiency
- Damage-over-time and healing-over-time calculations
- Remaining casts and total output before running out of mana
- Target armor, resistance, buffs, and debuffs
- Configurable action-button text
- Gear effects, set bonuses, and supported proc effects
- English, German, and French localization data

The original Classic classes are represented in the spell database:

- Druid
- Hunter
- Mage
- Paladin
- Priest
- Rogue
- Shaman
- Warlock
- Warrior

## What This Fork Fixes

The last public TheoryCraftClassic2 release predated the current Classic UI by
several years. This fork updates the addon for Classic Era 1.15.9 and repairs a
number of calculation errors found during a full source audit.

Notable changes include:

- Updated Classic Era manifests to interface `11509`
- Compatibility with the modern `C_AddOns`, `C_Item`, `C_Spell`,
  `C_SpellBook`, and `C_UnitAuras` APIs
- Updated spellbook and tooltip integration
- Replacement of removed UI templates and spellbook methods
- Safe startup behavior when Bartender4 requests data before character stats
  finish loading
- Correct numeric cast-time handling
- Correct low-rank spell-power penalties without mutating shared spell data
- Target-adjusted tooltip calculations for mana, combo points, armor, and
  configured resistance
- Correct target-aura, talent, power, equipment, and spell-text refreshes
- Correct action-bar page and slot mapping
- Correct merging and averaging of independent equipment procs
- Combat-log armor learning tied to the exact spell rank used
- Fixes for maximum-mana output, healing, hunter rotation, Seal, and other
  calculation paths
- Removal of accidental cross-file globals that could make results depend on
  addon execution order

## Installation

1. Download or clone this repository.
2. Place the addon files in:

   ```text
   World of Warcraft\_classic_era_\Interface\AddOns\TheoryCraftClassic
   ```

3. Make sure `TheoryCraftClassic-Classic.toc` is directly inside that folder.
   If GitHub created a folder such as `TheoryCraftClassic2-fix-main`, rename it
   to `TheoryCraftClassic`.
4. Start World of Warcraft or run `/reload` if the game is already open.
5. Enable **TheoryCraftClassic** from the AddOns menu.

## Usage

Hover over a supported spell to see TheoryCraft's calculations in its tooltip.
The addon can also display a selected value directly on action buttons.

| Command | Description |
| --- | --- |
| `/tc` | Open or close the TheoryCraft configuration window |
| `/theorycraft` | Same as `/tc` |
| `/tc on` | Enable TheoryCraft output |
| `/tc off` | Disable TheoryCraft output |
| `/tc more` | Show additional commands and diagnostic options |

Most display options can be configured from the `/tc` window. The default
action-button value is expected damage, with expected healing used as the
fallback for healing spells.

## Supported Game Version

The maintained target of this repository is:

```text
World of Warcraft Classic Era 1.15.9
TOC interface: 11509
```

Classic Era, Hardcore, and Season of Discovery use the same client family, but
Season of Discovery-specific runes and spells are not automatically supported
unless they exist in the addon's original spell database.

The legacy Burning Crusade manifest remains in the repository for historical
compatibility, but the current audit and testing target is Classic Era 1.15.9.

## Validation

The repaired source has been checked with:

- Lua syntax parsing across all 17 Lua files
- XML parsing and manifest load-order validation
- TOC reference validation
- Scoped-variable analysis
- Targeted regression checks for the repaired API and calculation paths
- Live-client error reports used to repair startup, action-button, and 1.15.9
  UI paths

Because character builds and supported spells vary, additional in-game reports
are welcome.

## Reporting a Bug

Please open a
[GitHub issue](https://github.com/Venpris/TheoryCraftClassic2-fix/issues) and
include:

- Character class and level
- Spell name and rank
- The displayed value and the expected value
- Relevant talents, gear, buffs, and target debuffs
- Whether the problem appears in the tooltip, action-button text, or both
- The complete Lua error and stack trace, if applicable

Lua errors can be enabled in game with:

```text
/console scriptErrors 1
/reload
```

## Formula Reference

The inherited formula notes are available in
[`formulasused.txt`](formulasused.txt). Spell coefficients and rank metadata are
primarily defined in [`gamedata.lua`](gamedata.lua).

## Credits

This is a maintenance fork of
[TheoryCraftClassic2](https://www.curseforge.com/wow/addons/theorycraftclassic2).

The original addon metadata credits:

- Endymon
- Boothin
- Scott
- Xodious
- Aelian, original code

The Classic Era 1.15.9 compatibility and correctness work in this repository is
maintained by Sebastian Carman.

## License

See [`LICENSE`](LICENSE).
