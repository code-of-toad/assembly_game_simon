.data
sequence:      .byte    0, 0, 0, 0
count:         .word    4
delay_ON:      .word    320
delay_OFF:     .word    400
delay_USER:    .word    150

newline:       .string    "\n"

promptInput:   .string    "Your input: "
contPrompt:    .string    "Continue?\n"
success:       .string    "Success!\n"
fail:          .string    "bruh\n"

greenChoose:   .string    "(G)"
blueChoose:    .string    "(B)"
yellowChoose:  .string    "(Y)"
redChoose:     .string    "(R)"

.globl main
.text

main:
    INITIALIZE_CONSTANTS:
    lw s4, delay_USER
    lw s3, delay_ON
    lw s2, delay_OFF

    INITIALIZE_LEDS:
    jal LED_green_OFF
    jal LED_red_OFF
    jal LED_yellow_OFF
    jal LED_blue_OFF
    #jal LED_green_ON
    #jal LED_red_ON
    #jal LED_yellow_ON
    #jal LED_blue_ON
    
    # =================================================================
    
    SEQUENCE_INIT:
    la s10, sequence
    li t5, 0            # i = 0
    lw s11, count       # set up (i < count)
    SEQUENCE_BUILD:
    add s9, s10, t5      # s9 = &s10[i]
    li a0, 4
    jal rand
    sb a0, 0(s9)        # s[i] = rand()
    addi t5, t5, 1      # i++
    ### ===== D-BUG ===== ###
     li a7, 1
     ecall
     li a7, 4
     la a0, newline
     ecall
    ### ===== D-BUG ===== ###
    blt t5, s11, SEQUENCE_BUILD
    SEQUENCE_DONE:
        
    # =================================================================
    
    READ_INIT:
    li t5, 0            # i = 0
    READ_SEQUENCE:
    beq t5, s11, READ_DONE
    add s9, s10, t5     # s9 = &s10[i]
    lb a0, 0(s9)        # a0 = s10[i]
    addi t5, t5, 1      # i++
    
    # ----------------------------------------------------
    # R=3   G=0   B=1   Y=2
    # ----------------------------------------------------
    
    COLOR_CHECK:
    li t0, 0
    li t1, 1
    li t2, 2
    li t3, 3
    beq a0, t0, GREEN_BLINK
    beq a0, t1, BLUE_BLINK
    beq a0, t2, YELLOW_BLINK
    beq a0, t3, RED_BLINK
    GREEN_BLINK:
    jal LED_green_ON      # 0
    mv a0, s3
    jal delay
    jal LED_green_OFF
    mv a0, s2
    jal delay
    j READ_SEQUENCE
    BLUE_BLINK:
    jal LED_blue_ON       # 1
    mv a0, s3
    jal delay
    jal LED_blue_OFF
    mv a0, s2
    jal delay
    j READ_SEQUENCE
    YELLOW_BLINK:
    jal LED_yellow_ON     # 2
    mv a0, s3
    jal delay  
    jal LED_yellow_OFF
    mv a0, s2
    jal delay
    j READ_SEQUENCE
    RED_BLINK:
    jal LED_red_ON        # 3
    mv a0, s3
    jal delay
    jal LED_red_OFF
    mv a0, s2
    jal delay
    j READ_SEQUENCE
    READ_DONE:
    
    
    # ----------------------------------------------------
    
    
    # TODO: Read through the sequence again and check for user input
    # using pollDpad. For each number in the sequence, check the d-pad
    # input and compare it against the sequence. If the input does not
    # match, display some indication of error on the LEDs and exit. 
    # Otherwise, keep checking the rest of the sequence and display 
    # some indication of success once you reach the end.
    
    
    INPUT_INIT:
    li t5, 0
    
    INPUT_CHECK:
    beq t5, s11, SUCCESS
    
    li a7, 4
    la a0, newline
    ecall
    
    add s9, s10, t5
    addi t5, t5, 1
    
    lb s5, 0(s9)    # s3 = element
    # ----------------------------------------------------
    # R=3   G=0   B=1   Y=2
    # ----------------------------------------------------
    li a7, 4
    la a0, promptInput
    ecall
    jal pollDpad
    bne a0, s5, BRUH
    COLOR_CHECK_2:
    li t0, 0
    li t1, 1
    li t2, 2
    li t3, 3
    beq a0, t0, GREEN_USER
    beq a0, t1, BLUE_USER
    beq a0, t2, YELLOW_USER
    beq a0, t3, RED_USER
    GREEN_USER:
    li a7, 4
    la a0, greenChoose
    ecall
    jal LED_green_ON      # 0
    mv a0, s4
    jal delay
    jal LED_green_OFF
    j INPUT_CHECK
    BLUE_USER:
    li a7, 4
    la a0, blueChoose
    ecall
    jal LED_blue_ON       # 1
    mv a0, s4
    jal delay
    jal LED_blue_OFF
    j INPUT_CHECK
    YELLOW_USER:
    li a7, 4
    la a0, yellowChoose
    ecall
    jal LED_yellow_ON     # 2
    mv a0, s4
    jal delay  
    jal LED_yellow_OFF
    j INPUT_CHECK
    RED_USER:
    li a7, 4
    la a0, redChoose
    ecall
    jal LED_red_ON        # 3
    mv a0, s4
    jal delay
    jal LED_red_OFF
    j INPUT_CHECK
    INPUT_DONE:




    SUCCESS:
    # TODO: Insert "success protocol" here.
    li a7, 4
    la a0, newline
    ecall
    la a0, success
    ecall
    j CONTINUE_PROMPT
    
    
    
    BRUH:
    # TODO: Insert "bruh protocol" here.
    li a7, 4
    la a0, newline
    ecall
    la a0, fail
    ecall
    j CONTINUE_PROMPT
    
    
    
    
    CONTINUE_PROMPT:
    li a7, 4
    la a0, contPrompt
    ecall
    
    jal pollDpad
    li t3, 3
    li t2, 2
    li t1, 1
    li t0, 0
    beq a0, t2, exit
    beq a0, t1, exit
    j INITIALIZE_LEDS
 
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
    # li t1, LED_MATRIX_0_WIDTH
    # mul t0, a2, t1
    # add t0, t0, a1
    # li t1, 4
    # mul t0, t0, t1
    # li t1, LED_MATRIX_0_BASE
    # add t0, t1, t0
    # sw a0, (0)t0
    # jr ra
    
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

LED_green_OFF:
    li a0, 0x006600        # Green (0)
    li a1, 0
    li a2, 0
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
LED_red_OFF:
    li a0, 0x660000        # Red (3)
    li a1, 1
    li a2, 0
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
LED_yellow_OFF:
    li a0, 0x666600        # Yellow (2)
    li a1, 0
    li a2, 1
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
LED_blue_OFF:
    li a0, 0x0a6379        # Blue (1)
    li a1, 1
    li a2, 1
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
LED_green_ON:
    li a0, 0x00ff00        # Green (0)
    li a1, 0
    li a2, 0
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
LED_red_ON:
    li a0, 0xff0000        # Red (3)
    li a1, 1
    li a2, 0
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
LED_yellow_ON:
    li a0, 0xffff00         # Yellow (2)
    li a1, 0
    li a2, 1
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
LED_blue_ON:
    li a0, 0x00ccff         # Blue (1)
    li a1, 1
    li a2, 1
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra