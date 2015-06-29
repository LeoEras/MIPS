.data 
buffer: .space 500		# "buffer" contendrá la dirección base al string del archivo
file: .ascii "C://Users//Juan Jose//Desktop//Data.txt" # Dirección absoluta del archivo

.text

open: 	la $a0,file  		# file contiene la dirección del string en memoria; Ese string es la dirección absoluta de mi archivo.
	li $a1,0 		# Flag=0 para leer
	li $a2,0		# Mode=0 para leer
	li $v0,13		# Constante para abrir un archivo
	syscall
	add $s0, $v0, $0	# $v0 contiene la referencia al archivo; "File Descriptor"		
	
read:	add $a0, $s0, $0	# Cargo en $a0 la direccion del file descriptor
	la $a1, buffer		# Indico el buffer que almacenará los datos
	li $a2, 50		# Indico el número máximo de bytes a leer
	li $v0, 14		# Constante para leer un archivo
	syscall
	la $s1, buffer		# Copio la dirección del buffer, en memoria,  al resgistro $s1. Se accederá al archivo desde el registro $s1. Cada byte será una letra
	
	
# Variables utilizadas para contar el número de palabras	
	add $s2, $v0, $0  	# Copio el número total de caracteres leidos al registro $s2
	add $s3, $s3, $0	# Iterador a utilizar
	addi $s4,$s4, 1		# Contador de espacios
	addi $s5,$s5, 32	# valor entero del caracter espacio en ascii	
#-----------------------------------------------	
	
loop:	slt $t0, $s3, $s2  	# Verifico si llege al último caracter
	beq $t0,$0,close	# Verifico si ya leí todos los caracteres
	add $t1, $s3, $s1	# Sumo mi iterador a la direccion base del string que contiene el archivo
	lb $t0, 0($t1)		# Cargo el i-esimo byte	en $t0
	addi $s3, $s3, 1	# Incremento el iterador	
	beq $t0, $s5, Up	# Verifico si el caracter leido es un espacio	
	j loop
				


close: 	li $v0, 16		# Constante para cerrar el archivo
	add $a0, $s0, $0	# Dirección al "File Descriptor" del archivo a cerrar
	syscall
	
print: 	li $v0,1		# Constante para imprimir enteros	
	add $a0, $s4,$0		# $s4 contiene el número total de palabras encontradas
	syscall	
		
exit: 	li $v0, 10		# Constante para terminar el programa
	syscall			

Up: 	addi $s4, $s4, 1	# Aumenta el contador de palabras en 1
	j loop						
