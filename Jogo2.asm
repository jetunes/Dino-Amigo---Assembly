INCLUDE Irvine32.inc
															;Jogo Dino amigo
.data
outHandle    DWORD ? 										; Definições do tamanho da tela
scrSize COORD <85,50> 

Ctrl BYTE 0
Ctrl2 BYTE 0
Tempo DWORD ?
Pont WORD 0
Atraso DWORD 500						

Pontuacao BYTE "Potuacao: ", 0								; Texto da pontuação a ser escrito na tela

Opcoes BYTE "				  1 - COMECAR",0ah, 0dh			; Textos da tela inicial
        BYTE "				ESC - SAIR" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "	AJUDA:	Use as SETAS par CIMA e para BAIXO para desviar dos Baloes", 0ah, 0dh
		BYTE "		para marcar o maior numero de pontos posivel, Boa Sorte :)",0
    	
Fila0 BYTE 0, 2, 0, 0, 0, 2, 0, 0							; Iniciando as tres linhas horizontais invisiveis do Jogo
Fila1 BYTE 1, 0, 0, 2, 0, 0, 0, 0
Fila2 BYTE 0, 2, 0, 0, 0, 2, 0, 0

ArvoreX BYTE 4												; Declarando o tamanho dos eixos dos obstaculos
ArvoreY BYTE 4
Arvore BYTE  32, 254, 254 ,254, 254, 254, 254, 254,  32,	; Desenhando os obstaculos com caracteres
		  254, 254, 254, 254, 254, 254, 254, 254, 254,
		  254, 254, 254, 254, 254, 254, 254, 254, 254,
		   32, 254,  32, 254,  32, 254,  32, 254,  32,
		   32,  32, 254, 254, 254, 254, 254,  32,  32 

DinoX BYTE 4												; Declarando o tamanho dos eixos personagem
DinoY BYTE 10
Dino BYTE 254, 254,  32 ,254, 254, 254,  32,  32, 32,		; Desenhando o personagem com caracteres
			254, 254,  32, 254,  32, 254,  32, 254, 32,
			 32, 254, 254, 254, 254, 254, 254, 254, 32,
			 32,  32,  32,  32,  32, 254,  32, 254, 32

GameOver BYTE "		 _____                          ____                  ",0ah, 0dh     	; Textos de Fim de jogo           
		  BYTE "		/ ____|                        / __ \                 ",0ah, 0dh
		  BYTE "		| |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __  ",0ah, 0dh
	      BYTE "		| | |_ |/ _` | '_ ` _ \ / _ \ | |  | \ \ / / _ \ '__| ",0ah, 0dh
		  BYTE "		| |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |    ",0ah, 0dh
		  BYTE "		\______|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|    ",0

Dinossauro BYTE "			   	             _              ",0ah, 0dh						; Texto com o nome do jogo impresso no inicio
       BYTE "			       /\           (_)			    ",0ah, 0dh
       BYTE "			      /  \__   ___  ___  _ __	",0ah, 0dh
       BYTE "			     / /\ \ \ / / |/ _ \| '_ \	",0ah, 0dh
       BYTE "			    / ____ \ V /| | (_) | | | |	",0ah, 0dh
       BYTE "			   /_/    \_\_/ |_|\___/|_| |_|	",0

.code

