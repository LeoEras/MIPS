.data 
buffer: .space 255			# "buffer" contendrá¡ la dirección base al string del archivo
file: .space 255 			# Dirección absoluta del archivo
fwrite:	.asciiz "sinespacio.txt"     	# Archivo que arroja la funcion definida sinespacio

#text messages
errortext:      .asciiz "Ha ingresado un valor no valido\n"
errorOpentext:  .asciiz "Error opening file!\n\n"
message2text:   .asciiz "\n \n Archivo generado con Exito! \n\n"
optionText: .asciiz "Por favor, escoja una opción: "
limitText:	.asciiz "\n Ingrese el límite de caracteres por palabra: "
continueMessage: .asciiz "\n Presione una tecla para continuar... "
numberOfWords: .asciiz "\n El número de palabras es: "
numberOfWordsMore: .asciiz "\n El número de palabras con más de "
numberOfWordsMoreCont: .asciiz " caracteres es: "
pedirArchivo: .asciiz "\n Ingrese la dirección absoluta del archivo a abrir:\n"
sinespacioMessage: .asciiz "Archivo creado con exito!\n"


#Title
Maintext:       .asciiz "\n\n\n______-----  PROYECTO ORGANIZACIÓN  -----______\n\n\n Ingresar nombre del archivo (ej: archivo.txt): \n\n"
Menutext:       .asciiz	"\n\n\n______-----      MENU     -----______\n\n1. Estadistica.  \n2. Generar Archivo sin espacios entre palabras.  \n3. Generar Archivo al revés.  \n4. Cargar de nuevo Archivo.  \n5. Acerca de...\n6. Salir\n"
TitleOp1text:	.asciiz "\n\n\n______-----  ESTADISTICA  -----______\n\n"
TitleOp2text:	.asciiz "\n\n\n______-----  ARCHIVO SIN ESPACIOS  -----______\n\n"
TitleOp3text:	.asciiz "\n\n\n______-----  ARCHIVO AL REVES  -----______\n\n"
TitleOp5text:	.asciiz "\n\n\n______----- Organización y Arquitectura de Computadores -----______\n\t\tProyecto del Primer Parcial\n\n\tDesarrolladores: \n\t\tLeonardo Eras Delgado\n\t\tJuan Garcia Cedeno\n\t\tVanessa Robles SolÃ­s\n\n"

cons1:  .word 32	# Caracter de espacio
cons2:  .word 13	# Caracter: Carriage Return
spaces: .asciiz ""

.text
#---------------------CONSIDERACIONES--------------------------
# $s0 = Dirección base del buffer en memoria
# $s1 = Número total de caracteres leidos
#--------------------------------------------------------------



# Subrutine: main (Inicio del Programa)
main:
	jal	mainMenu
	j 	exit    

# Subrutine: mainMenu (Menu Principal)
mainMenu:
	addi $sp, $sp, -4	#Copia de seguridad de la direcciÃ³n de la funciÃ³n que llama
	sw $ra, 0($sp)
	
ask:	
	#Iniciando temporales en 0 para volver a leer archivo en caso de error				
	add $t0, $zero, $zero	
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
	add $t5, $zero, $zero
	
	li $v0, 4		
	la $a0,	pedirArchivo	#Mensaje pedir archivo
	syscall

	li $v0, 8 		#Pedir archivo
        la $a0, buffer		#Guarda ubicacion de archivo en memoria
        li $a1, 255 		#Espacio maximo de nombre de archivo permitido
        syscall
        
        la $t0, buffer
        la $t1, file
        add $t2, $t0, $zero
        add $t3, $t1, $zero
        addi $t4, $t4, 10
clean:	
	lbu $t5, 0($t2)
	beq $t5, $t4, continue
	sb $t5, 0($t3)
	addi $t2, $t2, 1
	addi $t3, $t3, 1
	j clean

