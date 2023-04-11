# =========================================================================
# ====================   CODE DOCUMENTATION FOR TA'S   ====================
# 
#                       +----------------------------+
#                       | Name: Donghee (Danny) Han  |
#                       | Student No.: 999825596     |
#                       | Lecture Section: LEC0101   |
#                       +----------------------------+
#
# My two choices of enhancement are the following:
#         1. Increase the pattern size;
#         2. Improve the LED interface.
# 
# To increase the pattern size, I've used the stack pointer as the base
#   address of the array that will contain the sequence. The address of SP
#   NEVER changes, since it's used as a reference point in iterations.
#   The implementation of this sequence can be found between lines 151-163.
# 
# To improve the LED interface, I've defined two custom helpers and a
#   number of custom functions that use the above two custom helpers in
#   order to interact with multiple LEDs at once.
#
# Custom Helpers:
# ===============
#         [line  407]  LED_FILL_ROW
#         [line  424]  LED_FILL_COL
#
# Custom Functions:
# =================
#         [line  444]  LED_power_OFF
#         [line  454]  LED_power_ON
#         [line  464]  LED_inputFalse_OFF
#         [line  474]  LED_inputFalse_ON
#         [line  484]  LED_inputTrue_OFF
#         [line  494]  LED_inputTrue_ON
#         [line  504]  LED_green_OFF
#         [line  534]  LED_green_ON
#         [line  564]  LED_blue_OFF
#         [line  594]  LED_blue_ON
#         [line  624]  LED_yellow_OFF
#         [line  654]  LED_yellow_ON
#         [line  684]  LED_red_OFF
#         [line  714]  LED_red_ON
#         [line  744]  LED_blackSq
#         [line  774]  LED_three
#         [line  799]  LED_two
#         [line  829]  LED_one
#         [line  848]  LED_go
#         [line  867]  LED_smile
#         [line  895]  LED_bruh
#         [line  921]  INITIALIZE_BACKGROUND
#         [line 1001]  INITIALIZE_BUILD
#
# =========================================================================

.data

delay_250:     .word    250
delay_300:     .word    300
delay_350:     .word    350
delay_400:     .word    400
delay_500:     .word    500
delay_625:     .word    625
delay_750:     .word    750
delay_1000:    .word    1000

DEBUG:         .string    "DEBUGGGGGGGGGG"
newline:       .string    "\n"

greenON:       .word    0x00ff00
greenOFF:      .word    0x006600
blueON:        .word    0x00ccff
blueOFF:       .word    0x0a6379
yellowON:      .word    0xffff00
yellowOFF:     .word    0x666600
redON:         .word    0xff0000
redOFF:        .word    0x660000
black:         .word    0x000000
light_grey:    .word    0xdddddd
dark_grey:     .word    0x7b7b7b
purple:        .word    0x301934


.globl main
.text