HUD PROC
						
							; IMPRIMINDO O QUADRO BRANCO 
							; que fica envolta da tela inicial
	mov  eax, white		; Guarda a cor branca no registrador eax
	call SetTextColor

	mov dl, 1			; movendo a posiçaõ 1 para o reg de colunas
	mov dh, 1			; movendo a posição 1 para o reg de linhas
	call GotoXY			; chama o cursor para a linha e coluna acima

	mov ecx, 80			; contador de loop iniciado com 80
	mov al, 220			; conatdor auxiliar de impressão iniciado com char 220 que é um quadradinho horizontal
	
	L1:
	  call WriteChar	; escreve um quadrado branco
	  inc dl 			; incrementa dl para continuar desenhando o quadrado na proxima posição
	  call GotoXY		; chama o cursor para a linha e coluna acima
	Loop L1				; executa 80 vezes

	mov dl, 2			; definindo onde a proxima coisa sera impressa
	mov dh, 21			; na posição acima do texto de ajuda
	call GotoXY			; atualiza o cursor para essa posição

	mov ecx, 78			; contador de loop atualizado com 78 uma vez que a tela tem tamanho 80,
						;e na primeira e na ultima posições seram impressos o caracter de quadrado vertical
	
	L2:
	  call WriteChar	; imprime a faixa acima do texto de ajuda
	  inc dl  			; incrementando o contador de coluna dl a cada loop
	  call GotoXY		; atualiza o cursor
	Loop L2

	mov dl, 2			; definindo onde a proxima coisa sera impressa		 
	mov dh, 24			; na posição abaixo do texto de ajuda, na ultima linha
	call GotoXY			; atualiza o cursor para essa posição

	mov ecx, 78			; contador de loop atualizado com 78 uma vez que a tela tem tamanho 80,
						; e na primeira e na ultima posições serao impressos o caracter de quadrado vertical
	
	L3:
	  call WriteChar	; imprime a faixa abaixo do texto de ajuda
	  inc dl 			; incrementando o contador de coluna dl a cada loop
	  call GotoXY		; atualiza o cursor
	Loop L3 

	mov dl, 1			; atualiza o registrador de colunas para a primeira coluna
	mov dh, 2			; atualiza o registrador de linhas para a segunda linha 
	call GotoXY			; atualiza o cursor para essa posição

	mov ecx, 23			; contador de loop atualizado com o valor 23
	mov al, 219			; auxiliar de impressão atualizado com o quadrado vertical

	L4:
	  call WriteChar	; imprime o quadrado vertical na posição 2x1
	  add dl, 79 		; adiciona 79 ao registrador de colunas, para imprimir a mesma coisa do outro lado do quadrado  
	  call GotoXY 		; atualiza o cursor
	  call WriteChar	; imprime novamente o quadrado do outro lado do quadro
	  inc dh 			; pula para a próxima linha
	  sub dl, 79		; subtrai 79 do registrador de colunas, para voltar para a primeira posição
	  call GotoXY		; atualiza cursor
	Loop L4				; executa 23 vezes pois essa é a quantia de linhas a serem impressas

	ret

HUD ENDP

Atualiza_Pont PROC

	.IF Ctrl == 0
		add Pont, 5
		mov dl, 60
		mov dh, 23
		call GotoXY
		push eax
			mov eax, white
			call SetTextColor
			movzx eax, Pont
			call WriteDec
		pop eax
	.ENDIF
	
	ret

Atualiza_Pont ENDP

Pontu PROC
	mov eax, white
	call SetTextColor
	mov dl, 50
	mov dh, 23
	call GotoXY
	mov edx, OFFSET Pontuacao
    
call WriteString 

	ret

Pontu ENDP

Atraso_Ctrl PROC
		movzx eax, Pont
		
		.IF eax > 50 && Ctrl2 == 0
			sub Atraso, 50
			inc Ctrl2
		
		.ELSEIF eax > 150 && Ctrl2 == 1
			sub Atraso, 50
			inc Ctrl2

		.ELSEIF eax > 300 && Ctrl2 == 2
			sub Atraso, 50
			inc Ctrl2
		
		.ELSEIF eax > 450 && Ctrl2 == 3
			sub Atraso, 50
			inc Ctrl2
		
		.ELSEIF eax > 600 && Ctrl2 == 4
			sub Atraso, 50
			inc Ctrl2
		.ENDIF
	
	ret

Atraso_Ctrl ENDP
									; GERANDO ALEATORIAMENTE A FILA DE ARVORES
 									; O jogo possui 3 linhas horizontais onde os objetos sao plotados,
 									; e 7 posições horizontais na fila 

Gera_Arvore PROC
	call Randomize					; função para usar de aleatoriedade
	mov  eax, 3 					; 4 possibilidades diferentes de combinações de arvores
