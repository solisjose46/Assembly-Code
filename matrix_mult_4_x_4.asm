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

.data
C: .space 64
A: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
B: .word 1, 5, 9, 12, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16