main:
    
    
    # -------------------------------------------------------------
    # Reset all LEDs to black
    jal INITIALIZE_BACKGROUND
    # Initialize all LED components to "low power" state
    jal INITIALIZE_BUILD
    #
    jal LED_green_OFF
    jal LED_blue_OFF
    jal LED_yellow_OFF
    jal LED_red_OFF
    #
    jal LED_inputFalse_OFF
    jal LED_inputTrue_OFF
    jal LED_power_OFF
    lw a0, delay_1000
    jal delay
    
    # "Power" the device
    jal LED_power_ON
    # -------------------------------------------------------------
    
    
    # -------------------------------------------------------------
    COUNTDOWN:
    lw a0, delay_1000
    jal delay
    
    # Start countdown: 3...2...1...GO!
    jal LED_blackSq
    jal LED_three
    lw a0, delay_750
    jal delay
    jal LED_blackSq
    lw a0, delay_250
    jal delay
    #
    jal LED_two
    lw a0, delay_750
    jal delay
    jal LED_blackSq
    lw a0, delay_250
    jal delay
    #
    jal LED_one
    lw a0, delay_750
    jal delay
    jal LED_blackSq
    lw a0, delay_250
    jal delay
    #
    jal LED_go
    lw a0, delay_1000
    jal delay
    jal LED_inputFalse_ON
    jal LED_blackSq
    lw a0, delay_500
    jal delay
    # -------------------------------------------------------------


    # -------------------------------------------------------------
    # sp = &arr[0]
    li a3, 0        # a3 = i
    STORE_NUMBERS:
    jal LED_inputFalse_ON
    jal LED_inputTrue_OFF
    # Generate randome number
    add s11, a3, sp  # s11 = arr[i]
    #
    li a0, 4
    jal rand
    #
    sb a0, 0(s11)    # s9 = arr[i]  <--  (RANDOM NUMBER)
    addi a3, a3, 1   # a3++ = i++
    # -------------------------------------------------------------
    
    
    # -------------------------------------------------------------
    ROUND_READ:
    li a4, 0        # a4 = j
    for_loop_READ:
    beq a3, a4, ROUND_INPUT
    add s10, sp, a4      # s10 = &arr[j]
    lb s9, 0(s10)        # s9 = arr[j] element
    addi a4, a4 ,1       # a4++ = j++
    COLOR_CHECK:
    li t0, 0
    li t1, 1
    li t2, 2
    li t3, 3
    beq s9, t0, GREEN_BLINK
    beq s9, t1, BLUE_BLINK
    beq s9, t2, YELLOW_BLINK
    beq s9, t3, RED_BLINK
    GREEN_BLINK:
    jal LED_green_ON      # 0
    lw a0, delay_500
    jal delay
    jal LED_green_OFF
    lw a0, delay_350
    jal delay
    j for_loop_READ
    BLUE_BLINK:
    jal LED_blue_ON       # 1
    lw a0, delay_500
    jal delay
    jal LED_blue_OFF
    lw a0, delay_350
    jal delay
    j for_loop_READ
    YELLOW_BLINK:
    jal LED_yellow_ON     # 2
    lw a0, delay_500
    jal delay  
    jal LED_yellow_OFF
    lw a0, delay_350
    jal delay
    j for_loop_READ
    RED_BLINK:
    jal LED_red_ON        # 3
    lw a0, delay_500
    jal delay
    jal LED_red_OFF
    lw a0, delay_350
    jal delay
    j for_loop_READ
    # -------------------------------------------------------------
    
    
    # -------------------------------------------------------------
    ROUND_INPUT:
    jal LED_inputFalse_OFF
    jal LED_inputTrue_ON
                # a3 = i
    li a4, 0    # a4 = j
    LOOP:             
    beq a4, a3, SUCCESS
    add s10, sp, a4      # s10 = &arr[j]
    lb s9, 0(s10)        # s9 = arr[j] element
    addi a4, a4, 1
    # ----------------------
    # G=0   B=1   Y=2   R=3
    # ----------------------
    jal pollDpad
    bne a0, s9, BRUH
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
    jal LED_green_ON      # 0
    jal LED_inputFalse_ON
    jal LED_inputTrue_OFF
    lw a0, delay_250
    jal delay
    jal LED_green_OFF
    jal LED_inputFalse_OFF
    jal LED_inputTrue_ON
    j LOOP
    BLUE_USER:
    jal LED_blue_ON       # 1
    jal LED_inputFalse_ON
    jal LED_inputTrue_OFF
    lw a0, delay_250
    jal delay
    jal LED_blue_OFF
    jal LED_inputFalse_OFF
    jal LED_inputTrue_ON
    j LOOP
    YELLOW_USER:
    jal LED_yellow_ON     # 2
    jal LED_inputFalse_ON
    jal LED_inputTrue_OFF
    lw a0, delay_250
    jal delay  
    jal LED_yellow_OFF
    jal LED_inputFalse_OFF
    jal LED_inputTrue_ON
    j LOOP
    RED_USER:
    jal LED_red_ON        # 3
    jal LED_inputFalse_ON
    jal LED_inputTrue_OFF
    lw a0, delay_250
    jal delay
    jal LED_red_OFF
    jal LED_inputFalse_OFF
    jal LED_inputTrue_ON
    j LOOP
    # -------------------------------------------------------------
    
    
    # -------------------------------------------------------------
    SUCCESS:
    jal LED_smile
    jal LED_inputFalse_ON
    jal LED_inputTrue_OFF
    lw a0, delay_1000
    jal delay
    jal LED_red_OFF
    jal LED_blackSq
    lw a0, delay_500
    jal delay
    j STORE_NUMBERS
    # -------------------------------------------------------------
    
    
    # -------------------------------------------------------------
    BRUH:
    jal LED_bruh
    jal LED_inputFalse_OFF
    jal LED_inputTrue_ON
    jal pollDpad
    li t3, 3
    li t2, 2
    li t1, 1
    li t0, 0
    beq a0, t2, exit
    beq a0, t1, exit
    jal LED_inputTrue_OFF
    jal LED_blackSq
    j COUNTDOWN
    # -------------------------------------------------------------


