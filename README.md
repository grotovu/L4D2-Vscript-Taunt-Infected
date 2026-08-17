# L4D2 Vscript Taunts Attract Infected

A VScript for **Left 4 Dead 2** that makes Survivor vocalizer commands (Taunts, Laughs, and Death Screams) attract surrounding Common Infected.

Features fully customizable aggro ranges via config file and manual chat command support.

## Use Case

This script monitors active Survivor speech scenes and automatically calls `RushVictim()` on vocalizing players, causing all Common Infected within a configured radius to immediately rush their position.

My primary use case for this is taunting or screaming at chokepoints to clear out rooms and hallways. This results in rooms being clear to search, more zombies being spawned ahead of the map, and hence, more zombies killed on average.

---

## Features

- **Vocalizer Scene Detection:** Monitors active Survivor `.vcd` sound files for taunts, laughs, and screams.
- **Dynamic Horde Aggro:** Uses native `RushVictim()` to force nearby Common Infected to target and rush the noisy player.
- **Customizable Aggro Radii:** Independent audio range settings for Taunts, Laughs, and Screams.
- **Chat Command Aggro:** Players can type `taunt,<range>` (e.g., `taunt,750`) in text chat to manually draw infected from a specific distance.
- **Configuration:** Generates and loads settings automatically from `left4dead2/ems/vocalizercommands/taunt_infected.txt`.

---

## Example Config

Settings automatically load from `left4dead2/ems/vocalizercommands/taunt_infected.txt`:

```text
// Vocalizer Command Configuration
vocal_range_taunt 500
vocal_range_laugh 250
vocal_range_scream 1000
