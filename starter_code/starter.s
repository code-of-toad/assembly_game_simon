.data
sequence:  .byte 77,77,77,77
count:     .word 4

newline:   .string "\n"

.globl main
.text

main:
    
    _green_OFF:
    li a0, 0x006600       # Green (0)
    li a1, 0
    li a2, 0
    jal setLED
    _red_OFF:
    li a0, 0x660000    # Red (3)
    li a1, 1
    li a2, 0
    jal setLED
    _yellow_OFF:
    li a0, 0x666600    # Yellow (2)
    li a1, 0
    li a2, 1
    jal setLED
    _blue_OFF:
    li a0, 0x0a6379       # Blue (1)
    li a1, 1
    li a2, 1
    jal setLED

    # =================================================================
    
    _green_ON:
    li a0, 0x00ff00       # Green (0)
    li a1, 0
    li a2, 0
    jal setLED
    _red_ON:
    li a0, 0xff0000    # Red (3)
    li a1, 1
    li a2, 0
    jal setLED
    _yellow_ON:
    li a0, 0xffff00    # Yellow (2)
    li a1, 0
    li a2, 1
    jal setLED
    _blue_ON:
    li a0, 0x00ccff       # Blue (1)
    li a1, 1
    li a2, 1
    jal setLED
    
    # =================================================================
    
    SEQUENCE_INIT:
    la s1, sequence
    li t5, 0            # i = 0
    lw s11, count       # set up (i < count)
    
    SEQUENCE_BUILD:
    add s0, s1, t5      # s0 = &s1[i]
    li a0, 4
    jal rand
    sb a0, 0(s0)        # s[i] = rand()
    addi t5, t5, 1      # i++
    # ======= D-BUG ======= #
     li a7, 1
     ecall
     li a7, 4
     la a0, newline
     ecall
    # ======= D-BUG ======= #
    blt t5, s11, SEQUENCE_BUILD
    
    SEQUENCE_DONE:
        
    # =================================================================
    
   
    # TODO: Now read the sequence and replay it on the LEDs. You will
    # need to use the delay function to ensure that the LEDs light up 
    # slowly. In general, for each number in the sequence you should:
    # 1. Figure out the corresponding LED location and colour
    # 2. Light up the appropriate LED (with the colour)
    # 2. Wait for a short delay (e.g. 500 ms)
    # 3. Turn off the LED (i.e. set it to black)
    # 4. Wait for a short delay (e.g. 1000 ms) before repeating
    
    READ_INIT:
    li t5, 0            # i = 0
    
    READ_SEQUENCE:
    add t0, s1, t5      # t0 = &s1[i]
    
    
    # TODO: Read through the sequence again and check for user input
    # using pollDpad. For each number in the sequence, check the d-pad
    # input and compare it against the sequence. If the input does not
    # match, display some indication of error on the LEDs and exit. 
    # Otherwise, keep checking the rest of the sequence and display 
    # some indication of success once you reach the end.


    # TODO: Ask if the user wishes to play again and either loop back to
    # start a new round or terminate, based on their input.
 
exit:
    li a7, 10
    ecall
    
    
# --- HELPER FUNCTIONS ---
# Feel free to use (or modify) them however you see fit
     
# Takes in the number of milliseconds to wait (in a0) before returning
delay:
    mv t0, a0
    li a7, 30
    ecall
    mv t1, a0
delayLoop:
    ecall
    sub t2, a0, t1
    bgez t2, delayIfEnd
    addi t2, t2, -1
delayIfEnd:
    bltu t2, t0, delayLoop
    jr ra

# Takes in a number in a0, and returns a (sort of) random number from 0 to
# this number (exclusive)
rand:
    mv t0, a0
    li a7, 30
    ecall
    remu a0, a0, t0
    jr ra
    
    
# Takes in an RGB color in a0, an x-coordinate in a1, and a y-coordinate
# in a2. Then it sets the led at (x, y) to the given color.
setLED:
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
    
# Polls the d-pad input until a button is pressed, then returns a number
# representing the button that was pressed in a0.
# The possible return values are:
# 0: UP
# 1: DOWN
# 2: LEFT
# 3: RIGHT
pollDpad:
    mv a0, zero
    li t1, 4
pollLoop:
    bge a0, t1, pollLoopEnd
    li t2, D_PAD_0_BASE
    slli t3, a0, 2
    add t2, t2, t3
    lw t3, (0)t2
    bnez t3, pollRelease
    addi a0, a0, 1
    j pollLoop
pollLoopEnd:
    j pollDpad
pollRelease:
    lw t3, (0)t2
    bnez t3, pollRelease
pollExit:
    jr ra
