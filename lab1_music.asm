li $s1, 0
music: 
lw $t1, array($s1)
li $v0, 31 #audio out
addi $a0, $t1, 0 #pitch, notes
la $a1, 500 #duration in milliseconds
la $a2, 7 #instrument
la $a3, 127 #volume 0-127
syscall
li $v0, 32
la $a0, 500
syscall #G
addi $s1, $s1, 4
bgt $s1, 92, exit
j music
exit:

.data
array: .word 72, 72, 67, 67, 69, 69, 67, 65, 65, 64, 64, 62, 72, 72, 67, 67, 69, 69, 67, 65, 65, 64, 64, 62