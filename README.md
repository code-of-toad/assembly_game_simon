# Simon Game in RISC-V Assembly

A memory-mapped LED-matrix version of the classic Simon game written in RISC-V assembly. The program drives a 15x15 LED grid and polls a d-pad to grow and replay a random colour sequence that the player must mimic.

## Tech used

- RISC-V assembly (designed for the course MMIO-enabled simulator used in CSC/EE labs such as RARS/Venus with LED matrix + d-pad devices)
- Memory-mapped I/O for LED control and button polling
- Pseudo-random generation via timer `ecall`
- Stack-based sequence storage to remove fixed pattern limits

## What the project does

- Powers on an LED faceplate, runs a 3-2-1-GO countdown, then enters the Simon loop.
- Builds an ever-growing random sequence of colours (green, blue, yellow, red) stored relative to the stack pointer.
- Plays back the sequence on the LED matrix with per-colour animations.
- Waits for the user to replay it with the d-pad; mismatch triggers a “bruh” face and offers exit/restart, success shows a smile and appends a new random step.

## How to run & play

1) Open `final_game_simon.s` in the course RISC-V simulator that exposes `LED_MATRIX_0_*` and `D_PAD_0_*` MMIO addresses (the same environment provided with the assignment).
2) Assemble and run. The board powers on automatically after a short delay.
3) Watch the countdown, then the LED playback of the sequence.
4) Reproduce the sequence using the d-pad (colour mapping: up = green, down = blue, left = yellow, right = red).
5) On success the pattern lengthens; on failure a red “bruh” face appears. Press left or down to quit, any other direction restarts.

## CS principles demonstrated

- Memory-mapped I/O and direct pixel addressing of an LED matrix
- Procedural decomposition with custom draw helpers (`LED_FILL_ROW/COL`, per-colour ON/OFF routines)
- State-machine style control flow for countdown → playback → input → success/fail handling
- Stack-relative array allocation to increase pattern size dynamically
- Use of timer-driven pseudo-randomness and debounced input polling

## Notable files

- `final_game_simon.s` – complete game with enhanced LED UI, countdown, success/fail faces, and unbounded sequence growth.
- `starter_code/` – original scaffolding and variants used to bootstrap the project.

## Notes

- The game assumes the course-provided peripherals; running it elsewhere requires equivalent MMIO definitions for the LED matrix and d-pad.
