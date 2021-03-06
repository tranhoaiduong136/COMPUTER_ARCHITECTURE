.data
write_file: .asciiz "C:\\Users\\Duong\\Desktop\\computer_arc\\ass\\ex_2\\file_write.txt"	 
array: .word 2,6,4,5,10,12,16,2000,1,100
space: .asciiz " "
buffer_write: .space 1024
.text
# Open (for writing) a file that does not exist
li   $v0, 13       # system call for open file
la   $a0, write_file     # output file name
li   $a1, 1       # Open for writing (flags are 0: read, 1: write)
li   $a2, 0        # mode is ignored
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor 
###############################################
#Extract here
addi $t0 ,$0, 0 #index of array
addi $s2 ,$0, 0 #index of buffer
Extract:
lw $t3, array($t0) # load word from array to t3
# Switch case:
switch:
addi $t4, $0, 0 # count length and reset count
addi $t5, $0, 0 
      	get_length:	
   	addi $t4, $t4, 1
   	div $t3, $t3, 10 
   	bne $t3, 0, get_length
	lw $t3, array($t0)   	
 	add $s2, $s2, $t4
 	
 	change_to_buffer: 
	div $t3, $t3, 10
	mfhi $t5
	addi $t5,$t5,48 #change to asciiz
	sb $t5,buffer_write($s2)# store byte in the buffer write
	addi $s2, $s2, -1
	bne $t3, 0 , change_to_buffer
	addi $s2, $s2, 1 
	
	Write: 
	li $v0, 15 # system call for write to file
	move $a0, $s6  # file descriptor
	la $a1, buffer_write($s2)# address of buffer from which to write
	move $a2, $t4  # hardcoded buffer length
	syscall
	
	li $v0, 15 # system call for write to file
	move $a0, $s6 # file descriptor
	la $a1,space # address of buffer from which to write
	li $a2, 1  # hardcoded buffer length
	syscall # write to file
	
	add $s2, $s2, $t4
	addi $t0, $t0, 4 
	beq $t0, 40,close  
	j Extract 
###############################################
# Close the file
close:
li $v0, 16 # system call for close file
move $a0, $s6 # file descriptor to close
syscall # close file	
