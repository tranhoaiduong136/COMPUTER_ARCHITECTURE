.data
request_1: .asciiz"Input the h and w of matrix A: "
request_2: .asciiz"Input the h and w of matrix B: "
error: .asciiz"Cannot perform multiplication"
A: .word 1, 2, 20, 10, 1, 2, 3, 4, 1, 4, 5, 9
# (1, 2, 20, 10)
# (1, 2,  3,  4)	MATRIX A
# (1, 4,  5,  9)
B: .word 1, 2, 3, 4, 8, 9, 2, 1, 1, 2, 3, 3, 1, 2, 3, 5
# (1, 2, 3, 4)
# (8, 9, 2, 1)		MATRIX B
# (1, 2, 3, 3)
# (1, 2, 3, 5)
result: .space 65536
space: .asciiz" "
endline:.asciiz"\n"

.text 
main:
la $a0, A
la $a1,B
la $a2,result

jal Matrix_multiplication
#check wrong
beq $v0, -1, not_perform
#####TESTING#########
addi $t1, $0, 0
addi $t2,$0 , 0 #count width
Install:
mul $t9, $s0,$s2
addi $t8, $0 ,4
mul $t9,$t9,$t8

add $t0, $0, 0
loop:
beq $t0,$t9,exit
lw $s1, result($t0)
add $a0, $0, $s1
li $v0, 1
syscall

la $a0, space
li $v0,4
syscall

addi $t2,$t2,1
addi $t0, $t0,4
beq $t2,$s2,end_l
j loop
end_l:
addi $t2,$0,0
la $a0,endline
li $v0,4
syscall
j loop
################################################
######PROCEDURE##################
.text
Matrix_multiplication:
	# Register usage:
  	# n is $s0, m is $s1, p is $s2
  	# r is $s3, c is $s4, i is $s5
  	# sum is $s6
	addi $sp, $sp, -16
	sw $a0, 0($sp) # Matrix A
	sw $a1, 4($sp) # Matrix B
	sw $a2, 8($sp) # Matrix result
	sw $ra, 12($sp) # return address
	
	#Input the height and width of A(s0,s1)A[n][m]
	Input_1:
	la $a0, request_1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $s0, $zero, $v0 #height A
	li $v0, 5
	syscall
	add $s1, $zero, $v0 # width A 
	
	#Input the height and width of B(s7,s2) B[m][p]
	Input_2:
	la $a0, request_2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $s7, $zero, $v0 #height B
	li $v0, 5
	syscall
	add $s2, $zero, $v0 #width B
	#Check case
	bne $s1,$s7 , wrong_case
	j success_case 
	#Return -1
	wrong_case: 
	addi $v0, $0, -1
	lw $a0, 0($sp)	
	lw $a1, 4($sp)
	lw $a2, 8($sp)			
	lw $ra, 12($sp)
	addi $sp,$sp 16
	jr $ra
	
	#Return 0
	success_case:
		# Register usage:
 		# n is $s0, m is $s1, p is $s2,
  		# r is $s3, c is $s4, i is $s5,
  		# sum is $s6
  		# height of B is $s7
		Init:
		addi  $s3,$0,0               # r = 0
  		addi  $t0,$0,4               # sizeof(Int)
		mult_n:
  		bge  $s3,$s0, return        # if r >= n, branch
 		addi $s4,$0, 0               # c = 0
		mult_p:
  		bge  $s4, $s2, mult_end2  # if c >= p, branch
  		li   $s6, 0               # int sum = 0;
		j    mult_m
		mult_store:
  		mul  $t3, $s3, $s2        # t3 = r * p
  		mul  $t3, $t3, $t0        # t3 = t3 * 4
  		mul  $t4, $s4, $t0        # t4 = c * 4
  		add  $t3, $t3, $t4        # t3 = t3 * t4 = (r * p * 4) + (c * 4)
  		sw   $s6, result($t3)     # C[r][c] = sum;

  		addi $s4, $s4, 1          # c++

  		addi $s5, $0, 0               # i = 0
 	        j    mult_p
		mult_m:
 		bge  $s5, $s1, mult_store # if i >= m, branch

  		# A[r][i]
  		mul  $t5, $s3, $s1        # t5 = r * m
  		mul  $t5, $t5, $t0        # t5 = t5 * 4
  		mul  $t6, $s5, $t0        # t6 = i * 4
  		add  $t5, $t5, $t6        # t5 = (r * m * 4) + (i * 4)
  		
  		lw   $t5, A($t5)
  		
  		# B[i][c]
  		mul  $t7, $s5, $s2        # t7 = i * n
  		mul  $t7, $t7, $t0        # t7 = t7 * 4
  		mul  $t8, $s4, $t0        # t8 = 4 * c
  		add  $t7, $t7, $t8        # t7 = (i * n * 4) + (c * 4)
  		
  		lw   $t7, B($t7)
  		
 		mul  $t7, $t5, $t7        # t7 = t5 * t7
  		add  $s6, $s6, $t7        # sum = sum + t7
			
  		addi $s5, $s5, 1          # i++
 		j   mult_m

		mult_end2:
 		addi $s3, $s3, 1          # r++
  		j    mult_n
		
		return: 
		addi $v0,$0, 0
		lw $a0, 0($sp)	
		lw $a1, 4($sp)
		lw $a2, 8($sp)			
		lw $ra, 12($sp)
		addi $sp,$sp 16
		jr $ra	
not_perform:
la $a0, error
li $v0, 4
syscall
exit:	
