.text
Before: #not part of quiz
la $t0, A
addi $t5, $zero, 5
sw $t5, 32($t0)


Main:
la $t0, A
la $t1, index

lw $t2, 0($t1)
sll $t3, $t2, 2
add $t3, $t0, $t3

lw $t4, 0($t3)
sw $t4, 0($t1)

.data
index: .word 8 #int index = 8
A: .space 40 #A[10]