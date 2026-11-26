# RX 6600 / 16 GB experimental profile

Status: experimental. The original rx6600-stability branch is untouched. The first gameplay attempt with texture mip reduction and on-demand tiled residency enabled produced severe visual corruption and a GPU device removal. Both options are disabled in the default launcher pending isolated validation.

## Launch

From the repository root:

    .\scripts\play-rx6600-16gb.ps1 -Exe 'D:\GameBackup1\Game\game_scarlett_master.exe'

The profile defaults to --console series-s. To compare the larger memory budget, pass -Console series-x. Add -DryRun to print effective settings without launching the game.

## Current launcher settings

- VICTORY_MEMORY_PROFILE=compact: 1 MiB memory windows and root-view tails.
- VICTORY_TEXTURE_POOL=0: disables the texture pool configuration that previously increased RX 6600 local/shared memory use.
- VICTORY_CARD_BUFFERS_MIN_MB=64 and VICTORY_CARD_BUFFERS_MB=128: conservative card-buffer limits.
- Texture mip reduction and on-demand tiled residency are disabled by default until separately tested.

Series S is the default because its advertised memory budget is materially smaller. This changes the emulated console budget and display profile; it is not a free optimization.

## Measurements

Short startup comparisons only; these are not sustained gameplay benchmarks.

| Run | Private memory | Physical page pool | Host textures | Remaining commit |
|---|---:|---:|---:|---:|
| Series X, compact windows | 9.6 GB | 6.2 GB | 992 MB | 7.8 GB |
| Series S, compact windows | 6.9 GB | 4.0 GB | 507 MB | 13.3 GB |

The Series S startup run used about 2.7 GB less private memory than the Series X run at approximately the same elapsed time. These were short startup/menu observations, not proof of sustained gameplay performance.

The previous Series X test reached 22.5 GB private memory after roughly 70 seconds, with only 337 MB physical RAM free. Avoid long stress tests until the profile is validated.

## Code and validation

The experimental branch includes the RX 6600 copy-state barrier experiment, compact memory-window profile, experimental mip-drop and tiled-residency code (not enabled by the default launcher), and the dedicated launch script.

The GPU library suite previously reported 376 passed, 1 failed, 34 ignored. The single failure was the descriptor test that also failed before these changes. No sustained gameplay validation has been completed.
