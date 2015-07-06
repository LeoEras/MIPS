.data 
buffer: .space 3000		# "buffer" contendrÃ¡ la direcciÃ³n base al string del archivo
file: .asciiz "C://Users//Juan Jose//Desktop//Data.txt" # DirecciÃ³n absoluta del archivo

#text messages
errortext:      .asciiz "Ha ingresado un valor no valido\n"
errorOpentext:  .asciiz "Error opening file!\n\n"
message2text:   .asciiz "\n \n Archivo generado con Exito! \n\n"
optionText: .asciiz "Por favor, escoja una opciÃ³n: "
limitText:	.asciiz "\n Limite de caracteres: "
continueMessage: .asciiz "Presione una tecla para continuar... "
numberOfWords: .asciiz "\n El número de palabras es: "
numberOfWordsMore: .asciiz "\n El número de palabras con más de n caracteres es: "

#Title
Maintext:       .asciiz "\n\n\n______-----  PROYECTO ORGANIZACIÃ“N  -----______\n\n\n Ingresar nombre del archivo (ej: archivo.txt): \n\n"
Menutext:       .asciiz	"\n\n\n______-----      MENU     -----______\n\n1. Estadistica.  \n2. Generar Archivo sin espacios entre palabras.  \n3. Generar Archivo al revÃ©s.  \n4. Cargar de nuevo Archivo.  \n5. Acerca de...\n6. Salir\n"
TitleOp1text:	.asciiz "\n\n\n______-----  ESTADISTICA  -----______\n\n"
TitleOp2text:	.asciiz "\n\n\n______-----  ARCHIVO SIN ESPACIOS  -----______\n\n"
TitleOp3text:	.asciiz "\n\n\n______-----  ARCHIVO AL REVES  -----______\n\n"
TitleOp5text:	.asciiz "\n\n\n______----- OrganizaciÃ³n y Arquitectura de Computadores -----______\n\t\tProyecto del Primer Parcial\n\n\tDesarrolladores: \n\t\tLeonardo Eras Delgado\n\t\tJuan Garcia Cedeno\n\t\tVanessa Robles SolÃ­s\n\n"

cons1:  .word 32
cons2:  .word 13		
cons3:  .word 3			# Número de caracteres definidos por el usuario
.text
#---------------------CONSIDERACIONES--------------------------
# $s0 = File Descriptor
# $s1 = Dirección base del buffer en memoria
# $s2 = Número total de caracteres leidos
#--------------------------------------------------------------



# Subrutine: main (Inicio del Programa)
main:
	jal	mainMenu
	j 	exit    

# Subrutine: mainMenu (Menu Principal)
mainMenu:
	addi $sp, $sp, -4	#Copia de seguridad de la direcciÃ³n de la funciÃ³n que llama
	sw $ra, 0($sp)
	
	Bucle:
	li $v0, 4	
			
	la $a0, Menutext
	syscall
	la $a0, optionText
	syscall
	li $v0, 12	# Se carga el numero 12 para indicar que la funcion SYSCALL va a leer un char.
	syscall
	andi $v0, $v0, 207	#Mask: 11001111
	
	li $t0, 1
	beq $v0, $t0, Estadistica
	li $t0, 2
	beq $v0, $t0, Sin_Espacios
	li $t0, 3
	beq $v0, $t0, Al_Reves
	li $t0, 4
	beq $v0, $t0, Cargar_Archivo
	li $t0, 5
	beq $v0, $t0, About
	li $t0, 6
	beq $v0, $t0, Salir
	j Bucle
	
	Estadistica:
		li $v0, 4	# Se carga el numero 4 para indicar que la funcion SYSCALL va a imprimir un texto.
		la $a0, TitleOp1text
		syscall
		la $a0, continueMessage
		syscall
		li $v0, 12	# Se carga el numero 12 para indicar que la funcion SYSCALL va a leer un char.
		syscall
		j open
		j Bucle
	Sin_Espacios:
		li $v0, 4	# Se carga el numero 4 para indicar que la funcion SYSCALL va a imprimir un texto.
		la $a0, TitleOp2text
		syscall
		la $a0, continueMessage
		syscall
		li $v0, 12	# Se carga el numero 12 para indicar que la funcion SYSCALL va a leer un char.
		syscall
		j Bucle	
	Al_Reves:	
		li $v0, 4	# Se carga el numero 4 para indicar que la funcion SYSCALL va a imprimir un texto.
		la $a0, TitleOp3text
		syscall
		la $a0, continueMessage
		syscall
		li $v0, 12	# Se carga el numero 12 para indicar que la funcion SYSCALL va a leer un char.
		syscall
		j Bucle
	Cargar_Archivo:
		li $v0, 4	# Se carga el numero 4 para indicar que la funcion SYSCALL va a imprimir un texto.
		la $a0, Menutext
		syscall
		la $a0, continueMessage
		syscall
		li $v0, 12	# Se carga el numero 12 para indicar que la funcion SYSCALL va a leer un char.
		syscall
		j Bucle
	About:
		li $v0, 4	# Se carga el numero 4 para indicar que la funcion SYSCALL va a imprimir un texto.
		la $a0, TitleOp5text
		syscall
		la $a0, continueMessage
		syscall
		li $v0, 12	# Se carga el numero 12 para indicar que la funcion SYSCALL va a leer un char.
		syscall
		j Bucle
	Salir:
		#Restore return address.
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra

