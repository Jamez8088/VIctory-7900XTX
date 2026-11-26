# RX 6600 / 16 GB experimental profile

Status: experimental, not committed. The original rx6600-stability branch is untouched.

## Launch

From the repository root, run:

    .\scripts\play-rx6600-16gb.ps1 -Exe 'D:\GameBackup1\Game\game_scarlett_master.exe'

The profile defaults to --console series-s. To compare the larger memory budget, pass -Console series-x. Add -DryRun to print the effective settings without launching the game.

The profile sets:

- VICTORY_MEMORY_PROFILE=compact: 1 MiB memory windows and root-view tails; explicit VICTORY_WINDOW_KB and VICTORY_WINDOW_TAILS settings override it.
- VICTORY_TEXTURE_POOL=0: avoids the texture pool configuration that previously increased RX 6600 local/shared memory use.
- VICTORY_TEXTURE_DROP_MIPS=1: omits the largest mip from eligible host texture copies.
- VICTORY_LEVELS_ON_DEMAND=1: allows eligible texture levels to become resident on demand.
- VICTORY_CARD_BUFFERS_MIN_MB=64 and VICTORY_CARD_BUFFERS_MB=128: conservative card-buffer limits.

Series S is the default because its advertised memory budget is materially smaller and better matched to an 8 GB GPU. This changes the emulated console budget and display profile; it is not a free optimization.

## Measurements so far

Short startup comparisons only; these are not sustained gameplay benchmarks.

| Run | Private memory | Physical page pool | Host textures | Remaining commit |
|---|---:|---:|---:|---:|
| Series X, compact windows | 9.6 GB | 6.2 GB | 992 MB | 7.8 GB |
| Series S, compact windows | 6.9 GB | 4.0 GB | 507 MB | 13.3 GB |
| Series S, mip-drop + on-demand | 7.0 GB | 4.0 GB | 488 MB | Not captured |

The Series S startup run used about 2.7 GB less private memory than the Series X run at approximately the same elapsed time. A 45-second Series S run with mip drop and on-demand levels enabled remained around 6.9 GB private memory with roughly 4.4–4.5 GB physical RAM free. The runtime logged that host texture copies omit their largest mip levels, and on-demand residency reported D3D12 tiled-resource tier 4. However, the frame log showed 30 FPS, only 11 draws per frame, and zero copy or texture-upload work. This appears to have been an idle/menu state, not the memory-heavy gameplay scene. The mip-drop benefit under actual gameplay is therefore not yet measured.

The previous Series X test reached 22.5 GB private memory after roughly 70 seconds, with only 337 MB physical RAM free. Avoid long stress tests until the new profile is validated.

## Code and validation

The experimental branch includes:

- The earlier RX 6600 copy-state barrier experiment in crates/victory-gpu/src/host/place.rs.
- The compact memory-window profile in crates/victory-gpu/src/shadow.rs.
- Mip-drop support adapted from the public VICTORY_TEXTURE_DROP_MIPS work: resource descriptions, view shifting, staging/detiling, readback mapping, and level-aware copies.
- scripts/play-rx6600-16gb.ps1 and explicit console selection in scripts/play.ps1.

Validation performed:

- Targeted compact-window test passed.
- Retained-mip detiling test passed.
- GPU library suite: 376 passed, 1 failed, 34 ignored. The single failure is the pre-existing descriptor::host::tests::views_are_made_beside_the_heap_and_copied_in test, which also failed before the mip-drop work.
- Diagnostics build completed successfully after the final logging change; both targeted mip-layout tests passed.
- No sustained gameplay validation has been performed with mip drop enabled.