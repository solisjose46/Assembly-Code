.text
li $v0, 4 #print string is loaded into $v0
la $a0, ask_name #address of ask_name is loaded into $a0
syscall
li $v0, 8 #read string
la $a0, my_name
la $a1, length
syscall
move $t5, $v0 #chancged-----------------------------------------
li $v0, 4 #print string is loaded into $v0
la $a0, ask_age #address of ask_age is loaded into $a0
syscall
li $v0, 5 #read int
syscall
move $t1, $v0 #value of $v0 -> $t1
li $v0, 4 #print string is loaded into $v0
la $a0, display1 #address of display1 is loaded into $a0
syscall
addi $t2, $t1, 4 #$t2 = $t1 + 4
li $v0, 1 #print int
move $a0, $t2 #$t2 -> $$a0
syscall
li $v0, 4 #print string is loaded into $v0
la $a0, display2 #address of display2 is loaded into $
syscall
li $v0, 4
la $a0, my_name
syscall



.data
ask_name: .asciiz "What is your name?: "
my_name: .space 51
length: .word 50 
ask_age: .asciiz "What is your age?: "
display1: .asciiz "You will be "
display2: .asciiz " years old in four years"
