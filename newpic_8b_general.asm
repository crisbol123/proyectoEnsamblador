List	p=16F877	;Tipo de procesador
include	"P16F877.INC"	;Incluye el fichero P16F877.INC que contiene la definición con los nombres 
			;de los registros internos
			
CONTADOR1   equ 0x23 ; Primer contador para los pasajeros.
CONTADOR2   equ 0x21 ; Segundo contador para ver cuantos cambios tiene los leds donde suben pasajeros.
CONTADOR3   equ 0x22 ; Tercer contador para ver cuantos cambios tiene los leds donde bajan pasajeros.
		     
org		0x00 ;Dirección donde inicial el microcontrolador
goto		Inicio ;Se dirige a la etiqueta Inicio.
org		0x05		

Inicio		bsf	  STATUS,5 ; Va al banco 1
		movlw     0x00
		movwf     TRISA  ; Configura todos los bits del PORTA como salida
		movwf     TRISB	 ; Configura todos los bits del PORTB como salida
		movwf     TRISC	 ; Configura todos los bits del PORTCcomo salida
		movlw	  0xFF 
		movwf	  TRISD  ; Configura todos los bits del PORTD como entradas

		bcf	  STATUS,5 ; Vuelve al Banco 0.
		
		movlw	  0x00
		movwf	  PORTA ;Inicializa los bits de PORTA,PORTB,PORTC,PORTD en cero
		movwf	  PORTB
		movwf	  PORTC
		movwf     CONTADOR1
		movwf	  CONTADOR2
		movwf	  CONTADOR3
		movwf     CONTADOR1
		call	  Tabla1 ; BUSCA EL VALOR DEL DISPLAY EQUIVALENTE A DONDE SALTE CONTADOR1, EN ESTE CASO 0
		movwf	  PORTB
		
		

               	REINICIO
		
VerificaBTRD1	BTFSC     PORTD,0	    ; VERIFICA SE SE PRESIONO EL BOTON UBICADO EN RD0
		GOTO      VerificaBTRD2
		GOTO      SUBE_PASAJEROS
		
VerificaBTRD2	BTFSC     PORTD,1   ; VERIFICA SE SE PRESIONO EL BOTON UBICADO EN RD1
		GOTO      VerificaBTRD3
		GOTO      BAJA_PASAJEROS
		
VerificaBTRD3	BTFSC     PORTD,2   ; VERIFICA SE SE PRESIONO EL BOTON UBICADO EN RD2
		GOTO      VerificaBTRD1
		GOTO      REINICIO	
		
		
REINICIO  
		;Inicializa CONTADOR2, CONTADOR3, CONTADOR1 en cero Y CLAREA LOS PUERTOS RESPECTIVOS
		movlw 0x00
		movwf	  CONTADOR2
		movwf	  PORTA 
		movwf	  CONTADOR3
		movwf	  PORTC
		GOTO     VerificaBTRD1
		
SUBE_PASAJEROS	
		btfss	  PORTD, 0  ; Verifica si el botón de ingreso de pasajeros se dejo de presionar
		goto	  SUBE_PASAJEROS
		
		MOVLW     0x09   ;VERIFICA QUE NO SE HAYA AUMENTADO MAS DE 9 PASAJEROS   
		SUBWF     CONTADOR1,0
		BTFSC     STATUS,2
		GOTO      VerificaBTRD1
		
		MOVLW     d'60'       ; VERIFICA QUE EL TOTAL DE INGRESADOS NO SEA MAYOR A 60
		SUBWF     CONTADOR2,0
		BTFSC     STATUS,2
		GOTO      VerificaBTRD1
		
		INCF	  CONTADOR2,1 ; INCREMENTA CONTADOR DE PASAJEROS INGRESADOS EN 1
		MOVF CONTADOR2, 0
		MOVWF     PORTA
		
		
		
		INCF CONTADOR1, 1 ; INCREMENTA EL CONTADOR DE PASAJEROS EN EL VEHICULO EN 1
	        MOVF CONTADOR1, 0
		CALL	  Tabla1 ; BUSCA EL VALOR DEL DISPLAY EQUIVALENTE A DONDE SALTE CONTADOR1
		MOVWF     PORTB
		GOTO      VerificaBTRD1; Vuelve a verificar BOTONES.

BAJA_PASAJEROS
		btfss	  PORTD, 1  ; Verifica si el botón de salida de pasajeros se dejo de presionar
		goto	  BAJA_PASAJEROS
		
		MOVLW     0x00        ; VERIFICA QUE NO SE HAYA DISMINUIDO MÁS DE 0 PASAJEROS
		SUBWF     CONTADOR1,0
		BTFSC     STATUS,2
		GOTO      VerificaBTRD1
		
		MOVLW     d'60'        ; VERIFICA QUE NO SE HAYA PASADO DE 60 LA CANTIDAD DE PASAJEROS QUE SALIERON
		SUBWF     CONTADOR3,0
		BTFSC     STATUS,2
		GOTO      VerificaBTRD1
		
		INCF	  CONTADOR3,1 ; INCRMEENTA EN 1 EL CONTADOR DE PASAJEROS QUE SALIERON
		MOVF CONTADOR3, 0
		MOVWF     PORTC
		
		
		
		
		DECF	  CONTADOR1,1 ; DECREMENTA EN EL CONTADOR DE PASAJEROS EN EL VEHICULO
		MOVF CONTADOR1, 0
		CALL	  Tabla1 ; BUSCA EL VALOR DEL DISPLAY EQUIVALENTE A DONDE SALTE CONTADOR1
		MOVWF     PORTB
		GOTO      VerificaBTRD1; Vuelve a verificar BOTONES.

		
Tabla1	addwf    PCL, f      ; Tabla de datos para el display de 7 segmentos
	retlw    b'00111111'                            
	retlw    b'00000110'             
	retlw    b'01011011'     
	retlw    b'01001111'   
	retlw    b'01100110'
	retlw    b'01101101'    ; 5
	retlw    b'01111101'    ; 6
	retlw    b'00000111'    ; 7
	retlw    b'01111111'    ; 8
	retlw    b'01101111'    ; 9
	return

end