exit:
    jal LED_blackSq
    lw a0, delay_500
    jal delay

    jal LED_inputTrue_OFF
    lw a0, delay_500
    jal delay
    
    jal LED_power_OFF
    lw a0, delay_500
    jal delay
    
    li a7, 10
    ecall
    
    
# -------------------------- HELPER FUNCTIONS --------------------------
     
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


# -------------------------- CUSTOM FUNCTIONS --------------------------

LED_FILL_ROW:
    mv s4, a5    # PARAM <-- ARG    # s4 = y
    mv s5, a6    # PARAM <-- ARG    # s5 = x_A
    mv s6, a7    # PARAM <-- ARG    # s6 = x_B
    mv s0, ra    # save return address
    PERFORM:
    mv a1, s5
    mv a2, s4
    jal setLED
    CONDITION_CHECK:
    addi s5, s5, 1
    bgt s5, s6, noice
    j PERFORM
    noice:
    mv ra, s0    # load return address
    jr ra

LED_FILL_COL:
    mv s4, a5    # PARAM <-- ARG    # s4 = x
    mv s5, a6    # PARAM <-- ARG    # s5 = y_A
    mv s6, a7    # PARAM <-- ARG    # s6 = y_B
    mv s0, ra    # save return address
    PERFORM2:
    mv a1, s4
    mv a2, s5
    jal setLED
    CONDITION_CHECK2:
    addi s5, s5, 1
    bgt s5, s6, noice
    j PERFORM2
    noice2:
    mv ra, s0    # load return address
    jr ra


# -------------------------- CUSTOM HELPERS --------------------------

LED_power_OFF:
    mv s1, ra    # save return address
    li a5, 14
    li a6, 1
    li a7, 2
    lw a0, dark_grey
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    
LED_power_ON:
    mv s1, ra    # save return address
    li a5, 14
    li a6, 1
    li a7, 2
    lw a0, light_grey
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    
LED_inputFalse_OFF:
    mv s1, ra    # save return address
    li a5, 13
    li a6, 13
    li a7, 14
    lw a0, redOFF
    jal LED_FILL_COL
    mv ra, s1    # load return address
    jr ra
    
LED_inputFalse_ON:
    mv s1, ra    # save return address
    li a5, 13
    li a6, 13
    li a7, 14
    lw a0, redON
    jal LED_FILL_COL
    mv ra, s1    # load return address
    jr ra
    
LED_inputTrue_OFF:
    mv s1, ra    # save return address
    li a5, 12
    li a6, 13
    li a7, 14
    lw a0, greenOFF
    jal LED_FILL_COL
    mv ra, s1    # load return address
    jr ra
    
LED_inputTrue_ON:
    mv s1, ra    # save return address
    li a5, 12
    li a6, 13
    li a7, 14
    lw a0, greenON
    jal LED_FILL_COL
    mv ra, s1    # load return address
    jr ra

LED_green_OFF:
    mv s1, ra    # save return address
    li a5, 2
    li a6, 4
    li a7, 6
    lw a0, greenOFF
    jal LED_FILL_ROW
    li a5, 3
    li a6, 3
    li a7, 6
    lw a0, greenOFF
    jal LED_FILL_ROW
    li a5, 4
    li a6, 2
    li a7, 6
    lw a0, greenOFF
    jal LED_FILL_ROW
    li a5, 5
    li a6, 2
    li a7, 4
    lw a0, greenOFF
    jal LED_FILL_ROW
    li a5, 6
    li a6, 2
    li a7, 4
    lw a0, greenOFF
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    
LED_green_ON:
    mv s1, ra    # save return address
    li a5, 2
    li a6, 4
    li a7, 6
    lw a0, greenON
    jal LED_FILL_ROW
    li a5, 3
    li a6, 3
    li a7, 6
    lw a0, greenON
    jal LED_FILL_ROW
    li a5, 4
    li a6, 2
    li a7, 6
    lw a0, greenON
    jal LED_FILL_ROW
    li a5, 5
    li a6, 2
    li a7, 4
    lw a0, greenON
    jal LED_FILL_ROW
    li a5, 6
    li a6, 2
    li a7, 4
    lw a0, greenON
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra

