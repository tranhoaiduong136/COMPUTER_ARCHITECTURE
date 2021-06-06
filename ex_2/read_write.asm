.data
request:.asciiz"Enter request :"
error_1: .asciiz "Wrong mode"
####READ_FILE##
test_re:.asciiz"The number in the position 9 is: "
read_file: .asciiz  "C:\\Users\\Duong\\Desktop\\computer_arc\\ass\\ex_2\\file_read.txt"
buffer_read: .space 1024
array_read: .word 0:10
####WRITE_FILE###
write_file: .asciiz "C:\\Users\\Duong\\Desktop\\computer_arc\\ass\\ex_2\\file_write.txt"	 
array_write: .word 2,6,4,5,10,12,16,2000,1,100
space: .asciiz " "
buffer_write: .space 1024

New_line : .asciiz "\n" 
########### MAIN ###########
.text
main:
Input_:
# 1 : write/ 0: read
la $a0,request
li $v0, 4
syscall
li $v0, 5
syscall
add $a1, $zero, $v0 
jal read_write
beq $a1,0,read_test
j Exit
.text
##########PROCEDURE ####################
read_write:
	initial:
	addi $sp, $sp, -16
	sw $a0, 0($sp)		# name of file
	sw $a1, 4($sp)		# read/write behavior
	sw $a2, 8($sp)		# array to write
	sw $ra, 12($sp)
	
	beq $a1,0,reading
	beq $a1,1,writing
	j error
	
	reading:
###############################################################
# Open (for reading) a file
li $v0, 13 # system call for open file
la $a0, read_file # output file name
li $a1, 0 # Open for writing (flags are 0: read, 1: write)
li $a2, 0 # mode is ignored
syscall # open a file (file descriptor returned in $v0)
move $s6, $v0 # save the file descriptor
###############################################################
# Read from file
li $v0, 14 # system call for read
move $a0, $s6 # file descriptor
la $a1, buffer_read # address of buffer read
li $a2, 1024 # hardcoded buffer length
syscall # read file
###############################################
move $t9, $v0 # number of read characters
li $v0, 16
move $a0, $t8
syscall
init:
addi $s1,$0 , 0 # index of array in mips
addi $t0, $0, 0 # index array  
addi $t1 $0, 0 # current character
addi $t2,$0, 0 # count character
addi $t3,$0, 0	#temp

read_buffer:
lb $t3, buffer_read($s0)
beq $t3, 32, space_c
addi $t3, $t3, -48
mul $t1, $t1, 10
add $t1, $t1, $t3
j next

space_c: #stop 1 character
sw $t1, array_read($s1) # store in array
add $t1, $0, 0 # reset the current character
add $s1, $s1, 4
addi $t0, $t0, 1 # add 1 index
beq $t2, $t9 ,end_read

next: #next characeter
addi $s0, $s0,1
addi $t2,$t2,1
bne $t2, $t9,read_buffer
##################################################
end_read:
#print whats in the file
li $v0, 4
la $a0,buffer_read
syscall
#################################################
### NEW LINE
li $v0, 4
la $a0,New_line
syscall
###############################################
# Close the file
close_read:
li $v0, 16 # system call for close file
move $a0, $s6 # file descriptor to close
syscall # close file 
j end_proce
###############################################################
	writing:
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
lw $t3, array_write($t0) # load word from array to t3
# Switch case:
switch:
addi $t4, $0, 0 # count length and reset count
addi $t5, $0, 0 
      	get_length:	
   	addi $t4, $t4, 1
   	div $t3, $t3, 10 
   	bne $t3, 0, get_length
	lw $t3, array_write($t0)   	
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
	beq $t0, 40,close_write  
	j Extract 
###############################################
# Close the file
close_write:
li $v0, 16 # system call for close file
move $a0, $s6 # file descriptor to close
syscall # close file
j end_proce	
################################################################
	end_proce:
	lw $a0, 0($sp)		# name of file
	lw $a1, 4($sp)		# read/write behavior
	lw $a2, 8($sp)		# array to write
	lw $ra, 12($sp)	
	addi $sp, $sp, 16
	jr $ra
error:
la $a0, error_1
li $v0, 4
syscall
j Exit
read_test:
########
#test 1 elements in the array just read
test:
la $a0, test_re
li $v0, 4
syscall
addi $t7, $0, 32
lw $t1, array_read($t7)
add $a0, $0, $t1
li $v0, 1
syscall
Exit:
	
	

