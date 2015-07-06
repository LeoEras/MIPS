.data 
buffer: .space 255			# "buffer" contendrÃ¡ la direcciÃ³n base al string del archivo
file: .space 255 			# DirecciÃ³n absoluta del archivo
fwrite:	.asciiz "sinespacio.txt"     	# Archivo que arroja la funcion definida sinespacio

#text messages
errortext:      .asciiz "Ha ingresado un valor no valido\n"
errorOpentext:  .asciiz "Error opening file!\n\n"
message2text:   .asciiz "\n \n Archivo generado con Exito! \n\n"
optionText: .asciiz "Por favor, escoja una opciÃ³n: "
limitText:	.asciiz "\n Limite de caracteres: "
continueMessage: .asciiz "Presione una tecla para continuar... "
numberOfWords: .asciiz "\n El número de palabras es: "
numberOfWordsMore: .asciiz "\n El número de palabras con más de n caracteres es: "
pedirArchivo: .asciiz "Ingrese nombre de archivo a abrir:\n"
sinespacioMessage: .asciiz "Archivo creado con exito!\n"


#Title
Maintext:       .asciiz "\n\n\n______-----  PROYECTO ORGANIZACIÃ“N  -----______\n\n\n Ingresar nombre del archivo (ej: archivo.txt): \n\n"
Menutext:       .asciiz	"\n\n\n______-----      MENU     -----______\n\n1. Estadistica.  \n2. Generar Archivo sin espacios entre palabras.  \n3. Generar Archivo al revÃ©s.  \n4. Cargar de nuevo Archivo.  \n5. Acerca de...\n6. Salir\n"
TitleOp1text:	.asciiz "\n\n\n______-----  ESTADISTICA  -----______\n\n"
TitleOp2text:	.asciiz "\n\n\n______-----  ARCHIVO SIN ESPACIOS  -----______\n\n"
TitleOp3text:	.asciiz "\n\n\n______-----  ARCHIVO AL REVES  -----______\n\n"
TitleOp5text:	.asciiz "\n\n\n______----- OrganizaciÃ³n y Arquitectura de Computadores -----______\n\t\tProyecto del Primer Parcial\n\n\tDesarrolladores: \n\t\tLeonardo Eras Delgado\n\t\tJuan Garcia Cedeno\n\t\tVanessa Robles SolÃ­s\n\n"

cons1:  .word 32	#Caracter de espacio
cons2:  .word 13
cons3:  .word 3
spaces: .asciiz ""

.text
#---------------------CONSIDERACIONES--------------------------
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
	
exit: 	li $v0, 10		# Constante para terminar el programa
	syscall			

