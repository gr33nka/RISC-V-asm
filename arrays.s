.globl __start

.data
	array: 
		.word 5, 4, 3, 2, 1
	array2:
		.word 123, 43, 75, 0, -2

.text
	__start:
	la t0, array2
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