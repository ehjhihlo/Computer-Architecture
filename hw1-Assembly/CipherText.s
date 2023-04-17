.globl __start

.rodata
    msg0: .string "This is HW1-2: \n"
    msg1: .string "Plaintext:  "
    msg2: .string "Ciphertext: "
.text

################################################################################
  # print_char function
  # Usage: 
  #     1. Store the beginning address in x20
  #     2. Use "j print_char"
  #     The function will print the string stored from x20 
  #     When finish, the whole program with return value 0

print_char:
    addi a0, x0, 4
    la a1, msg2
    ecall
    
    add a1,x0,x20
    ecall

  # Ends the program with status code 0
    addi a0,x0,10
    ecall
    
################################################################################

__start:
  # Prints msg
    addi a0, x0, 4
    la a1, msg0
    ecall

    la a1, msg1
    ecall
    
    addi a0,x0,8
    li a1, 0x10130
    addi a2,x0,2047 # a1 = 65840
    ecall
    
  # Load address of the input string into a0
    add a0,x0,a1 # a0 = 65840

################################################################################ 
  # Write your main function here. 
  # a0 stores the begining Plaintext
  # Do store 66048(0x10200) into x20 
  # ex. j print_char
  
################################################################################
    jal x1, init
init:
    addi sp, sp, -8
    sw x1, 4(sp)
    sw t1, 0(sp)
    li t6, 0x10200 # output address
    li a3, 0x10200 # output address
    addi t1, x0, 0
    addi t2, x0, 48 # '0' character
    addi t3, x0, 32 # space character
    addi t4, x0, 120 # 'x' character
    addi t5, x0, -23 # x,y,z -> a,b,c
    jal x1, func
func:
    add t6, t1, a3 # move pointer
    add t0, t1, a0 # move pointer
    lbu a1, 0(t0) # read char
    addi a2, a1, 0
    beq a2, x0, store_byte # if char = 0, jump to store_byte

compare:
    beq a2, t3, space # check space
    blt a2, t4, not_xyz # char != x,y,z jump to not_xyz
    add a2, a2, t5 # x,y,z map to a,b,c (ASCII value - 23)
    beq x0, x0, exit # jump to exit
    
space:
    addi a2, t2, 0 
    addi t2, t2, 1 # count += 1
    beq x0, x0, exit # jump to exit

not_xyz:
    addi a2, a2, 3 # ASCII value + 3
    beq x0, x0, exit # jump to exit
    
exit:
    sb a2, 0(t6) # store ciphertext result into t6
    addi t1, t1, 1 # Increment pointer to next byte in string
    jal func # Jump back to func loop

store_byte:         
    lw t1, 0(sp)
    lw x1, 4(sp)
    addi sp, sp, 8
    addi sp, sp, -8
    sw x1, 4(sp)
    sw t1, 0(sp)
    addi t1, x0, 0
    add x20, t1, a3 # store the result into x20
    j print_char