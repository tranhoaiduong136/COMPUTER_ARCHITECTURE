.data 
request: .asciiz "Number of elements: "
request_2: .asciiz"Size of each elements: "
request_3: .asciiz "Error size"
new_line: .asciiz"\n"
.text
main:
# Input the number of elements 
la $a0, request
li $v0, 4
syscall
li $v0, 5
syscall
add $t9, $zero, $v0
##new_line
la $a0, new_line
li $v0, 4
syscall
# Input the size of each elements
la $a0, request_2
li $v0, 4
syscall
li $v0, 5
syscall
add $t8, $zero, $v0 
### Perform test
addi $t0, $zero, 4
jal Perform_matrix
########################
move $t1, $v1
beq $v0,-1,error_size
test:
sw $t0, 0($t1)
addi $t0,$zero,12 
sw $t0, 4($t1)
lw $s1, 4($t1)
add $a0, $0, $s1
li $v0 ,1
syscall
j exit
##############################################################
############PROCEDURE###########################
Perform_matrix:
	pass:
 	###Pass the arguments   
	move $a0, $t9 #number
	move $a1, $t8 #size
##################################### 
	init: 
	addi $sp, $sp, -12
	sw $a0, 0($sp) # number of elements
	sw $a1, 4($sp) # size of each elements
	sw $ra, 8($sp) # return address
#####################################
	mul $t7, $t9, $t8
	bgt $t7, 65536, return_1

	# allocate a space
	li $v0, 9  # system call code for dynamic allocation
	li $a0, 32 # $a0 contains number of bytes to allocate
	syscall
	move $t6, $v0 
	j return_2

	return_1:
	addi $v0, $0, -1 
	lw $a0, 0($sp)	
	lw $a1, 4($sp)		
	lw $ra, 8($sp)
	addi $sp,$sp 12
	jr $ra

	return_2:
	addi $v0, $0, 0 # success code	
	add $v1, $0, $t6 # the first address of the allocated 	
	lw $a0, 0($sp)	
	lw $a1, 4($sp)			
	lw $ra, 8($sp)
	addi $sp,$sp 12
	jr $ra
error_size:
la $a0, request_3
li $v0, 4
syscall
exit:     