call RandomRange 					; eax começa valendo 3, para imprimir primeiro um espaço vazio

	.IF Ctrl == 1					; alternando entre um obstáculo e um espaço vazio
		mov eax, 3					; Ctrl == 1 -> nenhum obstaculo plotado

	.ELSEIF Ctrl == 0				; Ctrl == 0 -> uma das combinações é plotada 
		mov Ctrl, 1					; depois de plotar um dos obstaculos, obrigatoriamente existe um espaço vazio
	.ENDIF
									; Adiciona uma arvore no inicio da tela
 									; o simbolo 2 indica o inicio de uma cadeia de caracteres
    .IF eax == 0
	    mov Fila0[7], 0
		mov Fila1[7], 2
		mov Fila2[7], 2
	
	.ELSEIF eax == 1				; Um obstáculo na primeira linha e outro na ultima
		mov Fila0[7], 2
		mov Fila1[7], 0
		mov Fila2[7], 2
	
	.ELSEIF eax == 2				; Obstáculos nas duas primeiras linhas
		mov Fila0[7], 2
		mov Fila1[7], 2
		mov Fila2[7], 0
	
	.ELSEIF eax == 3				; Espaço vazio, nenhum obstáculo plotado
		mov Fila0[7], 0
		mov Fila1[7], 0
		mov Fila2[7], 0
		mov Ctrl, 0					; indica que na proxima plotagem, 2 obstaculos apareceram
	.ENDIF

	ret		

Gera_Arvore ENDP
									; POSIÇÃO DO PERSONAGEM 
Move_Dino PROC
									; O personagem pode se posicionar em 3 posições diferentes no eixo y 
	.IF DinoY == 4 && Fila0[0] == 0	; Na primeira posição, encima na tela
		mov Fila0[0], 1
		mov Fila1[0], 0
		mov Fila2[0], 0
	
	.ELSEIF DinoY == 10 && Fila1[0] == 0 ; Na segunda posição, no meio da tela
	    mov Fila0[0], 0
		mov Fila1[0], 1
		mov Fila2[0], 0

	.ELSEIF DinoY == 16 && Fila2[0] == 0 ; Na terceira posição, embaixo da tela
		mov Fila0[0], 0
		mov Fila1[0], 0
		mov Fila2[0], 1

	.ELSE
		call colisao 					; Se o personagem nao estiver em nenhuma dessas posições, significa que ele colidiu com a parede,
										; então o tratamento de colisao é chamado

	.ENDIF

	ret

Move_Dino ENDP

										; POSIÇÃO DOS OBSTACULOS
Move_Arvore PROC    

	call Atualiza_Pont					
	mov ecx, 8
	mov ebx, 0	

L0:	
	mov al, Fila0[ebx + 1]
	
	.IF Fila0[ebx] == 1 && al == 2
	     call Colisao

	.ELSEIF Fila0[ebx] != 1
		mov Fila0[ebx], al	

	.ENDIF	
	inc ebx

LOOP L0
	mov ecx, 8
	mov ebx, 0	

L1:	
	mov al, Fila1[ebx + 1]
    
	.IF Fila1[ebx] == 1 && al == 2
	    call Colisao

	.ELSEIF Fila1[ebx] != 1
		mov Fila1[ebx], al	

	.ENDIF	

	inc ebx

LOOP L1

	mov ecx, 8
	mov ebx, 0	

L2:	
	mov al, Fila2[ebx + 1]

    .IF Fila2[ebx] == 1 && al == 2
	     call colisao	

	.ELSEIF Fila2[ebx] != 1
		mov Fila2[ebx], al

	.ENDIF		

	inc ebx

LOOP L2

	call Gera_Arvore
	call Escreve_Fila
	ret

Move_Arvore ENDP

Escreve_Fila PROC
	mov ecx, 7
	mov ebx, 0