continue:
        #Revisa si existe el archivo ingresado
	li $v0, 13		
	la $a0, file
	li $a1, 0			#Modo lectura
	li $a2, 0
	syscall
	
	add $s0, $v0, $zero		#Descriptor de archivo
	slt $t0, $v0, $zero		#Si no encuentra el archivo, vuelve a preguntar por archivo
	bne $t0, $zero, ask
	
	#El archivo existe! Copiar datos a memoria
	#Lectura del archvo
	li $v0, 14
	add $a0, $s0, $zero
	la $a1, spaces
	li $a2, 10000
	syscall

	add $a0, $s0, $zero
	li $v0, 16
	syscall			#Cierra "Texto.txt"
	
	add $s0, $zero, $zero	#Numero de caracteres
	add $s1, $a1, $zero	#Base del buffer de archivo
	add $t0, $s1, $zero	#Para recorrer el buffer
numcaracter:
	lbu $t1, 0($t0)		#$t1 = $s0[$t0]
	beq $t1, $zero, Bucle	#Si $t1 = '\0' terminar de contar
	addi $t0, $t0, 1	#$t0 = $t0 + 1
	addi $s0, $s0, 1	#$s0 = $s0 + 1
	j numcaracter
	
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
		j open
	Sin_Espacios:
		li $v0, 4	# Se carga el numero 4 para indicar que la funcion SYSCALL va a imprimir un texto.
		la $a0, TitleOp2text
		syscall
		jal sinespacio
		la $a0, sinespacioMessage
		syscall
		li $v0, 4
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
		j main
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
	
# Variables utilizadas para contar el número de palabras	
open:	addi $sp, $sp, -20 	# Separo en el Stack de la memoria 20 bytes
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp)
	sw $s5, 4($sp)
	sw $s6, 0($sp)
	li $v0, 4		# Se carga el numero 4 para indicar que la funcion SYSCALL va a imprimir un texto.
	la $a0, limitText
	syscall
	li $v0, 5		# Constante para leer un entero
	syscall
	addi $s2, $v0, 1	# $s2 contiene el limite de caracteres provistos por el ususario, +1 para futuras comparaciones 
	addi $s3,$0,0		# Iterador a utilizar
	addi $s4,$0,1		# Contador de palabras
	addi $s5,$0,0		# Contador de caracteres por palabra
	addi $s6,$0,0		# Contador de palabras con más de "n" caracteres
#-----------------------------------------------	
	
loop:	lw $t2, cons1		# Cargo el valor de 32 en la variable temporal $t2
	lw $t3, cons2		# Cargo el valor de 13 en la variable temporal $t3
	slt $t0, $s3, $s0  	# Verifico si llege al último caracter
	beq $t0,$0,print	# Verifico si ya leí todos los caracteres
	add $t1, $s3, $s1	# Sumo mi iterador a la direccion base del string que contiene el archivo
	lb $t0, 0($t1)		# Cargo el i-esimo byte	en $t0
	addi $s3, $s3, 1	# Incremento el iterador	
	beq $t0, $t2, Up	# Verifico si el caracter leido es un espacio	
	beq $t0, $t3, Up	# Verifico si el catacter leido es un salto de linea
	beq $t0, $0, esp	# Verifico si es un EOF
	li $t2, 46		# Verifico si el caracter leido es un "."
	beq $t0, $t2, esp	
	li $t2, 44		# Verifico si el caracter leido es un ","
	beq $t0, $t2, esp
	li $t2, 58		# Verifico si el caracter leido es un ":"
	beq $t0, $t2, esp
	li $t2, 59		# Verifico si el caracter leido es un ";"
	beq $t0, $t2, esp	
	li $t2, 63		# Verifico si el caracter leido es un "?"		
	beq $t0, $t2, esp
	addi $s5, $s5, 1	# Aumento, el contador de caracteres por palabra, en 1
	j loop					

