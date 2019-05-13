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

matrix_mult:
addi $s0, $zero, 0 #int i = 0; C offset
addi $s1, $zero, 0 #int j = 0; A offset
addi $s2, $zero, 0 #int k = 0; B offset
addi $s3, $zero, 0 #int t = 0; outside_loop counter
addi $s5, $zero, 0 #B address shift

outside_loop:
la $t0, C
add $t0, $t0, $s0 #add C ofFset

addi $s4, $zero, 0 #int x = 0; inside_loop counter
#-----------------------
inside_loop:
lw $t1, ($t0) #C[i]

la $t2, A
add $t2, $t2, $s1 #add offset
lw $t3, ($t2)

la $t5, B
add $t5, $t5, $s5 #shift to correct column
add $t5, $t5, $s2
lw $t4, ($t5)

mul $t3, $t3, $t4
add $t1, $t1, $t3

sw $t1, ($t0)

addi $s1, $s1, 4 #A offset
addi $s2, $s2, 16 #B offset
addi $s4, $s4, 1 #insdide loop x++

blt $s4, 4, inside_loop
#----------------------
addi $s0, $s0, 4 #next C element
addi $s1, $zero, 0 #reset A offset
addi $s2, $zero, 0 #reset B offset
addi $s3, $s3, 1 #t++
addi $s5, $s5, 4 #next B colum

blt $s3, 4, outside_loop

addi $s1, $zero, 16
addi $s2, $s2, -16
blt $s3, 8, outside_loop

addi $s1, $zero, 32
addi $s2, $s2, -16
blt $s3, 12, outside_loop

addi $s1, $zero, 48
addi $s2, $s2, -16
blt $s3, 16, outside_loop

li $v0, 4
la $a0, C_matrix
syscall

addi $s0, $zero, 0 #outside loop, i =0
addi $s2, $zero, 0 #C offset
display_C:
addi $s1, $zero, 0 #inside loop, k = 0,  reset
C_loop:
la $t0, C
add $t0, $t0, $s2 #add offset
lw $a0, ($t0)
li $v0, 1
syscall

addi $s1, $s1, 1
blt $s1, 4, C_loop #k++

new_line1:
li $v0, 11 #print char
li $a0, 10 # 10 = \n
syscall

addi $s2, $s2, 4
addi $s0, $s0, 1 #i++
blt $s0, 4, display_C

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