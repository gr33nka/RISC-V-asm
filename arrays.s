.globl __start

.data
	array: .word 1, 2, 3, 4, 5

.text
	__start:
	la t0, array
	li t1, 0	# sum
	li t2, 0
loop:
	lw t3, 0(t0)
	add t1, t1, t3

	addi t2, t2, 1
	li t4, 5
	beq t4, t2, endloop
	addi t0, t0, 4
	j loop

endloop:
	mv a0, t1
stop:
	j stop