# Subrutine:	
print: 	li $v0, 4		# Constante para imprimir strings	
	la $a0, numberOfWords
	syscall
	li $v0,1		# Constante para imprimir enteros	
	add $a0, $s4,$0		# $s4 contiene el número total de palabras encontradas
	syscall	
	li $v0, 4		# Constante para imprimir strings	
	la $a0, numberOfWordsMore
	syscall
	li $v0,1
	addi $s2, $s2, -1		# Constante para imprimir enteros	
	add $a0, $s2,$0		# $s2 contiene el número total de palabras encontradas con más de n caracteres
	syscall	
	li $v0, 4
	la $a0, numberOfWordsMoreCont
	syscall
	li $v0,1		# Constante para imprimir enteros	
	add $a0, $s6,$0		# $s6 contiene el número total de palabras encontradas con más de n caracteres
	syscall	
	lw $s6, 0($sp)		# Restauro los registros utilizados a su valor previo al llamado de mi función
	lw $s5, 4($sp)
	lw $s4, 8($sp)	
	lw $s3, 12($sp)
	lw $s2, 16($sp)
	addi $sp, $sp, 20	# Restauro la dirección base del puntero
	j Bucle	
	
exit: 	li $v0, 10		# Constante para terminar el programa
	syscall				

Up: 	lw $t2, cons1
	lw $t3, cons2
	add $t1, $s3, $s1	# Sumo mi iterador a la direccion base del string que contiene el archivo
	lb $t0, 0($t1)		# Cargo el i-esimo byte	en $t0
	beq $t0, $t2, loop	# Verifico si el próximo catacter leido es un salto de linea
	beq $t0, $t3, loop 	# Verifico si el próximo caracter leido es un espacio	
	beq $t0, $0,  esp	# Verifico si es un EOF
	addi $s4, $s4, 1	# Aumenta el contador de palabras en 1
	slt $t5, $s5,$s2  	# Verifico si excedo el número de caracteres por palabra
	beq $t5, $0, found 	# Branch a Found si es que mi palabra tiene más de "n" caracteres
	addi $s5, $0, 0		# Reseteo el contador de caracteres a 0
	j loop					

found:	addi $s6, $s6,1		# Sumo el contador de palabras con más de n caracteres en 1
	addi $s5, $0, 0		# Reinicio el contador de caracteres por palabra
	j loop
	
esp:	slt $t5, $s5,$s2  	# Verifico si excedo el número de caracteres por palabra
	beq $t5, $0, found 
	addi $s5, $0, 0		# Reseteo el contador de caracteres por palabra
	j loop
	
#Subrutine Sinespacio:
sinespacio:
	addi $sp, $sp, -12
	sw $v0, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	add $s1, $a1, $zero		#Copia de buffer de archivo leido para usar en esta funcion
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	
	#Abre archivo de escritura
	li $v0, 13
	la $a0, fwrite
	li $a1, 1
	li $a2, 0
	syscall
	
	add $s0, $v0, $zero		#Descriptor de "sinespacio.txt"
	
	#Variables necesarias para escribir
	addi $t2, $t2, 32		#Espacio en blanco a eliminar
	addi $t3, $t3, 10		#Salto de linea a eliminar
	add $t0, $s1, $zero		
	
	add $a0, $s0, $zero		#Descriptor de "sinespacio.txt" copiado a $a0
escritura:				#Escritura en archivo caracter a caracter
	li $v0, 15
	la $a1, 0($t0)			#Direccion del buffer
	li $a2, 1			#Longitud a escribir (1 caracter a la vez)
	lbu $t1, 0($t0)			#t1 = buffer[$t0]. Lo copia para luego comparar con espacio en blanco y salto de linea
	addi $t0, $t0, 1		#$t0++
	beq $t1, $t2, escritura		#Si el caracter leido es un espacio en blanco saltar
	beq $t1, $t3, escritura		#Si el caracter leido es un salto de linea saltar
	syscall				#Escribe en el archivo el caracter leido
	bne $t1, $zero, escritura	#Termina sinespacio cuando se halla al caracter nulo
	
	#Cerrando archivo escritura
	add $a0, $s0, $zero
	li $v0, 16
	syscall			#Cierra "sinespacio.txt"

	#Return to caller
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $v0, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra
		

