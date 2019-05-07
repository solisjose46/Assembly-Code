.text
Before: #not part of quiz
la $t0, A
addi $t5, $zero, 9
sw $t5, 32($t0)
####

Main:
la $t0, A
la $t1, index

lw $t2, 0($t1)
sll $t3, $t2, 2 #8 * 4(byte) = 32, calculate the appropiate postion in A[]
add $t3, $t0, $t3 #add A[] base address + offset

lw $t4, 0($t3) #int j = A[Index]
sw $t4, 0($t1) #index = j

.data
index: .word 8 #int index = 8
A: .space 40 #A[10]