L0:

	push ecx 						; Salva o valor de ecx em uma pilha, para podermos usa-lo
	mov al, Fila0[ebx] 				; Salva o conteudo de fila0[X] no registrador auxiliar 
	.IF al == 2						; Se esse valor == 2, podemos desenhar o obstaculo
		call Desenha_Arvore 		; pois o 2 simboliza a presença de caracteres
	.ELSEIF al == 0					; Se esse valor == 0, apagamos o que estiver escrito 
		call Apaga_Arvore			; pois o 0 simboliza a ausencia de caracteres
	
	.ELSEIF al == 1 				; Se esse valor == 1, podemos desenhar o Personagem
		call Desenha_Dino 			
   .ENDIF 
	pop ecx 						; Desempilha ecx
	add ArvoreX, 11 
	inc ebx 						; Anda uma posição para frente com os obstaculos

LOOP L0
	mov ArvoreX, 4
	add ArvoreY, 6
	mov ecx, 7
	mov ebx, 0

L1:									; mesma coisa que o loop 0 para esse, mas para a segunda fila 
	push ecx
	mov al, Fila1[ebx]
	.IF al == 2
		call Desenha_Arvore
	.ELSEIF al == 0
		call Apaga_Arvore
	.ELSEIF al == 1
		call Desenha_Dino

	.ENDIF
	pop ecx		
	add ArvoreX, 11
	inc ebx

LOOP L1

	mov ArvoreX, 4
	add ArvoreY, 6
	mov ecx, 7
	mov ebx, 0

L2:								; mesma coisa que o loop 0 para esse, mas para a terceira fila
	push ecx
	mov al, Fila2[ebx]

	.IF al == 2
		call Desenha_Arvore

	.ELSEIF al == 0
		call Apaga_Arvore

	.ELSEIF al == 1
		call Desenha_Dino

	.ENDIF

	pop ecx		
	add ArvoreX, 11
	inc ebx

LOOP L2

	mov ArvoreX, 4
	mov ArvoreY, 4

	ret

Escreve_Fila ENDP
				
										; DESENHANDO O PERSONAGEM

Desenha_Dino PROC

	mov dl, DinoX 						; movendo o eixo X para o reg de colunas	
	mov dh, DinoY 						; movendo o eixo y para o reg de linhas
	call GotoXY 						; chama o cursor para a linha e coluna acima

	mov ecx, 4 							; contador do laço de repetição
	mov esi, OFFSET Dino 				; salvando os caracteres a serem impressos

Linha: 									; Printando as Linhas
	PUSH ecx 							; Empilha o valor inicial de ecx
	mov ecx, 9 							; Contador loop Linha = 9
	Coluna: 							; Printando as Colunas
		mov  eax,red  					; definindo a cor do personagem
		call SetTextColor 
		mov al, [ESI] 					
		call WriteChar 					; printa
		inc ESI 						; passa para a proxima posição

	LOOP Coluna 						; executa 9 vezes, que é a quantidade de caracter por linha 

	POP ecx 							; Desempilha ecx
	inc dh 								; Incrementa o registrador de linha
	call GotoXY	 

LOOP linha 								; executa 4 vezes, que é o numero de linhas que possui o personagem

	ret

Desenha_Dino ENDP

Desenha_Arvore PROC
	mov dl, ArvoreX 					; Salvando a posição atual
	mov dh, ArvoreY
	call GotoXY 						; atualizando o cursor


	mov esi, OFFSET Arvore 				; caracteres que compoe obstaculo
	mov ecx, 5							; contador de laços é igual ao quantidade de linhas que um obstaculo ocupa

Linha:
	push ecx 							; empilha ecx 
	mov ecx, 9							; contador de laços é igual a quantidade de caracteres que um obstaculo tem por linha
	Coluna:
		mov  eax,green					; definindo as cores do obstaculo
		call SetTextColor
		mov al, [ESI]
		call WriteChar					; imprimindo o caracter
		inc esi  						; passa para a proxima posição
	LOOP Coluna

	pop ecx 							; desempilha ecx, para imprimir para a linha debaixo
	inc dh 								; incrementa o registrador de linha
	call GotoXY

