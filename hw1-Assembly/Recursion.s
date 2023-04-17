.globl __start

.rodata
    msg0: .string "This is HW1-1: T(n) = 4T(n/2) + 2n + 7, T(1) = 5\n"
    msg1: .string "Enter a number: "
    msg2: .string "The result is: "

.text


__start:
  # Prints msg0
    addi a0, x0, 4
    la a1, msg0
    ecall

  # Prints msg1
    addi a0, x0, 4
    la a1, msg1
    ecall

  # Reads an int
    addi a0, x0, 5
    ecall

################################################################################ 
  # Write your main function here. 
  # Input n is in a0. You should store the result T(n) into t0
  # HW1-1 T(n) = 4T(n/2) + 2n + 7, T(1) = 5, round down the result of division
  # ex. addi t0, a0, 1
    jal x1, fact
    jal x1, result
fact:
    addi sp, sp, -8
    sw x1, 4(sp)
    sw a0, 0(sp)
    addi x5, a0, -1 # n - 1 store in x5
    bne x5, x0, L1 # x5 != 0, jump to L1
    
    addi t0, x0, 5 # T(1) = 5
    addi sp, sp, 8
    jalr x0, 0(x1)
L1:
    srli a0, a0, 1 # n = n/2
    jal x1, fact # call fact
    addi t2, x0, 4 # t2 = 4
    mul t0, t0, t2 # 4T(n/2)
    addi x6, t0, 0 # 4T(n/2) store in x6
    lw a0, 0(sp)
    lw x1, 4(sp)
    addi sp, sp, 8
    slli x7, a0, 1 # 2n store in x7
    add t0, t0, x7 # 4T(n/2) + 2n
    addi t0, t0, 7 # 4T(n/2) + 2n + 7
    jalr x0, 0(x1)
    
################################################################################

result:
  # Prints msg2
    addi a0, x0, 4
    la a1, msg2
    ecall

  # Prints the result in t0
    addi a0, x0, 1
    add a1, x0, t0
    ecall
    
  # Ends the program with status code 0
    addi a0, x0, 10
    ecall