# Subrutine:
open: 	la $a0,file  		# file contiene la direcciÃ³n del string en memoria; Ese string es la direcciÃ³n absoluta de mi archivo.
	li $a1,0 		# Flag=0 para leer
	li $a2,0		# Mode=0 para leer
	li $v0,13		# Constante para abrir un archivo
	syscall
	add $s0, $v0, $0	# $v0 contiene la referencia al archivo; "File Descriptor"		

# Subrutine:	
read:	add $a0, $s0, $0	# Cargo en $a0 la direccion del file descriptor
	la $a1, buffer		# Indico el buffer que almacenarÃ¡ los datos
	li $a2, 3000		# Indico el nÃºmero mÃ¡ximo de bytes a leer
	li $v0, 14		# Constante para leer un archivo
	syscall
	la $s1, buffer		# Copio la direcciÃ³n del buffer, en memoria,  al resgistro $s1. Se accederÃ¡ al archivo desde el registro $s1. Cada byte serÃ¡ una letra
	
# Variables utilizadas para contar el número de palabras	
	add $s2, $v0, $0  	# Copio el número total de caracteres leidos al registro $s2
	addi $s3,$0,0		# Iterador a utilizar
	addi $s4,$0,1		# Contador de palabras
	addi $s5,$0,0		# Contador de caracteres por palabra
	addi $s6,$0,0		# Contador de palabras con más de "n" caracteres
#-----------------------------------------------	
	
loop:	lw $t2, cons1		# Cargo el valor de 32 en la variable temporal $t2
	lw $t3, cons2		# Cargo el valor de 13 en la variable temporal $t3
	slt $t0, $s3, $s2  	# Verifico si llege al último caracter
	beq $t0,$0,close	# Verifico si ya leí todos los caracteres
	add $t1, $s3, $s1	# Sumo mi iterador a la direccion base del string que contiene el archivo
	lb $t0, 0($t1)		# Cargo el i-esimo byte	en $t0
	addi $s3, $s3, 1	# Incremento el iterador	
	beq $t0, $t2, Up	# Verifico si el caracter leido es un espacio	
	beq $t0, $t3, Up	# Verifico si el catacter leido es un salto de linea
	beq $t0, $0, esp	# Verifico si es un EOF
	addi $s5, $s5, 1	# Aumento, el contador de caracteres por palabra, en 1
	j loop					

# Subrutine:

close: 	li $v0, 16		# Constante para cerrar el archivo
	add $a0, $s0, $0	# DirecciÃ³n al "File Descriptor" del archivo a cerrar
	syscall

# Subrutine:	
print: 	li $v0, 4			
	la $a0, numberOfWords
	syscall
	li $v0,1		# Constante para imprimir enteros	
	add $a0, $s4,$0		# $s4 contiene el nÃºmero total de palabras encontradas
	syscall	
	li $v0, 4		# Constante para imprimir strings	
	la $a0, numberOfWordsMore # Cargo el string a imprimir en el registro $a0
	syscall
	li $v0,1		# Constante para imprimir enteros	
	add $a0, $s6,$0		# $s6 contiene el nÃºmero total de palabras encontradas con más de n caracteres
	syscall	
	j Bucle	
	
exit: 	li $v0, 10		# Constante para terminar el programa
	syscall				

Up: 	lw $t2, cons1
	lw $t3, cons2
	lw $t4, cons3
	add $t1, $s3, $s1	# Sumo mi iterador a la direccion base del string que contiene el archivo
	lb $t0, 0($t1)		# Cargo el i-esimo byte	en $t0
	beq $t0, $t2, loop	# Verifico si el próximo catacter leido es un salto de linea
	beq $t0, $t3, loop 	# Verifico si el próximo caracter leido es un espacio	
	beq $t0, $0,  esp	# Verifico si es un EOF
	addi $s4, $s4, 1	# Aumenta el contador de palabras en 1
	addi $t4, $t4, 1
	slt $t5, $s5,$t4  	# Verifico si excedo el número de caracteres por palabra
	beq $t5, $0, found 	# Branch a Found si es que mi palabra tiene más de "n" caracteres
	addi $s5, $0, 0		# Reseteo el contador de caracteres a 0
	j loop					

found:	addi $s6, $s6,1		# Sumo el contador de palabras con más de n caracteres en 1
	addi $s5, $0, 0		# Reinicio el contador de caracteres por palabra
	j loop
	
esp:	slt $t5, $s5,$t4  	# Verifico si excedo el número de caracteres por palabra
	beq $t5, $0, found 
	addi $s5, $0, 0
	j loop	
