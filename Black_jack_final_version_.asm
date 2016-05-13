#Jorge Garcia Juarez.
#Jesus Barrientos Sevilla.
#Manuel Fidalgo Fierro.

.data
cadJugador1: 	.asciiz "\n\nTurno del jugador 1:\n"
cadJugador2: 	.asciiz "\n\nTurno del jugador 2:\n"
cadBien: 	.asciiz "Bienvenidos al Blackjack, esperamos que disfruten de la partida."
cadMostrar: 	.asciiz "\nCarta/s obtenidas: "
cadValor: 	.asciiz "\nLa suma de las cartas es: "
cadFin1:	.asciiz "\nJugador 1 ha perdido la partida."
cadFin2:	.asciiz "\nJugador 2 ha perdido la partida."
cadPregunta: 	.asciiz "\n¿Desea pedir otra carta o desea plantarse? [1 Otra carta][2 Plantarse] "
cadGana1: 	.asciiz "\nJugador 1 ha ganado la partida."
cadGana2: 	.asciiz "\nJugador 2 ha ganado la partida."
cadEmpate:	.asciiz "\nJugador 1 y Jugador 2 han obtenido los mismos puntos."
coma:		.ascii 	","


		.align 2
cartas_jugador1:.space 40
cartas_jugador2:.space 40
	
.globl main
.text

main:
li $v0, 4		 #Cadena de Bienvenida
la $a0, cadBien
syscall

li $v0, 4		 #Cadena del Jugador 1
la $a0, cadJugador1
syscall


la $a1, cartas_jugador1  #Inicializamos el registro a1 que usara la funcion genCartas
li $a0, 0		 #Cero cartas generadas en un inicio

jal genCartas		 #Generara una carta que se añadira al array


move $a0, $v0 		 #Pasamos el numero de cartas que han sido generadas en el turno anterior al registro a0
move $a1, $v1		 #En a1 hay que pasarle el lugar donde hay que guardar las cartas

Jugador_1:
beq $a0, 1 no_inicializar
move $a0, $s0		 #Pasamos los parametros a introducir nuevamente
move $a1, $s1		
no_inicializar:

jal genCartas		 #Volvemos a llamar a genCartas para que genere la segunda carta y cada una de las cartas que pida el jugador

move $s0, $v0
move $s1, $v1

move $a1, $s0 		 #Pasamos el nuero de cartas almacenadas al resgsitro a1 para meterselos a la funcion mostrar cartas y calular valor
la $a0, coma
la $a2, cartas_jugador1
la $a3, cadMostrar

jal mostrarCartas

la $a0, cartas_jugador1

jal calcularValor

bgt $v0, 21 finJugador1 #Si se pasa el jugador pierde automaticamente
move $s7, $v0		#Tenemos el valor acumulado del jugador 1

move $t0, $v0 		#Imprime la cadena "la suma de sus cartas es:"
li $v0, 4 
la $a0, cadValor
syscall

move $a0, $t0 		#Imprimimos el valor de las cartas sumadas
li $v0, 1
syscall

la $a0, cadPregunta

jal preguntarJugador

move $t0, $v0
li $t1, 1
li $t2, 2

beq $t0, $t1, Jugador_1	#Si es un uno se vuelve a repetir Jugador 1, sino pasa a Jugador 

##Jugador 2


li $s0, 0		#Liberamos estros registros para que los use el Jugador 2 y no haya bugs
li $s1, 0		
li $v0, 4	
	
la $a0, cadJugador2	#Imprimimos la cadena que indica el turno del Jugador 2
li $v0 4
syscall
la $a1, cartas_jugador2	#Inicializamos el registro $a1 que usara la funcion genCartas
li $a0, 0

jal genCartas		#Generara una carta que se añadira al array

move $a0, $v0 		#Pasamos el numero de cartas que han sido generadas en el turno anterior al registro a0
move $a1, $v1		#En a1 hay que pasarle el lugar donde hay que guardar las cartas

Jugador_2:

beq $a0, 1, no_inicializar2
move $a0, $s0		 #Pasamos los parametros a introducir nuevamente solo cuando el jugador ya ha pedido otra carta
move $a1, $s1		
no_inicializar2:

jal genCartas		 #Volvemos a llamar a genCartas para que genere la segunda carta y cada una de las cartas que pida el jugador

move $s0, $v0
move $s1, $v1

move $a1, $s0 		 #Pasamos el nuero de cartas almacenadas al resgsitro a1 para meterselos a la funcion mostrar cartas y calular valor
la $a0, coma
la $a2, cartas_jugador2
la $a3, cadMostrar

jal mostrarCartas

la $a0, cartas_jugador2

jal calcularValor

bgt $v0, 21, finJugador2 	#Si se pasa el jugador pierde automaticamente
move $s6, $v0	       		#Tenemos el valor acumulado del jugador 2

