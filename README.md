# Mikrozustaende-I

Codes and notations for **Mikrozustände**, a concert project for piano and live electronics, supported by [musikfonds.de](https://musikfonds.de).

Copyright © 2021 Aykut Çağlayan — [MIT License](LICENSE)

## Overview

This repository is a performance and composition toolkit: SuperCollider scripts for live synthesis and control, a Pure Data patch for pitch tracking, and a Python pipeline that transforms Bach chorale harmonic modules into notated fragments (MusicXML).

Bach module data is maintained separately in [**bach_progressions**](https://github.com/ayk-caglayan/bach_progressions) — a web application for searching chord progressions from Bach chorales ([findbachprogressions.aykutcaglayan.net](https://findbachprogressions.aykutcaglayan.net)). This project reads the same `bach_modules.txt` dataset for compositional and live-performance workflows.

## Repository layout

```
Mikrozustaende-I/
├── supercollider/
│   ├── composition/     Bach module playback experiments
│   ├── networking/      Multi-machine tempo OSC sync (sender/receiver)
│   ├── granular/        Granular synthesis and live recording
│   ├── synthesis/       Oscillators, filters, physical models
│   ├── pitch/           OSC receiver for sigmund~ pitch tracking
│   └── control/         Akai MPK mini MIDI/GUI mapping
├── puredata/
│   └── sigmund.pd       8-channel pitch/amplitude analysis → OSC
└── python/
    ├── import_process_modules.py   Module import, rhythmic processing, MusicXML export
    └── outlet/                     Generated MusicXML (gitignored)
```

## Requirements

| Tool | Used for |
|------|----------|
| [SuperCollider 3](https://supercollider.github.io/) | Live synthesis, buses, MIDI, OSC, GUIs |
| [miSCellaneous_lib](https://github.com/JamesWenlock/miSCellaneous_lib) | `granular_DX.scd` (DXEnvFan, sVarGui) |
| [Pure Data](https://puredata.info/) | `sigmund.pd` pitch tracking |
| Python 3 | `import_process_modules.py` |
| `matplotlib`, `musx`, `scamp`, `scamp_extensions` | Python composition pipeline |

## Bach module data setup

Clone [bach_progressions](https://github.com/ayk-caglayan/bach_progressions) alongside this repository:

```bash
cd ..
git clone https://github.com/ayk-caglayan/bach_progressions.git
```

Expected layout:

```
parent/
├── Mikrozustaende-I/
└── bach_progressions/
    └── bach_modules.txt
```

Alternatively, point scripts at any copy of the file:

```bash
export BACH_MODULES_PATH=/path/to/bach_progressions/bach_modules.txt
```

### `bach_modules.txt` schema

Tab-separated values with a header row. Progression fragments were extracted from Bach chorales using [music21](https://web.mit.edu/music21/) (see the [bach_progressions README](https://github.com/ayk-caglayan/bach_progressions/blob/main/README.md)).

| Column | Field |
|--------|-------|
| 1 | `module_nr` |
| 2 | `part_code` — 1=Soprano, 2=Alto, 3=Tenor, 4=Bass |
| 3 | `note_counter` |
| 4 | `time_offset` (beats) |
| 5 | `pitch_Hz` |
| 6 | `noteLengthAsQuarter` |
| 7 | `startingKeyPitchClass` (0–11) |
| 8 | `startingMode` — 3=minor, 4=major |
| 9 | `finalKeyPitchClass` |
| 10 | `finalMode` |
| 11 | `bwv_nr` — source chorale (e.g. `bwv269`) |

## Usage

### Composition (Python → MusicXML)

```bash
cd python
python import_process_modules.py
```

Uncomment one of the example `Session` blocks at the bottom of `import_process_modules.py` to generate a fragment. Output is written to `python/outlet/`.

The script classifies modules by key and mode on import, then selects and processes modules with rhythmic envelopes, quantization, and four-part SCAMP playback before exporting MusicXML.

### Live electronics (SuperCollider + Pure Data)

Scripts are standalone SuperCollider workspaces — evaluate blocks in the SC IDE as needed. There is no single boot file; load scripts according to your performance setup.

Typical signal chain:

```
Piano/mic → sigmund.pd (pitch/amp via OSC)
         → supercollider/pitch/get_sigmund_2.scd
         → supercollider/granular/record_to_buffer.scd → live buffer
         → supercollider/granular/granular_DX.scd (+ granular_GUI, Akai_controlls5)

supercollider/networking/ALPHA_sender.scd  ←OSC tempo→  ALPHA_receiver.scd
```

1. Start Pure Data: open `puredata/sigmund.pd`
2. Load pitch receiver: `supercollider/pitch/get_sigmund_2.scd`
3. Load synthesis/control scripts as required from `supercollider/`

### Bach module playback (SuperCollider)

`supercollider/composition/Bach_slices_template8.scd` reads `bach_modules.txt` from a sibling `bach_progressions` clone. Edit `~bachModulesPath` at the top of the read block if your layout differs.

### Multi-machine performance sync

Configure machine-specific settings in:

- `supercollider/networking/ALPHA_sender.scd` — tempo clock, score page switching
- `supercollider/networking/ALPHA_receiver.scd` — beat/bar display, OSC receive

These files contain hardcoded LAN IPs and a Desktop path to score PNG pages. Adjust for your performance machines before use.

## Performance conventions

Across SuperCollider scripts, shared naming is used for patching:

| Symbol | Meaning |
|--------|---------|
| `a[...]` | Audio bus dictionary |
| `b[...]` | Control bus dictionary |
| `f[...]` | Buffer dictionary |
| `i[...]` | Running synth instances |
| `~sig_generators` | Target group for signal synths |
| `~entropy_sources` | Target group for modulation sources |
| `~machine_listening` | Target group for input/recording |

Scripts assume a coordinated SC session with buses and groups set up before dependent blocks are evaluated.

## Related projects

- [**bach_progressions**](https://github.com/ayk-caglayan/bach_progressions) — search Bach chorale chord progressions; source of `bach_modules.txt`
- [findbachprogressions.aykutcaglayan.net](https://findbachprogressions.aykutcaglayan.net) — web interface for progression search

## License

MIT — see [LICENSE](LICENSE).