LED_blue_OFF:
    mv s1, ra    # save return address
    li a5, 12
    li a6, 8
    li a7, 10
    lw a0, blueOFF
    jal LED_FILL_ROW
    li a5, 11
    li a6, 8
    li a7, 11
    lw a0, blueOFF
    jal LED_FILL_ROW
    li a5, 10
    li a6, 8
    li a7, 12
    lw a0, blueOFF
    jal LED_FILL_ROW
    li a5, 9
    li a6, 10
    li a7, 12
    lw a0, blueOFF
    jal LED_FILL_ROW
    li a5, 8
    li a6, 10
    li a7, 12
    lw a0, blueOFF
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    
LED_blue_ON:
    mv s1, ra    # save return address
    li a5, 12
    li a6, 8
    li a7, 10
    lw a0, blueON
    jal LED_FILL_ROW
    li a5, 11
    li a6, 8
    li a7, 11
    lw a0, blueON
    jal LED_FILL_ROW
    li a5, 10
    li a6, 8
    li a7, 12
    lw a0, blueON
    jal LED_FILL_ROW
    li a5, 9
    li a6, 10
    li a7, 12
    lw a0, blueON
    jal LED_FILL_ROW
    li a5, 8
    li a6, 10
    li a7, 12
    lw a0, blueON
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra

LED_yellow_OFF:
    mv s1, ra    # save return address
    li a5, 12
    li a6, 4
    li a7, 6
    lw a0, yellowOFF
    jal LED_FILL_ROW
    li a5, 11
    li a6, 3
    li a7, 6
    lw a0, yellowOFF
    jal LED_FILL_ROW
    li a5, 10
    li a6, 2
    li a7, 6
    lw a0, yellowOFF
    jal LED_FILL_ROW
    li a5, 9
    li a6, 2
    li a7, 4
    lw a0, yellowOFF
    jal LED_FILL_ROW
    li a5, 8
    li a6, 2
    li a7, 4
    lw a0, yellowOFF
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    
LED_yellow_ON:
    mv s1, ra    # save return address
    li a5, 12
    li a6, 4
    li a7, 6
    lw a0, yellowON
    jal LED_FILL_ROW
    li a5, 11
    li a6, 3
    li a7, 6
    lw a0, yellowON
    jal LED_FILL_ROW
    li a5, 10
    li a6, 2
    li a7, 6
    lw a0, yellowON
    jal LED_FILL_ROW
    li a5, 9
    li a6, 2
    li a7, 4
    lw a0, yellowON
    jal LED_FILL_ROW
    li a5, 8
    li a6, 2
    li a7, 4
    lw a0, yellowON
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra

LED_red_OFF:
    mv s1, ra    # save return address
    li a5, 2
    li a6, 8
    li a7, 10
    lw a0, redOFF
    jal LED_FILL_ROW
    li a5, 3
    li a6, 8
    li a7, 11
    lw a0, redOFF
    jal LED_FILL_ROW
    li a5, 4
    li a6, 8
    li a7, 12
    lw a0, redOFF
    jal LED_FILL_ROW
    li a5, 5
    li a6, 10
    li a7, 12
    lw a0, redOFF
    jal LED_FILL_ROW
    li a5, 6
    li a6, 10
    li a7, 12
    lw a0, redOFF
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    
LED_red_ON:
    mv s1, ra    # save return address
    li a5, 2
    li a6, 8
    li a7, 10
    lw a0, redON
    jal LED_FILL_ROW
    li a5, 3
    li a6, 8
    li a7, 11
    lw a0, redON
    jal LED_FILL_ROW
    li a5, 4
    li a6, 8
    li a7, 12
    lw a0, redON
    jal LED_FILL_ROW
    li a5, 5
    li a6, 10
    li a7, 12
    lw a0, redON
    jal LED_FILL_ROW
    li a5, 6
    li a6, 10
    li a7, 12
    lw a0, redON
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra

LED_blackSq:
    mv s1, ra    # save return address
    li a5, 5
    li a6, 5
    li a7, 9
    lw a0, black
    jal LED_FILL_ROW
    li a5, 6
    li a6, 5
    li a7, 9
    lw a0, black
    jal LED_FILL_ROW
    li a5, 7
    li a6, 5
    li a7, 9
    lw a0, black
    jal LED_FILL_ROW
    li a5, 8
    li a6, 5
    li a7, 9
    lw a0, black
    jal LED_FILL_ROW
    li a5, 9
    li a6, 5
    li a7, 9
    lw a0, black
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    
LED_three:
    mv s1, ra    # save return address
    li a5, 8
    li a6, 5
    li a7, 9
    lw a0, greenON
    jal LED_FILL_COL
    li a5, 5
    li a6, 6
    li a7, 7
    lw a0, greenON
    jal LED_FILL_ROW
    li a5, 7
    li a6, 6
    li a7, 7
    lw a0, greenON
    jal LED_FILL_ROW
    li a5, 9
    li a6, 6
    li a7, 7
    lw a0, greenON
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra

