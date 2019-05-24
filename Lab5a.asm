.text
main:
addi $sp, $sp, -16 #make room on stack for 4 int

la $a0, A_matrix
li $v0, 4
syscall

addi $s3, $zero, 0 #matrix_loop int k = 0
addi $s2, $zero, 0 #matrix A offset
matrix_loop:
addi $s0, $zero, 0 #int i = 0, reset
addi $s1, $zero, 0 #row1 offset, reset
make_matrix:
la $a0, row1
add $a0, $a0, $s1
li $v0, 4
syscall

addi $s1, $s1, 8 #next prompt

li $v0, 8
la $a0, string_array
li $a1, 5 #4 characters + \0
syscall

sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s3, 12($sp)
jal char_to_int
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s3, 12($sp)

new_line:
li $v0, 11 #print char
li $a0, 10 # 10 = \n
syscall

addi $s0, $s0, 1 #i++
blt $s0, 4, make_matrix
addi $s3, $s3, 1 #k++ matrix loop

la $a0, B_matrix
li $v0, 4
syscall

blt $s3, 2, matrix_loop

#-------------------------------------------
matrix_mult:
addi $s0, $zero, 0 #int i = 0; C offset
addi $s1, $zero, 0 #int j = 0; A offset
addi $s2, $zero, 0 #int k = 0; B offset
addi $s3, $zero, 0 #int t = 0; outside_loop counter
addi $s5, $zero, 0 #B reset column
outside_loop:
la $t0, C #load addresses
la $t1, A
la $t2, B

add $t0, $t0, $s0 #add offsets
add $t1, $t1, $s1
add $t3, $s2, $s5 #true B offset
add $t2, $t2, $t3

lw $t3, 0($t1) #A elements
lw $t4, 4($t1)
lw $t5, 8($t1)
lw $t6, 12($t1)

lw $t7, 0($t2) #B elements
lw $t8, 16($t2)
lw $t9, 32($t2)
lw $s4, 48($t2)

mul $t3, $t3, $t7
mul $t4, $t4, $t8
mul $t5, $t5, $t9
mul $t6, $t6, $s4

add $t3, $t3, $t4
add $t5, $t5, $t6
add $t4, $t3, $t5

sw $t4, 0($t0)

addi $s0, $s0, 4 #C offset
addi $s2, $s2, 4 #B offset
addi $s3, $s3, 1 #t++
blt $s3, 4, outside_loop

addi $s5, $zero, -16
addi $s1, $zero, 16
blt $s3, 8, outside_loop

addi $s5, $zero, -32
addi $s1, $zero, 32
blt $s3, 12, outside_loop

addi $s5, $zero, -48
addi $s1, $zero, 48
blt $s3, 16, outside_loop
#------------------------------

print_C:
li $v0, 4
la $a0, C_matrix
syscall

addi $s0, $zero, 0 #inside loop
addi $s1, $zero, 0 #outside loop
addi $s2, $zero, 0 #offset

print_loop:
la $t0, C
add $t0, $t0, $s2

li $v0, 1
lw $a0, ($t0)
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4

blt $s0, 4, print_loop

new_line1:
li $v0, 11 #print char
li $a0, 10 # 10 = \n
syscall

addi $s0, $zero, 0 #reset inside loop
addi $s1, $s1, 1 #i++

blt $s1, 4, print_loop

exit:
addi $sp, $sp, 16
li $v0, 10
syscall

#---------------------------------
char_to_int:
addi $t1, $zero, 0 #int k = 0 and byte offset
lw $s2, 8($sp)
loop:
la $t0, string_array
add $t0, $t0, $t1 #add offset
lb $t2, ($t0)

addi $t2, $t2, -48 #char -> int

la $t3, A
add $t3, $t3, $s2 #add A offset
sw $t2, ($t3)

addi $s2, $s2, 4
addi $t1, $t1, 1
blt $t1, 4, loop
sw $s2, 8($sp)
jr $ra
#-----------------------------------

.data
C: .space 64
A: .space 64
B: .space 64
string_array: .space 4
row1: .asciiz "ROW 1: " #8 bytes
row2: .asciiz "ROW 2: "
row3: .asciiz "ROW 3: "
row4: .asciiz "ROW 4: "
A_matrix: .asciiz "Matrix A: \n"
B_matrix: .asciiz "Matrix B: \n"
C_matrix: .asciiz "Matrix C: \n"