LOOP Linha

	ret

Desenha_Arvore ENDP

										; APAGANDO OBSTACULOS

Apaga_Arvore PROC
	mov dl, ArvoreX						; Salva a posição atual 
	mov dh, ArvoreY
	call GotoXY
	mov ecx, 5							; contador de loop é igual a quantidade de linhas que um obstaculo tem 
	mov al, 32							; auxiliar de impressão é atualizado com o caracter vazio
Linha:
	PUSH ecx 							; empilha ecx
	mov ecx, 9							; atualiza o contador de laços com a quantidade de caracteres que um obstaculo tem por linha
	Coluna:
		call WriteChar 					; imprime o caracter vazio
	LOOP Coluna
	POP ecx 							; desempilha ecx, para imprimir para a linha debaixo							
	inc dh 								; incrementa o registrador de linha
    call GotoXY

LOOP Linha

	ret

Apaga_Arvore ENDP

										; APAGANDO O PERSONAGEM 

Apaga_Dino PROC
	mov dl, DinoX
	mov dh, DinoY
	call GotoXY

	mov ecx, 5
	mov al, 32

Linha:
	PUSH ecx
	mov ecx, 9
	Coluna:
		call WriteChar
		LOOP Coluna

	POP ecx
	inc dh
    call GotoXY

LOOP Linha

	ret

Apaga_Dino ENDP



Colisao PROC
	call Clrscr
	mov dl, 1
	mov dh, 7
	call GotoXY
	mov  eax, red
	call SetTextColor
	mov edx, OFFSET GameOver
    call WriteString 
	call HUD
	call Pontu

	mov dl, 60 
	mov dh, 23
	call GotoXY
	mov  eax, white
	call SetTextColor
	movzx eax, Pont
	call WriteDec
	mov eax, 2000
	call delay
	exit

Colisao ENDP



main PROC	
    INVOKE GetStdHandle,STD_OUTPUT_HANDLE 
	mov outHandle, eax
	INVOKE SetConsoleScreenBufferSize, 
	outHandle,scrSize

	mov dl, 1
	mov dh, 8
	call GotoXY
	mov  eax, white
	call SetTextColor
	mov edx, OFFSET Dinossauro
    call WriteString
	mov dl, 1
	mov dh, 16
	call GotoXY
	mov edx, OFFSET Opcoes
    call WriteString	 
	call HUD	
	mov ecx, 0
Op:	
    mov  eax,50          
    call Delay        
	call ReadKey
	push edx 

	.IF al == 31h
		call Clrscr
		mov DinoX, 4
        mov DinoY, 10
		jmp Continua          	

	.ENDIF

	.IF ecx == 0 
		call Apaga_Dino
		mov DinoX, 3
		mov DinoY, 3

	.ELSEIF ecx == 67
		mov ecx, -1

	.ENDIF

	push ecx
		call Apaga_Dino
		inc DinoX
		call Desenha_Dino
		mov eax, 80
		call Delay
	pop ecx
	inc ecx

	pop edx
    cmp dx,VK_ESCAPE

 jne OP
 je Sair

 Continua:
	call HUD	
	call Pontu
	call Gera_Arvore
	call Escreve_Fila
	call GetMseconds
	mov Tempo,eax

Setas:	
    mov  eax,50          
    call Delay        
	call ReadKey        
	   	
    .IF ah == 48h && DinoY != 4		
		call Apaga_Dino
		sub DinoY, 6
		call Move_Dino
		call Desenha_Dino		

	.ELSEIF ah == 50h && DinoY != 16
	    call Apaga_Dino
		add DinoY, 6
		call Move_Dino
		call Desenha_Dino	          	

	.ENDIF

	call Atraso_Ctrl
	call GetMseconds
	sub eax, Tempo	

	.IF eax > Atraso
	   call Move_Arvore
	   call GetMseconds
	   mov Tempo, eax

	.ENDIF

    cmp dx,VK_ESCAPE

 jne Setas   		

 Sair:

	exit

main ENDP

END main