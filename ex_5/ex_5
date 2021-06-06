.data 
request_1: .asciiz"Input the h and w of matrix A: "
request_2: .asciiz"Input the h and w of matrix B: "
request_3: .asciiz "Error size"
request_4: .asciiz "Error performance"
request_5: .asciiz"Cannot perform multiplication because of error"

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


A_file: .asciiz"C:\\Users\\Duong\\Desktop\\computer_arc\\ass\\ex_5\\A.txt"
B_file: .asciiz"C:\\Users\\Duong\\Desktop\\computer_arc\\ass\\ex_5\\B.txt"
result_file: .asciiz"C:\\Users\\Duong\\Desktop\\computer_arc\\ass\\ex_5\\result.txt"


buffer_write_A: .space 65536
buffer_write_B: .space 65536
buffer_write_result: .space 65536

space: .asciiz " "
endline:.asciiz "\n"

.text
main:
# Register usage:
# n is $s0, m is $s1, p is $s2

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
jal Perform_matrix
jal Matrix_multiplication
jal write_file
j Exit
###########################################################################
Perform_matrix:
##Check condition
mul $t0,$s0,$s1
mul $t0, $t0, 4

mul $t1,$s7,$s2
mul $t1,$t1,4  

mul $t2,$s0,$s2
mul $t2,$t2,4
#Wrong case
addi $v0,$0,-1
bgt $t0,65536,Error_size
bgt $t1,65536,Error_size
bgt $t2,65536,Error_perform_size
#Allocate:
addi $v0,$0,1
addi $sp,$sp,-28
sw $ra,0($sp) #save return
#Matrix A
li $v0, 9  # system call code for dynamic allocation
move $a0, $t0 # $a0 contains number of bytes to allocate
syscall
sw $v0,4($sp)
#Matrix B
li $v0, 9  # system call code for dynamic allocation
move $a0, $t1 # $a0 contains number of bytes to allocate
syscall
sw $v0,8($sp)
#Matrix result
li $v0, 9  # system call code for dynamic allocation
move $a0, $t2 # $a0 contains number of bytes to allocate
syscall
sw $v0,12($sp)
#return

sw $t0,16($sp)
sw $t1,20($sp)
sw $t2,24($sp)

lw $ra,0($sp)
jr $ra

Matrix_multiplication:
	# Register usage:
  	# n is $s0, m is $s1, p is $s2
  	# r is $s3, c is $s4, i is $s5
  	# sum is $s6
  	
  		####Wrong case####
  		bne $s1,$s7,Error_perform
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
  		j  mult_n
  		return: 
  		jr $ra
