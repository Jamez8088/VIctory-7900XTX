param(
    [Parameter(Mandatory)][string]$Exe,
    [ValidateSet('diag', 'release')][string]$Build = 'diag',
    [ValidateSet('series-x', 'series-s')][string]$Console = 'series-x',
    [switch]$DryRun
)

# Conservative RX 6600 / 16 GB profile. Texture mip reduction and on-demand tiled residency are disabled pending validation. Series X is the rendering-baseline default;
# pass -Console series-s only for a separate low-memory experiment.
& (Join-Path $PSScriptRoot 'play.ps1') -Exe $Exe -Safe -Build $Build -Console $Console -DryRun:$DryRun -More @{
    VICTORY_MEMORY_PROFILE = 'compact'
    VICTORY_TEXTURE_POOL = '0'
    VICTORY_CARD_BUFFERS_MIN_MB = '64'
    VICTORY_CARD_BUFFERS_MB = '128'
}