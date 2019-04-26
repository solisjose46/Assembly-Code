.text
li $v0, 4
la $a0, ask_string
syscall
li $v0, 8
la $a0, string_array
li $a1, 9 #8 characters + \0
syscall

jal new_line

addi $sp, $sp, -8 #make room for 2 items on stack
addi $s0, $zero, 0
addi $s1, $zero, 0
sw $s0, 0($sp) #int i = 0
sw $s1, 4($sp) #int j = 0

make_v:
lw $s0, 0($sp)
lw $s1, 4($sp)
beq $s0, 8, v_prime #if i == 8, then exit

la $t0, string_array
add $t0, $t0, $s0
lb $t0, ($t0)

addi $a0, $t0, -48 #ascii -> int
li $v0, 1
syscall

la $t0, int_array_v
add $t0, $t0, $s1
sw $a0, ($t0)

addi $s0, $s0, 1 #i++
addi $s1, $s1, 4 #j+=4
sw $s0, 0($sp)
sw $s1, 4($sp)

j make_v

v_prime:
jal new_line
addi $s0, $zero, 0
addi $s1, $zero, 0
sw $s0, 0($sp)
sw $s1, 4($sp)
li $v0, 4
la $a0, ask_v_prime
syscall

make_v_prime:
lw $s0, 0($sp)
lw $s1, 4($sp)
beq $s0, 8, sub_array
li $v0, 5
syscall
la $t0, int_v_prime
add $t0, $t0, $s1
sw $v0, 0($t0)

addi $s0, $s0, 1
addi $s1, $s1, 4
sw $s0, 0($sp)
sw $s1, 4($sp)
j make_v_prime

sub_array:
jal new_line
addi $s0, $zero, 0
addi $s1, $zero, 0
sw $s0, 0($sp)
sw $s1, 4($sp)

subtract_array:
lw $s0, 0($sp)
lw $s1, 4($sp)
beq $s0, 8, print_check
la $t0, int_array_v
la $t1, int_v_prime
la $t2, int_v_check

add $t0, $t0, $s1
add $t1, $t1, $s1
add $t2, $t2, $s1
lw $t4, ($t0)
lw $t5, ($t1)
sub $t4, $t4, $t5 
sw $t4, ($t2)

addi $s0, $s0, 1
addi $s1, $s1, 4
sw $s0, 0($sp)
sw $s1, 4($sp)
j subtract_array

print_check:
li $v0, 4
la $a0, check_result
syscall
addi $s0, $zero, 0
addi $s1, $zero, 0
sw $s0, 0($sp)
sw $s1, 4($sp)

print:
lw $s0, 0($sp)
lw $s1, 4($sp)
beq $s0, 8, exit
la $t0, int_v_check
add $t0, $t0, $s1
lw $a0, ($t0)
li $v0, 1
syscall
addi $s0, $s0, 1
addi $s1, $s1, 4
sw $s0, 0($sp)
sw $s1, 4($sp)
j print

exit:
addi $sp, $sp, 8 #return $sp
li $v0, 10
syscall

new_line:
li $v0, 11 #print char
li $a0, 10 # 10 = \n
syscall
jr $ra

.data
ask_string: .asciiz "Input V: "
string_array: .space 10 #10 instead of 8 to align words in memory
int_array_v: .space 32 #32 bytes reserved for 8 ints
int_v_prime: .space 32
int_v_check: .space 32
ask_v_prime: .asciiz "Input V prime: "
check_result: .asciiz "Check Result: "
