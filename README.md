# Mikrozustaende-I

Codes and notations for **Mikrozustände**, a concert project for piano and live electronics, supported by [musikfonds.de](https://musikfonds.de).

Copyright © 2021 Aykut Çağlayan — [MIT License](LICENSE)

## Overview

This repository holds the live-electronics code and score PDFs for *Mikrozustände*: SuperCollider scripts for synthesis and control, a Pure Data patch for pitch tracking, and a Python pipeline for rhythmic processing and MusicXML export.

Especially [Section_III.pdf](Section_III.pdf) and [Section_IV.pdf](Section_IV.pdf) were composed using the modular harmonic material processed by these tools. Module data for the composition pipeline lives in [bach_progressions](https://github.com/ayk-caglayan/bach_progressions) if you want to run it yourself.

## Notation

| File | Note |
|------|------|
| [Section_I.pdf](Section_I.pdf), [Section_II.pdf](Section_II.pdf) | indicative notation for the performer |
| [Section_III.pdf](Section_III.pdf), [Section_IV.pdf](Section_IV.pdf) | Composed with the modular material, exact rendering |

## Repository layout

```
Mikrozustaende-I/
├── Section_I.pdf … Section_IV.pdf
├── supercollider/
│   ├── composition/     Composition / module playback
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

## Usage

### Composition (Python → MusicXML)

```bash
cd python
python import_process_modules.py
```

Uncomment one of the example `Session` blocks at the bottom of `import_process_modules.py` to generate a fragment. Output is written to `python/outlet/`.

The script selects modular harmonic fragments, applies rhythmic envelopes and quantization, plays four-part SCAMP playback, and exports MusicXML. `supercollider/composition/Bach_slices_template8.scd` can read the same module data for SuperCollider playback.

**Module data:** clone [bach_progressions](https://github.com/ayk-caglayan/bach_progressions) alongside this repo (`../bach_progressions/bach_modules.txt`), or set `BACH_MODULES_PATH`. See that repo's [README](https://github.com/ayk-caglayan/bach_progressions/blob/main/README.md) for file format details.

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

## License

MIT — see [LICENSE](LICENSE).
