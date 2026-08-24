# Stargate (Gazm Toolchain)

This repository contains the complete assembly source code for Williams' classic arcade game **Stargate** including the **Main 6809 Board** and the **Sound 6800 Board**, structured and buildable using the **Gazm** toolchain.

## Building

To assemble the complete set of 12 Main Game ROM binaries and the Sound Board ROM binary:

```bash
gazm build
```

The resulting binaries are written to `roms/01` through `roms/12` and `roms/sound.bin`.

## Verification & ROM Checksums

All ROM images match the original arcade release byte-for-byte:

### Main Board (Motorola 6809)

| ROM File | CPU Address | SHA-1 Checksum | Status |
| :--- | :--- | :--- | :--- |
| `roms/01` | `$0000` | `f003a5a9319c4eb8991fa2aae3f10c72d6b8e81a` | ✅ 100% Match |
| `roms/02` | `$1000` | `087c6da93318e8dc922d3d22e0a2af7b9759701c` | ✅ 100% Match |
| `roms/03` | `$2000` | `7badb4318b208f49d7fa65e915d0aa22a1e37915` | ✅ 100% Match |
| `roms/04` | `$3000` | `6b4d47c2899fe9f14f9dab5928499f12078c437d` | ✅ 100% Match |
| `roms/05` | `$4000` | `54f871983699113e31bb756d4ca885c26c2d66b4` | ✅ 100% Match |
| `roms/06` | `$5000` | `54b02d944caf95283c9b6f0160e75ea8c4ccc97b` | ✅ 100% Match |
| `roms/07` | `$6000` | `a487ffcd4920d1056b87469735f7e1002f6a2e49` | ✅ 100% Match |
| `roms/08` | `$7000` | `8726ebaf048db9608dfe365bf434ed5ca9452db7` | ✅ 100% Match |
| `roms/09` | `$8000` | `efacc4a6d4b2af9a236c9d520de6d605c79cc5a8` | ✅ 100% Match |
| `roms/10` | `$D000` | `ba833f48ddfc1bd04ddb41b1d1c840d66ee7da30` | ✅ 100% Match |
| `roms/11` | `$E000` | `6ca39f493eb8b370154ad46ef01976d352c929e1` | ✅ 100% Match |
| `roms/12` | `$F000` | `c46872550e0ca031453c6513f8f0448ecc9b5572` | ✅ 100% Match |

### Sound Board (Motorola 6800)

| ROM File | CPU Address | SHA-1 Checksum | Status |
| :--- | :--- | :--- | :--- |
| `roms/sound.bin` | `$F800` | `9c4334ac3ff15d94001b22fc367af40f9deb7d57` | ✅ 100% Match |

To verify all checksums directly:
```bash
./checksumroms \
  f003a5a9319c4eb8991fa2aae3f10c72d6b8e81a roms/01 \
  087c6da93318e8dc922d3d22e0a2af7b9759701c roms/02 \
  7badb4318b208f49d7fa65e915d0aa22a1e37915 roms/03 \
  6b4d47c2899fe9f14f9dab5928499f12078c437d roms/04 \
  54f871983699113e31bb756d4ca885c26c2d66b4 roms/05 \
  54b02d944caf95283c9b6f0160e75ea8c4ccc97b roms/06 \
  a487ffcd4920d1056b87469735f7e1002f6a2e49 roms/07 \
  8726ebaf048db9608dfe365bf434ed5ca9452db7 roms/08 \
  efacc4a6d4b2af9a236c9d520de6d605c79cc5a8 roms/09 \
  ba833f48ddfc1bd04ddb41b1d1c840d66ee7da30 roms/10 \
  6ca39f493eb8b370154ad46ef01976d352c929e1 roms/11 \
  c46872550e0ca031453c6513f8f0448ecc9b5572 roms/12 \
  9c4334ac3ff15d94001b22fc367af40f9deb7d57 roms/sound.bin
```

## Structure

- `src/stargate.gazm`: Master assembly file configuring module scopes, memory layouts, and ROM outputs for 6809 main board.
- `src/*.gazm`: Converted 6809 assembly modules for each game subsystem.
- `snd_src/main.src`: Master assembly file for 6800 soundboard.
- `snd_src/vsndrm2.src`: Converted 6800 soundboard code.
- `orig/`: Original unmodified source files and reference ROMs.
- `gazm.toml`: Multi-target build configuration for both `stargate` (6809) and `sound` (6800).

## Naming conventions

- **Structs are PascalCase** and read as types: `Proc`, `Smap`, `Lava`,
  `Ptable`, `Pia`, `PlayerData`. Fields are referenced scoped:
  `Proc::time`, `[Proc::addr,u]`, `Proc::size * 85`.
- **Struct fields are lowercase** and keep the original Williams variable
  names (`d1`..`d7`, `cod`, `x8`) so the source stays diffable against
  the original. New fields: lowercase, descriptive.
- **`size` is reserved** as the implicit struct member (total size in
  bytes) — never declare a field named `size`.
- **Local offset aliases** use the `!` local-label form:
  `!p_obj: equ Proc::data` — keep those per-module and lowercase.