LED_two:
    mv s1, ra    # save return address
    li a5, 5
    li a6, 6
    li a7, 8
    lw a0, greenON
    jal LED_FILL_ROW
    li a5, 8
    li a6, 6
    li a7, 7
    lw a0, greenON
    jal LED_FILL_COL
    li a5, 7
    li a6, 6
    li a7, 7
    lw a0, greenON
    jal LED_FILL_ROW
    li a5, 6
    li a6, 8
    li a7, 9
    lw a0, greenON
    jal LED_FILL_COL
    li a5, 9
    li a6, 7
    li a7, 8
    lw a0, greenON
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    
LED_one:
    mv s1, ra    # save return address
    li a5, 7
    li a6, 5
    li a7, 8
    lw a0, greenON
    jal LED_FILL_COL
    li a5, 9
    li a6, 6
    li a7, 8
    lw a0, greenON
    jal LED_FILL_ROW
    li a1, 6
    li a2, 6
    lw a0, greenON
    jal setLED
    mv ra, s1    # load return address
    jr ra
    
LED_go:
    mv s1, ra    # save return address
    li a5, 6
    li a6, 5
    li a7, 9
    lw a0, greenON
    jal LED_FILL_COL
    li a5, 7
    li a6, 6
    li a7, 8
    lw a0, greenON
    jal LED_FILL_COL 
    li a1, 8
    li a2, 7
    lw a0, greenON
    jal setLED
    mv ra, s1    # load return address
    jr ra

LED_smile:
    mv s1, ra    # save return address
    li a5, 6
    li a6, 5
    li a7, 6
    lw a0, greenON
    jal LED_FILL_COL
    li a5, 8
    li a6, 5
    li a7, 6
    lw a0, greenON
    jal LED_FILL_COL
    li a5, 9
    li a6, 6
    li a7, 8
    lw a0, greenON
    jal LED_FILL_ROW
    li a1, 9
    li a2, 8
    lw a0, greenON
    jal setLED
    li a1, 5
    li a2, 8
    lw a0, greenON
    jal setLED
    mv ra, s1    # load return address
    jr ra

LED_bruh:
    mv s1, ra    # save return address
    li a1, 6
    li a2, 6
    lw a0, redON
    jal setLED
    li a1, 8
    li a2, 6
    lw a0, redON
    jal setLED
    li a5, 8
    li a6, 6
    li a7, 8
    lw a0, redON
    jal LED_FILL_ROW
    li a1, 9
    li a2, 9
    lw a0, redON
    jal setLED
    li a1, 5
    li a2, 9
    lw a0, redON
    jal setLED
    mv ra, s1    # load return address
    jr ra
    
INITIALIZE_BACKGROUND:
    mv s1, ra    # save return address
    li a5, 0
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 1
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 2
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 3
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 4
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 5
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 6
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 7
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 8
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 9
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 10
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 11
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 12
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 13
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    li a5, 14
    li a6, 0
    li a7, 14
    lw a0, black
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    
INITIALIZE_BUILD:
    mv s1, ra    # save return address
    li a5, 7
    li a6, 2
    li a7, 4    
    lw a0, purple
    jal LED_FILL_COL
    li a5, 7
    li a6, 10
    li a7, 12    
    lw a0, purple
    jal LED_FILL_COL
    li a5, 0
    li a6, 0
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 1
    li a6, 0
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 2
    li a6, 0
    li a7, 3    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 2
    li a6, 11
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 3
    li a6, 0
    li a7, 2    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 3
    li a6, 12
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 4
    li a6, 0
    li a7, 1    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 4
    li a6, 13
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 5
    li a6, 0
    li a7, 1    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 5
    li a6, 13
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 6
    li a6, 0
    li a7, 1    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 6
    li a6, 13
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 7
    li a6, 0
    li a7, 4    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 7
    li a6, 10
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 8
    li a6, 0
    li a7, 1    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 8
    li a6, 13
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 9
    li a6, 0
    li a7, 1    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 9
    li a6, 13
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 10
    li a6, 0
    li a7, 1    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 10
    li a6, 13
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 11
    li a6, 0
    li a7, 2    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 11
    li a6, 12
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 12
    li a6, 0
    li a7, 3    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 12
    li a6, 11
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 13
    li a6, 0
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    li a5, 14
    li a6, 0
    li a7, 14    
    lw a0, purple
    jal LED_FILL_ROW
    mv ra, s1    # load return address
    jr ra
    