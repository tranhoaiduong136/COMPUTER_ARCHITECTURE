.data
read_file: .asciiz  "C:\\Users\\Duong\\Desktop\\computer_arc\\ass\\ex_2\\file_read.txt"
buffer_read: .space 1024
array: .word 0:10
New_line : .asciiz "\n"  
.text 
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
beq $t3, 32, space
addi $t3, $t3, -48
mul $t1, $t1, 10
add $t1, $t1, $t3
j next

space: #stop 1 character
sw $t1, array($s1) # store in array
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
########
################################################
# Extract here
     
### NEW LINE
exit:
li $v0, 4
la $a0,New_line
syscall
########
#test 1 elements in the array just read
test:
addi $t7, $0, 32
lw $t1, array($t7)
add $a0, $0, $t1
li $v0, 1
syscall
###############################################
# Close the file
close:
li $v0, 16 # system call for close file
move $a0, $s6 # file descriptor to close
syscall # close file  
