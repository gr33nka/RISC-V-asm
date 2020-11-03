.text
start:
      li a0, -5
      li a1, -2
      call multiply
stop:
      j stop



###   a0 = a0 * a1
multiply:
      li t6, 0

      li t0, -1
      li t1, 31
whilemul:
      beq t0, t1, endwhilemul
      addi t0, t0, 1

      sra t2, a1, t0
      andi t2, t2, 1

      beq t2, zero, whilemul
      sll t3, a0, t0
      add t6, t6, t3

      j whilemul

endwhilemul:
      mv a0, t6
      ret



###   a0 = a0 * a1
simplemultiply:
      li t0, 0

whilesimplemul:
      beq a0, zero, endwhilesimplemul
      addi a0, a0, -1

      add t0, t0, a1

      j whilesimplemul

endwhilesimplemul:
      mv  a0, t0 # a0 = t0
      ret


###   только положительные a0 = a0 / a1
simpledevider:
      li t0, 0

whilesimplediv:
      sub a0, a0, a1 # a0 = a0 - a1
      bge zero, a0, endwhilediv # if zero >= a0 then endwhilediv
      addi t0, t0, 1 # t0 = t0 + 1
      j whilesimplediv

endwhilediv:
      mv  a0, t0 # a0 = t0
      ret    



###   улучшенный делитель a0 = a0 / a1
devider:
      li t2, 0    # Ai
      li t4, 0    # answer

      li t0, 31   # i = 32
whilediv:
      blt t0, zero whileenddiv      # if i < 0 then 

      slli t4, t4, 1    # ans = ans << 1
      srl t1, a0, t0    # t = A >> i
      andi t1, t1, 0x01 # t = t & 0x01
      slli t2, t2, 1    # opA = opA << 1
      or t2, t2, t1     # opA = opA | t
      sub t3, t2, a1    # tmp = opA - B
      
      blt t3, zero, itszerobit      # if tmp < 0 then
      ori t4, t4, 0x01  # ans = ans | 0x01
      mv t2, t3         # opA = tmp

itszerobit:
      addi t0, t0, -1   # i--
      j whilediv

whileenddiv:
      mv a0, t4
      ret



###  a0 = a0 ^ 2
quad:
      mv  a1, a0 # a1 = a0

      addi sp, sp, -4
      sw ra, 0(sp)
      call multiply
      lw ra, 0(sp)
      addi sp, sp, 4

      ret



###   a0!
factorial:
      addi sp, sp, -8
      sw s0, 4(sp)
      sw s1, 0(sp)

      li s1, 1
      mv s0, a0

whilefact:
      beq s0, zero, endwhilefact # if t1 == zero then endwhilefact
      addi s0, s0, -1

      mv a0, s1
      mv a1, s0

      addi sp, sp, -4
      sw ra, 0(sp)
      call multiply
      lw ra, 0(sp)
      addi sp, sp, 4

      mv s1, a0
      j whilefact

endwhilefact:
      mv a0, s1

      lw s0, 4(sp)
      lw s1, 0(sp)
      addi sp, sp, 8
      ret



###   a0 = a0 * 3.14
perimeter:
      li t0, 0xC9
      slli a1, t0, 1
      slli a0, a0, 6

      addi sp, sp, -4
      sw ra, 0(sp)
      call multiply
      lw ra, 0(sp)
      addi sp, sp, 4

      srli a0, a0, 12
      ret


###   a0 = a0 ^ (1/2), accuracy bits (point number) a1
sqrt:
      addi sp, sp, -12
      sw s0, 8(sp)
      sw s1, 4(sp)
      sw s2, 0(sp)

      mv s1, a0         # init x
      slli s0, a0, 8    # number

      mv a0, s0         # n/x
      mv a1, s1
      addi sp, sp, -4
      sw ra, 0(sp)
      call devider
      lw ra, 0(sp)
      addi sp, sp, 4

      slli s1, s1, 8
      add s1, s1, a0
      srli s1, s1, 5
      
      li s2, 7
forsqrt:
      addi s2, s2, -1
      beq s1, zero, errorsqrt      

      mv a0, s0      # n/x
      mv a1, s1
      addi sp, sp, -4
      sw ra, 0(sp)
      call devider
      lw ra, 0(sp)
      addi sp, sp, 4

      add s1, s1, a0
      srli s1, s1, 1

      beq s2, zero, endforsqrt
      j forsqrt

errorsqrt:
      li a1, 1
      j bedendsqrt

endforsqrt:
      li a1, 0

bedendsqrt:
      lw s0, 8(sp)
      lw s1, 4(sp)
      lw s2, 0(sp)
      addi sp, sp, 12
      ret