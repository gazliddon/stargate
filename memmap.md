# Stargate HW details

## Memory Map

| Addr      | Type                 | Notes                                                               |
|------     |------                |-------                                                              |
| 0000-8FFF | ROM                  |                                                                     |
| 0000-97FF | Video                | RAM Bank switched with ROM                                          |
| 9800-BFFF | RAM                  |                                                                     |
| C000-CFFF | I/O                  |                                                                     |
| D000-FFFF | ROM                  |                                                                     |
| C000-C00F | color_registers      | 16 bytes of BBGGGRRR                                                |
|           |                      |                                                                     |
| C804      | widget_pia_dataa     | widget = I/O board                                                  |
| C805      | widget_pia_ctrla     |                                                                     |
| C806      | widget_pia_datab     |                                                                     |
| C807      | widget_pia_ctrlb     | CB2 select between player 1 and player 2 controls if Table or Joust |
|           |                      | bits 5-3 = 110 = player 2                                           |
|           |                      | bits 5-3 = 111 = player 1                                           |
| C80C      | rom_pia_dataa        |                                                                     |
| C80D      | rom_pia_ctrla        |                                                                     |
| C80E      | rom_pia_datab        | bits 0-5 = 6 bits to sound board                                    |
|           |                      | bits 6-7 plus CA2 and CB2 = 4 bits to drive the LED 7 segment       |
| C80F      | rom_pia_ctrlb        |                                                                     |
| C900      | rom_enable_scr_ctrl  | Switch between video ram and rom at 0000-97FF                       |

## PIA mapping
* C804 widget_pia_dataa (widget = I/O board)
	* bit 0  Fire
	* bit 1  Thrust
	* bit 2  Smart Bomb
	* bit 3  HyperSpace
	* bit 4  2 Players
	* bit 5  1 Player
	* bit 6  Reverse
	* bit 7  Down
* C806 widget_pia_datab
	* bit 0  Up
	* bit 1  Inviso
	* bit 2
	* bit 3
	* bit 4
	* bit 5
	* bit 6
	* bit 7  0 = Upright  1 = Table
* C80C rom_pia_dataa
	* bit 0  Auto Up
	* bit 1  Advance
	* bit 2  Right Coin        (High Score Reset in schematics)
	* bit 3  High Score Reset  (Left Coin in schematics)
	* bit 4  Left Coin         (Center Coin in schematics)
	* bit 5  Center Coin       (Right Coin in schematics)
	* bit 6  Slam Door Tilt
	* bit 7  Hand Shake from sound board

## ROMs
```
ROM_START( stargate ) /* "B" ROMs labeled 3002-13 through 3002-24, identical data */
	ROM_REGION( 0x19000, "maincpu", 0 )
	ROM_LOAD( "stargate_rom_10-a_3002-10.a7", 0x0d000, 0x1000, CRC(60b07ff7) SHA1(ba833f48ddfc1bd04ddb41b1d1c840d66ee7da30) )
	ROM_LOAD( "stargate_rom_11-a_3002-11.c7", 0x0e000, 0x1000, CRC(7d2c5daf) SHA1(6ca39f493eb8b370154ad46ef01976d352c929e1) )
	ROM_LOAD( "stargate_rom_12-a_3002-12.e7", 0x0f000, 0x1000, CRC(a0396670) SHA1(c46872550e0ca031453c6513f8f0448ecc9b5572) )
	ROM_LOAD( "stargate_rom_1-a_3002-1.e4",   0x10000, 0x1000, CRC(88824d18) SHA1(f003a5a9319c4eb8991fa2aae3f10c72d6b8e81a) )
	ROM_LOAD( "stargate_rom_2-a_3002-2.c4",   0x11000, 0x1000, CRC(afc614c5) SHA1(087c6da93318e8dc922d3d22e0a2af7b9759701c) )
	ROM_LOAD( "stargate_rom_3-a_3002-3.a4",   0x12000, 0x1000, CRC(15077a9d) SHA1(7badb4318b208f49d7fa65e915d0aa22a1e37915) )
	ROM_LOAD( "stargate_rom_4-a_3002-4.e5",   0x13000, 0x1000, CRC(a8b4bf0f) SHA1(6b4d47c2899fe9f14f9dab5928499f12078c437d) )
	ROM_LOAD( "stargate_rom_5-a_3002-5.c5",   0x14000, 0x1000, CRC(2d306074) SHA1(54f871983699113e31bb756d4ca885c26c2d66b4) )
	ROM_LOAD( "stargate_rom_6-a_3002-6.a5",   0x15000, 0x1000, CRC(53598dde) SHA1(54b02d944caf95283c9b6f0160e75ea8c4ccc97b) )
	ROM_LOAD( "stargate_rom_7-a_3002-7.e6",   0x16000, 0x1000, CRC(23606060) SHA1(a487ffcd4920d1056b87469735f7e1002f6a2e49) )
	ROM_LOAD( "stargate_rom_8-a_3002-8.c6",   0x17000, 0x1000, CRC(4ec490c7) SHA1(8726ebaf048db9608dfe365bf434ed5ca9452db7) )
	ROM_LOAD( "stargate_rom_9-a_3002-9.a6",   0x18000, 0x1000, CRC(88187b64) SHA1(efacc4a6d4b2af9a236c9d520de6d605c79cc5a8) )

	ROM_REGION( 0x10000, "soundcpu", 0 )
	ROM_LOAD( "video_sound_rom_2_std_744.ic12", 0xf800, 0x0800, CRC(2fcf6c4d) SHA1(9c4334ac3ff15d94001b22fc367af40f9deb7d57) ) // P/N A-5342-09809

	ROM_REGION( 0x0400, "proms", 0 )
	ROM_LOAD( "decoder_rom_4.3g", 0x0000, 0x0200, CRC(e6631c23) SHA1(9988723269367fb44ef83f627186a1c88cf7877e) ) // Universal Horizontal decoder ROM - 7641-5 BPROM - P/N A-5342-09694
	ROM_LOAD( "decoder_rom_5.3c", 0x0200, 0x0200, CRC(f921c5fe) SHA1(9cebb8bb935315101d248140d1b4503993ebdf8a) ) // Universal Vertical decoder ROM - 7641-5 BPROM - P/N A-5342-09695
ROM_END

```
