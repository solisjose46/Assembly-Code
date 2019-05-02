.text
main:

addi $sp, $sp, -20

la $s0, matrix_M #add 4 to increment
la $s1, row1 #add 8 to increment
la $s2, string_array

addi $s3, $zero, 0 #int i = 0, outside loop
addi $s4, $zero, 0#int j = 0, inside loop and string_array offset

sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

outside_loop:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)

beq $s3, 4, sum_matrix

print_row:
li $v0, 4
addi $a0, $s1, 0
syscall

addi $s1, $s1, 8 #move 8 bytes for next prompt

read_int_as_string:
li $v0, 8
addi $a0, $s2, 0
li $a1, 5 #4 chars + \n
syscall

###################################
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

char_to_int_loop:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)

beq $s4, 4, new_line

lb $t0, ($s2)
addi $t0, $t0, -48 #ascii -> int

sw $t0, ($s0)

addi $s0, $s0, 4 #next space for int
addi $s2, $s2, 1
addi $s4, $s4, 1

sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

jal char_to_int_loop
######################################
new_line:
li $v0, 11 #print char
li $a0, 10 # 10 = \n
syscall

addi $s3, $s3, 1
addi $s4, $zero, 0

sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

jal outside_loop

sum_matrix:
addi $s0, $zero, 0 #int i = 0
addi $s1, $zero, 0 #total sum
la $s2, matrix_M

sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)

sum_loop:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)

beq $s0, 16, exit

lw $t0, ($s2)
add $s1, $s1, $t0

addi $s0, $s0, 1 #i++
addi $s2, $s2, 4 #next int

sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)

jal sum_loop

exit:
lw $a0, 4($sp) #prints sum
li $v0, 1
syscall

addi $sp, $sp, 20 #return stack pointer
li $v0, 10 #exit gracefully
syscall

.data
matrix_M: .space 64
row1: .asciiz "ROW 1: " #8 bytes
row2: .asciiz "ROW 2: "
row3: .asciiz "ROW 3: "
row4: .asciiz "ROW 4: "
string_array: .space 5