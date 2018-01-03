# Karan Bhargava
# CS 147, 009679059
# Professor Gomez
# Homework # 5 -> MIPS

# Assuming $a0 holds the base address of the array
# Assuming $a1 holds int n

.data
myArr: .word 9, 8, 6, 5, 1, 2, 3, 4
myArrSize: .word 8

.text

main:
	la $a0, myArr #load the address of myArr in a0
	lw $a1, myArrSize #load the size of myArr in a1
	jal sort # call sort

	li $v0, 1 # set up the printing
	move $a0, $s2 # move result into a0
	syscall # print the result

	b exit # exit gracefully

sort:
	addi $s0, $zero, 0 #j = 0
	addi $s1, $zero, 0 #iMin = 0
	addi $s2, $zero, 0 #swapCount = 0
	addi $s3, $a0, 0 #@myArr[]
	addi $s4, $a1, 0 #n (size of myArr[])
	subi $t0, $a1, 1 #n - 1

	outer_loop:
	bge $s0, $t0, swap_count_return # if j >= (n-1), exit loop and return swapCount
	add $s1, $s0, $zero # iMin = j
	addi $s5, $s0, 1 #i = j + 1

	inner_loop:
	blt $s5, $s4, inner_loop_if_condition #if i < n, go to if a[i] < a[iMin]
	blt $s0, $s1, outer_loop_if_condition #iMin > j, go to iMin != j
	addi $s0, $s0, 1 #j++
	j outer_loop # branch to the outer loop

	inner_loop_if_condition:
	sll $t3, $s1, 2 # iMin * 2^2
	sll $t1, $s5, 2 # i * 4
	add $t3, $t3, $s3 # @ a[iMin]
	add $t1, $t1, $s3 # @ a[i]
	lw $t4, 0($t3) # a[iMin]
	lw $t2, 0($t1) # a[i]

	bge $t2, $t4, increment_inner_loop # if a[i] >= a[iMin], exit inner loop
	add $s1, $s5, $zero #iMin = i

	addi $s5, $s5, 1 # i++
	j inner_loop # jump to inner loop

	increment_inner_loop:
	addi $s5, $s5, 1 #i++
	j inner_loop #jump to inner loop

	outer_loop_if_condition:
	subi $sp, $sp, 12 #allocate 12 bytes of space in the stack
	sw $s0, 0($sp) # store j in the stack
	sw $s1, 4($sp) # store iMin in the stack
	sw $ra, 8($sp) # store return address in the stack

	add $a0, $s3, $zero #myArr[] address
	add $a1, $s0, $zero #j
	add $a2, $s1, $zero #iMin

	jal swap # call the swap function

	lw $s0, 0($sp) # load j from the stack
	lw $s1, 4($sp) # load iMin from the stack
	lw $ra, 8($sp) # load return address from the stack
	addi $sp, $sp, 12 # deallocate 12 bytes of space

	addi $s2, $s2, 1 #swapCount++
	addi $s0, $s0, 1 #j++
	j outer_loop


	swap_count_return:
	jr $ra # return address

	# CODE CITATION
	# http://www-inst.eecs.berkeley.edu/~cs61c/sp13/disc/04/Disc4Soln.pdf

	swap:
	sll $a1, $a1, 2
	sll $a2, $a2, 2
	addu $a1, $a0, $a1
	addu $a2, $a0, $a2
	lw $s0, 0($a1)
	lw $s1, 0($a2)
	sw $s0, 0($a2)
	sw $s1, 0($a1)
	jr $ra

	exit:
	li $v0, 10 # exit out of the program
	syscall

	** RESULT **
	6
-- program is finished running --
