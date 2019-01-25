# RANGE 255
# N 1000

.data


str: 	.byte 'c', 'a', 'd', 'l', 'j', 'g' ,'a', 'r', 'h', 't', 'o' ,'x'
		.byte 'A', 'H', 'd', 'g', 'd', 's', 'J', 'K', 'h', 'Y', 'E', 'a'
		.byte 's', 'd', 'u', 'w', 'B', 'R', 'L', 's', 'd', 'g', 'H', 'o'
		.byte 'p','t', 'x', 'n', 'a', 's', 'e', 'u', 'r', 'h'

output: .space  1000 #output[N]
countsz: .word 255 #range

.align 2 #force alignment 2^2 = 4
count: .space 1024 #count[range+1] 

.text



.globl main

main:
	add $t0, $zero, $zero # initialize i in $t0 = 0
	la $s0, count #load address of count[] to $a0
	lw $s1, countsz #range
	la $s2, str
	
	addi $t9, $s1, 1 #range+1

	#initialize count array as 0
for_zero:
	sll $t1, $t0, 2 #make offset of int to set zero of count
	
	add $t8, $s0, $t1 #next address of count find by ptr(i*4)
	sw $zero, ($t8) #count[i] = 0
	
	addi $t0, $t0, 1 # count i++

	slt $t1, $t0, $t9 # x if i < range+1 ? 1:0
	bne $t1, $zero, for_zero # x != 0 jump to for_zero

	#store count of each characher
	add $t0, $zero, $zero #set i=0
	lb $t1, 0($s2) #load first char from str[]
for_string:
	
	sll $t7, $t1, 2 #get str[] and str*4 to find next address of count
	add $t8, $s0, $t7 #next address of count[] find by ptr(str[i]*4)
	lw $t2, ($t8) #load count[] and backup in $t2

	addi $t2, $t2, 1 #++count[]
	sw $t2, ($t8)  #store back to what where it come from
	
	addi $t0, $t0, 1 #i++

	add $t9, $s2, $t0 #next address of str[] find by ptr(i)
	lb $t1, 0($t9) #load char from str[]
	bne $t1, $zero, for_string #if we load char str[] if not find then exit loop


	#change count[i] so that count[i] now contains actual
	#position of this character in output array
	add $t0, $zero, $zero #set i-1 = 0
	addi $t1, $zero, 1 #set i = 1
for_before:

	sll $t7, $t0, 2 #(i-1)*4	
	sll $t8, $t1, 2 #i*4

	add $t2, $s0, $t7 #address of count[i-1]
	lw $t4, ($t2) #load count[i-1]

	add $t3, $s0, $t8 #address of count[i]
	lw $t5, ($t3) #load count[i]

	add $t6, $t4, $t5
	sw $t6, ($t3)

	addi $t0, $t0, 1
	addi $t1, $t1, 1

	slt $t9, $s1, $t1 #range < i
	beq $t9, $zero, for_before

exit:
	li $v0, 10
	syscall