move $t0, $v0 			#Imprime la cadena "la suma de sus cartas es:"
li $v0, 4 
la $a0, cadValor
syscall

move $a0, $t0 		#Imprimimos el valor de las cartas sumadas
li $v0, 1
syscall

la $a0, cadPregunta

jal preguntarJugador

move $t0, $v0
li $t1, 1
li $t2, 2

beq $t0, $t1, Jugador_2
beq $t0, $t2, Final_partida

Final_partida:
beq $s7, $s6, empatan_
bgt $s7, $s6, gana1_
blt $s7, $s6, gana2_

li $v0, 10
syscall


##Casos posibles despues de que jugador 2 se haya plantado


finJugador1:
li $v0, 4
la $a0, cadFin1
syscall
li $v0, 10
syscall

finJugador2:
li $v0, 4
la $a0, cadFin2
syscall
li $v0, 10
syscall

gana1_:
li $v0, 4
la $a0, cadGana1
syscall
li $v0, 10
syscall

gana2_:
li $v0, 4
la $a0, cadGana2
syscall
li $v0, 10
syscall

empatan_:
li $v0, 4
la $a0, cadEmpate
syscall
li $v0, 10
syscall


##FUNCIONES

genCartas:
move $t0, $a0 		#Tamaño del array o cartas que llevamos generadas
move $t1, $a1 		#Lugar donde hay que guardar las cartas
li $a1, 13		#Indicamos que el número aleatorio está comprendido entre 0 y 12
li $v0, 42
syscall			
addi $a0, $a0, 1	#Sumamos uno para que carta€[1,13];

addi $t0, $t0, 1	 #Añadimos 1 al numero de cartas que habia generada anteriormente

sw $a0, ($t1) 		 #Almacenamos la carta generada en el array
addi $t1, $t1, 4	 #Acualizamos le puntero
move $v0, $t0		 #Sacamos por v0 el numero de cartas que tenemos en el array
move $v1, $t1 		 #Sacamos por v1 la direcion de memoria donde ira la siguente carta
jr $ra	

##
		
mostrarCartas:
move $t0, $a0 		#Liberamos los registros
move $t1, $a1 
move $t2, $a2 		#Toma por $a3 es puntero que apunta a la cadena "Sus cartas son: "
li $t5, 0 		
	
li $v0, 4 		#Imrimimos la cadena de "Sus cartas son: "
move $a0, $a3 		
syscall 		

return:
li $v0, 1 		#cargamos el comando de impresion
lw $a0, ($t2) 		#cargamos la direcion de memoria que queremos imprimir
syscall
addi $t2, $t2, 4 	#actualizamos el puntero
addi $t5, $t5, 1 	#contador

beq $t1, $t5, endloop

li $v0, 4
move $a0, $t0 		#Cargamos en $ao la coma para imprimirla
syscall

j return

endloop:
jr $ra

##

calcularValor:
move $t0, $a0		#Liberacion de registros
move $t1, $a1		#numero de cartas
li $t3, 0
li $t5, 0
li $t4, 0

#Recorremos el array tantas veces como cartas generadas haya
li $t3, 0
li $t5, 0
looping_:
lw $t3, ($t0) 			#Cargamos el elemento del array apuntado por $t0
addi $t9, $t9, 1		#Contador de la posicion de la carta que hemos sacado del array para que si el primero es un as darle el valor 11
blt $t3, 11, no_cambiar_valor 	#Cambiamos los valores de las figuras por 10
li $t3, 10
no_cambiar_valor:		#Algoritmo para los valores del AS
bne $t3, 1, pasar_
#bne $t9, 1 pasar_
bgt $t4, 10, pasar_
li $t3, 11

pasar_:
addi $t0, $t0, 4 	#Le sumamos 4 al puntero para que pase a la siguente direcion de array	
add $t4, $t4, $t3	#Vamos sumandos valores en $t4
addi $t5, $t5 1 	#Contador de veces que se carga una carta
	
bne $t1, $t5 looping_

move $v0, $t4		#Movemos a $v0 el resultado de la suma de las cartas antes de salir de la función

li $t9, 0
jr $ra

##

preguntarJugador:
li $t1, 1
li $t2, 2
li $t0, 0
li $v0, 0

return_2:
li $v0, 4		#Imprime la cadena
syscall
li $v0, 5 		#Pide un entero
syscall
move $t0, $v0
beq $t0, $t1 endloop_2 	 #Si el entero no es ni uno ni dos vuelve a pedir otro hasta que se meta un uno o un dos;
beq $t0, $t2 endloop_2
j return_2

endloop_2:
move $v0, $t0 		#Pasamos el registro a $v0 para devolcerlo 
jr $ra