write_file: 	
		#############################################################
		#MATRIX A
		# Open (for writing) a file that does not exist
		li   $v0, 13       # system call for open file
		la   $a0, A_file     # output file name
		li   $a1, 1       # Open for writing (flags are 0: read, 1: write)
		li   $a2, 0        # mode is ignored
		syscall            # open a file (file descriptor returned in $v0)
		move $s6, $v0      # save the file descriptor
		###############################################
		#Extract here
		addi $t0 ,$0, 0 #index of array
		addi $s3 ,$0, 0 #index of buffer
		
		addi $s4, $0, 0 #count width 
		
		Extract_A:
		lw $t3, A($t0) # load word from array to t3
		# Switch case:
		switch_A:
		addi $t4, $0, 0 # count length and reset count
		addi $t5, $0, 0 
      		get_length_A:	
   		addi $t4, $t4, 1
   		div $t3, $t3, 10 
   		bne $t3, 0, get_length_A
		lw $t3, A($t0)   	
 		add $s3, $s3, $t4
 	
 		change_to_buffer_A: 
		div $t3, $t3, 10
		mfhi $t5
		addi $t5,$t5,48 #change to asciiz
		sb $t5,buffer_write_A($s3)# store byte in the buffer write
		addi $s3, $s3, -1
		bne $t3, 0 , change_to_buffer_A
		addi $s3, $s3, 1 
	
		Write_A: 
		li $v0, 15 # system call for write to file
		move $a0, $s6  # file descriptor
		la $a1, buffer_write_A($s3)# address of buffer from which to write
		move $a2, $t4  # hardcoded buffer length
		syscall
		
		li $v0, 15 # system call for write to file
		move $a0, $s6 # file descriptor
		la $a1,space # address of buffer from which to write
		li $a2, 1  # hardcoded buffer length
		syscall # write to file
		#########
		Condition_endline_A:
		addi $s4,$s4,1
		beq $s4,$s1,enter_A
		
		continue_A:
		add $s3, $s3, $t4
		addi $t0, $t0, 4
		lw $t7, 16($sp) 
		beq $t0,$t7,close_A  
		j Extract_A 
		###############################################
		enter_A:
		addi $s4,$0, 0
		li $v0, 15 # system call for write to file
		move $a0, $s6 # file descriptor
		la $a1,endline # address of buffer from which to write
		li $a2, 1  # hardcoded buffer length
		syscall # write to file
		j continue_A
		###############################################
		# Close the file
		close_A:
		li $v0, 16 # system call for close file
		move $a0, $s6 # file descriptor to close
		syscall # close file
		
		#############################################################
		#MATRIX B
		# Open (for writing) a file that does not exist
		li   $v0, 13       # system call for open file
		la   $a0, B_file     # output file name
		li   $a1, 1       # Open for writing (flags are 0: read, 1: write)
		li   $a2, 0        # mode is ignored
		syscall            # open a file (file descriptor returned in $v0)
		move $s6, $v0      # save the file descriptor
		###############################################
		#Extract here
		addi $t0 ,$0, 0 #index of array
		addi $s3 ,$0, 0 #index of buffer
		
		addi $s4, $0, 0 #count width 
		
		Extract_B:
		lw $t3, A($t0) # load word from array to t3
		# Switch case:
		switch_B:
		addi $t4, $0, 0 # count length and reset count
		addi $t5, $0, 0 
      		get_length_B:	
   		addi $t4, $t4, 1
   		div $t3, $t3, 10 
   		bne $t3, 0, get_length_B
		lw $t3, B($t0)   	
 		add $s3, $s3, $t4
 	
 		change_to_buffer_B: 
		div $t3, $t3, 10
		mfhi $t5
		addi $t5,$t5,48 #change to asciiz
		sb $t5,buffer_write_B($s3)# store byte in the buffer write
		addi $s3, $s3, -1
		bne $t3, 0 , change_to_buffer_B
		addi $s3, $s3, 1 
	
		Write_B: 
		li $v0, 15 # system call for write to file
		move $a0, $s6  # file descriptor
		la $a1, buffer_write_B($s3)# address of buffer from which to write
		move $a2, $t4  # hardcoded buffer length
		syscall
		
		li $v0, 15 # system call for write to file
		move $a0, $s6 # file descriptor
		la $a1,space # address of buffer from which to write
		li $a2, 1  # hardcoded buffer length
		syscall # write to file
		#########
		Condition_endline_B:
		addi $s4,$s4,1
		beq $s4,$s2,enter_B
		
		continue_B:
		add $s3, $s3, $t4
		addi $t0, $t0, 4
		lw $t7, 20($sp) 
		beq $t0,$t7,close_B  
		j Extract_B
		###############################################
		enter_B:
		addi $s4,$0, 0
		li $v0, 15 # system call for write to file
		move $a0, $s6 # file descriptor
		la $a1,endline # address of buffer from which to write
		li $a2, 1  # hardcoded buffer length
		syscall # write to file
		j continue_B
		###############################################
		# Close the file
		close_B:
		li $v0, 16 # system call for close file
		move $a0, $s6 # file descriptor to close
		syscall # close file
		
		#############################################################
		#MATRIX RESULT
		# Open (for writing) a file that does not exist
		li   $v0, 13       # system call for open file
		la   $a0, result_file     # output file name
		li   $a1, 1       # Open for writing (flags are 0: read, 1: write)
		li   $a2, 0        # mode is ignored
		syscall            # open a file (file descriptor returned in $v0)
		move $s6, $v0      # save the file descriptor
		###############################################
		#Extract here
		addi $t0 ,$0, 0 #index of array
		addi $s3 ,$0, 0 #index of buffer
		
		addi $s4, $0, 0 #count width 
		
		Extract_result:
		lw $t3, result($t0) # load word from array to t3
		# Switch case:
		switch_result:
		addi $t4, $0, 0 # count length and reset count
		addi $t5, $0, 0 
      		get_length_result:	
   		addi $t4, $t4, 1
   		div $t3, $t3, 10 
   		bne $t3, 0, get_length_result
		lw $t3, result($t0)   	
 		add $s3, $s3, $t4
 	
 		change_to_buffer_result: 
		div $t3, $t3, 10
		mfhi $t5
		addi $t5,$t5,48 #change to asciiz
		sb $t5,buffer_write_result($s3)# store byte in the buffer write
		addi $s3, $s3, -1
		bne $t3, 0 , change_to_buffer_result
		addi $s3, $s3, 1 
	
		Write_result: 
		li $v0, 15 # system call for write to file
		move $a0, $s6  # file descriptor
		la $a1, buffer_write_result($s3)# address of buffer from which to write
		move $a2, $t4  # hardcoded buffer length
		syscall
		
		li $v0, 15 # system call for write to file
		move $a0, $s6 # file descriptor
		la $a1,space # address of buffer from which to write
		li $a2, 1  # hardcoded buffer length
		syscall # write to file
		
		#########
		Condition_endline_result:
		addi $s4,$s4,1
		beq $s4,$s2,enter_result
		
		continue_result:
		add $s3, $s3, $t4
		addi $t0, $t0, 4
		lw $t7, 24($sp) 
		beq $t0,$t7,close_result  
		j Extract_result
		###############################################
		enter_result:
		addi $s4,$0, 0
		li $v0, 15 # system call for write to file
		move $a0, $s6 # file descriptor
		la $a1,endline # address of buffer from which to write
		li $a2, 1  # hardcoded buffer length
		syscall # write to file
		j continue_result
		###############################################
		# Close the file
		close_result:
		li $v0, 16 # system call for close file
		move $a0, $s6 # file descriptor to close
		syscall # close file
		jr $ra
		 	 	
Error_size:
la $a0, request_3
li $v0, 4
syscall
j Exit
Error_perform:
la $a0, request_4
li $v0, 4
syscall
j Exit
Error_perform_size: 
la $a0, request_5
li $v0, 4
syscall
j Exit
Exit:	
