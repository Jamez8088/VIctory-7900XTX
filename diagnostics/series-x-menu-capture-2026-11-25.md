# RX 6600 Series X menu capture — 2026-11-25

## Configuration
- Launcher: scripts/play-rx6600-16gb.ps1
- Console profile: Series X (launcher default)
- Texture pool: disabled
- Mip reduction: disabled
- On-demand tiled residency: disabled
- Card buffer limits: 64 MiB minimum / 128 MiB cap

## Observation
- Victory initialized and presented frames; the menu was visible.
- The controlled diagnostic run remained responsive for approximately 34 seconds.
- At the sampled point, victory.exe used approximately 9.2 GiB private memory and 4.39 GiB working set; system free physical RAM was approximately 4.81 GiB.
- The memory map reported approximately 4,628 MiB title heaps, 4,015 MiB mapped title views, 6,236 MiB title page pool, and 2,577 MiB write-combined allocations (committed/resident figures as printed by Victory).
- No explicit DXGI device-removed / device-hung error was found in the captured log before the diagnostic process was deliberately stopped.
- This was a menu/idle capture, not a successful gameplay test and not a reproduction of the user's reported crash after a handful of rendered frames.

## Safety / next investigation
- The diagnostic process was stopped deliberately to avoid allowing memory use to grow further on the 16 GiB host.
- No source code was changed as part of this capture.
- Next: capture the actual crash with Windows Application Error / WER details and Victory's final log lines; determine whether it is a Victory process crash or a GPU/driver timeout before changing rendering code.

Full raw capture: series-x-menu-capture-2026-11-25.log.
