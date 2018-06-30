
		;musica
;include C:\LabArq2\Irvine32.inc
;includelib C:\LabArq2\Irvine32.lib			; biblioteca Irvine32
;include C:\LabArq2\Macros.inc				; biblioteca de macros
;includelib winmm.lib						; biblioteca do windows

;PlaySound PROTO, pszSound:PTR BYTE, hmod:DWORD, fdwSound:DWORD		; protótipo da função que toca sons

;SND_FILENAME equ 00020000h			; constante para tocar som a partir de um arquivo
;SND_LOOP equ 1h						; constante para tocar som em repetição
;SND_ASYNC equ 8h					; constante para tocar som imediatamente e seguir com o programa



INCLUDE Irvine32.inc
															;Jogo Dino amigo
.data
						;musica
;loser BYTE "C:\LabArq2\MASM\wrong.wav",0					; som de derrota
;winner BYTE "C:\LabArq2\MASM\right.wav",0					; som de vitória
;warning BYTE "C:\LabArq2\MASM\warning.wav",0				; som tela inicial
;stage BYTE "C:\LabArq2\MASM\stage.wav",0					; som tela do jogo
;obstaculo BYTE "C:\LabArq2\MASM\obstaculo.wav",0			; som tela do jogo



outHandle    DWORD ? 										; Definições do tamanho da tela
scrSize COORD <85,50> 

Ctrl BYTE 0
Ctrl2 BYTE 0
Tempo DWORD ?
Pont WORD 0
vidinha WORD 0
Atraso DWORD 500						

Pontuacao BYTE "Potuacao: ", 0								; Texto da pontuação a ser escrito na tela
Vida BYTE "Vidas: ", 0										; Texto das vidas

Opcoes BYTE "				  1 - COMECAR",0ah, 0dh			; Textos da tela inicial
        BYTE "				ESC - SAIR" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "	AJUDA:	Use as SETAS par CIMA e para BAIXO para desviar dos Baloes", 0ah, 0dh
		BYTE "		para marcar o maior numero de pontos posivel, Boa Sorte :)",0
    	
Fila0 BYTE 0, 0, 0, 0, 0, 0, 0, 0							; Iniciando as tres linhas horizontais invisiveis do Jogo
Fila1 BYTE 1, 0, 0, 0, 0, 0, 0, 0
Fila2 BYTE 0, 0, 0, 0, 0, 0, 0, 0

ArvoreX BYTE 4												; Declarando o tamanho dos eixos dos obstaculos
ArvoreY BYTE 4
Arvore BYTE  32, 254, 254 ,254, 254, 254, 254, 254,  32,	; Desenhando os obstaculos com caracteres
		  254, 254, 254, 254, 254, 254, 254, 254, 254,
		  254, 254, 254, 254, 254, 254, 254, 254, 254,
		   32, 32,  32, 254,  254, 254,  32, 32,  32,
		   32, 32, 32, 254, 254, 254, 32,  32,  32 

DinoX BYTE 4												; Declarando o tamanho dos eixos personagem
DinoY BYTE 10
Dino BYTE 32, 32,  32 ,32, 32, 32,  254,  254, 254,			; Desenhando o personagem com caracteres
			32, 32,  32, 32,  32, 254,  32, 32, 32,
			 254, 254, 254, 254, 254, 254, 254, 254, 254,
			 254,  254,  254,  254,  254, 254,  254, 32, 254

OvoX BYTE 4
OvoY BYTE 4
Ovo BYTE  32, 32, 32 ,32, 32, 32, 32, 32,  32,	; Desenhando os obstaculos com caracteres
		  32, 32, 32, 32, 32, 32, 32, 32, 32,
		  32, 32, 32, 254, 254, 254, 32, 32, 32,
		   32, 32,  254, 254,  254, 254,  254, 32,  32,
		   32, 32, 32, 254, 254, 254, 32,  32,  32 

GameOver BYTE "		 _____                          ____                  ",0ah, 0dh     	; Textos de Fim de jogo           
		  BYTE "		/ ____|                        / __ \                 ",0ah, 0dh
		  BYTE "		| |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __  ",0ah, 0dh
	      BYTE "		| | |_ |/ _` | '_ ` _ \ / _ \ | |  | \ \ / / _ \ '__| ",0ah, 0dh
		  BYTE "		| |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |    ",0ah, 0dh
		  BYTE "		\______|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|    ",0

Dinossauro BYTE "			      ___    _				     ",0ah, 0dh						; Texto com o nome do jogo impresso no inicio
       BYTE "			     |   \  (_)			    ",0ah, 0dh
       BYTE "			     | |\ \ __ _ __   ___   ",0ah, 0dh
       BYTE "			     | | | || | '_ \ / _ \",0ah, 0dh
       BYTE "			     | |/ / | | | | | |_| |",0ah, 0dh
       BYTE "			     |___/  |_|_| |_|\___/ 	",0

.code

HUD PROC
							; musica
;mov eax, SND_FILENAME							; define que o som será tocado a partir de um arquivo
;or eax, SND_ASYNC								; define que o som será tocado imediatamente sem parar o programa
;or eax, SND_LOOP								; define que o som será tocado repetidamente até ser interrompido
;INVOKE PlaySound, ADDR warning, NULL, eax		; tocar música de vitória


						
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

Atualiza_Pont PROC							; procedimento chamado a cada movimento de obstaculo

	.IF Ctrl == 0
		add Pont, 5							; Pontuação incrementada em 5 cada vez que o atualiza_pont é chamado
								;musica
		;mov eax, SND_FILENAME				; define que o som será tocado a partir de um arquivo
		;or eax, SND_ASYNC					; define que o som será tocado imediatamente sem parar o programa
		;or eax, SND_LOOP					; define que o som será tocado repetidamente até ser interrompido
		;INVOKE PlaySound, ADDR stage, NULL, eax		; tocar música de vitória
		
		mov dl, 60							; escolhendo a posição a ser impressa a pontuação
		mov dh, 23
		call GotoXY
		push eax							
			mov eax, white					; escrevendo a pontuação
			call SetTextColor				
			movzx eax, Pont					
			call WriteDec					
		pop eax
	.ENDIF
	
	ret

Atualiza_Pont ENDP
											; Escrevendo o texto pontuação
Vidas PROC
	mov eax, white
	call SetTextColor
	mov dl, 10
	mov dh, 23
	call GotoXY
	mov edx, OFFSET Vida
	call writestring

	ret

Vidas ENDP

Pontu PROC									; chamada somente uma vez quando o jogo é iniciado 
	mov eax, white				
	call SetTextColor
	mov dl, 50								; escolhendo o lugar
	mov dh, 23
	call GotoXY
	mov edx, OFFSET Pontuacao				; chamando os caracteres pre definidos 
    
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
	call Randomize						; função para usar de aleatoriedade
	mov  eax, 3 						; 4 possibilidades diferentes de combinações de arvores
call RandomRange 						; eax começa valendo 3, para imprimir primeiro um espaço vazio

	.IF Ctrl == 1						; alternando entre um obstáculo e um espaço vazio
		mov eax, 3						; Ctrl == 1 -> nenhum obstaculo plotado

	.ELSEIF Ctrl == 0 && Fila2[6]==0 && Fila2[5]==2 ; Imprimindo 2 espaços vazios consecuivos
		mov eax, 3

	.ELSEIF Ctrl == 0 && Fila2[6]==0 && Fila2[4]==2 ; Imprimindo 3 espaços vazios consecutivos
		mov eax, 3

	.ELSEIF Ctrl == 0  					; Ctrl == 0 -> uma das combinações é plotada 
		mov Ctrl, 1						; depois de plotar um dos obstaculos, obrigatoriamente existe um espaço vazio
	.ENDIF
										; Adiciona uma arvore no inicio da tela
 										; o simbolo 2 indica o inicio de uma cadeia de caracteres

    .IF eax == 0
	    mov Fila0[7], 0
		mov Fila1[7], 0
		mov Fila2[7], 2
	
	.ELSEIF eax == 1					; Vida
		mov Fila0[7], 0
		mov Fila1[7], 0
		mov Fila2[7], 3
	
	.ELSEIF eax == 2					; Obstáculos nas duas primeiras linhas
		mov Fila0[7], 0
		mov Fila1[7], 2
		mov Fila2[7], 2
	
	.ELSEIF eax == 3					; Espaço vazio, nenhum obstáculo plotado
		mov Fila0[7], 0
		mov Fila1[7], 0
		mov Fila2[7], 0
		mov Ctrl, 0
										; indica que na proxima plotagem, 2 obstaculos apareceram
	.ENDIF
	
	ret		

Gera_Arvore ENDP
										; POSIÇÃO DO PERSONAGEM 
Move_Dino PROC
					
										; O personagem pode se posicionar em 3 posições diferentes no eixo y 
			
				
		.IF DinoY == 16 && Fila2[0] == 0 	; Na ultima posição, embaixo na tela
			mov Fila0[0], 0
			mov Fila1[0], 0
			mov Fila2[0], 1

		.ELSEIF DinoY == 16 && Fila2[0] == 3 ;
			call Apaga_Ovo
			mov Fila0[0], 0
			mov Fila1[0], 0
			mov Fila2[0], 1
		
		.ELSEIF DinoY == 10 && Fila1[0] == 3 ; 
			call Apaga_Ovo
			mov Fila0[0], 0
			mov Fila1[0], 1
			mov Fila2[0], 0

		.ELSEIF DinoY == 10 && Fila1[0] == 0 ;Na segunda posição, no meio da tela
			mov Fila0[0], 0
			mov Fila1[0], 1
			mov Fila2[0], 0

		.ELSEIF DinoY == 4 && Fila0[0] == 3 ;Na segunda posição, no meio da tela
			mov Fila0[0], 1
			mov Fila1[0], 0
			mov Fila2[0], 0

		.ELSEIF DinoY == 4 && Fila0[0] == 0 ; Na primeira posição, encima na tela
			mov Fila0[0], 1
			mov Fila1[0], 0
			mov Fila2[0], 0
			

		.ELSE
			call colisao 					; Se o personagem nao estiver em nenhuma dessas posições, significa que ele colidiu com a parede,
												; então o tratamento de colisao é chamado
		.ENDIF
		
	ret

Move_Dino ENDP

										; POSIÇÃO DOS OBSTACULOS
Move_Arvore PROC    

	call Atualiza_Pont					; cada vez que os obstaculos se movimentam, a pontuação é incrementada
	mov ecx, 8 							; contador de loop começa com 8 pois é a quantidade de slots em que os objetos ficam
	mov ebx, 0							; contador das filas começando na primeira posição 

L0:	
	mov al, Fila0[ebx + 1] 				; atualiza o registrador com a posição seguinte da fila superior
	 
	.IF Fila0[ebx] == 1 && al == 2 		; se o personagem estiver na posição atual && a próxima posição tiver um obstaculo
	     call Colisao 					; chama a rotina de colisão 

	.ELSEIF Fila0[ebx] != 1 			; se o personagem não estiver na posição atual da fila superior
		mov Fila0[ebx], al				; movimenta o que tiver na proxima posição para frente

	.ELSEIF Fila0[ebx]==1 && al == 3
		call Incrementa_Vida

	.ENDIF	

	inc ebx 							; muda para o proximo slot

LOOP L0
	mov ecx, 8							; contador de loop começa com 8 pois é a quantidade de slots em que os objetos ficam
	mov ebx, 0							; contador das filas começando na primeira posição 

L1:	
	mov al, Fila1[ebx + 1] 				; atualiza o registrador com a posição seguinte da fila do meio 
    									; mesma rotina de tratamento de colisão que a fila superior 
	.IF Fila1[ebx] == 1 && al == 2
	    call Colisao

	.ELSEIF Fila1[ebx] != 1
		mov Fila1[ebx], al

	.ELSEIF Fila1[ebx]==1 && al == 3
		call Incrementa_Vida	

	.ENDIF	

	inc ebx

LOOP L1

	mov ecx, 8 							; contador de loop começa com 8 pois é a quantidade de slots em que os objetos ficam
	mov ebx, 0							; contador das filas começando na primeira posição 

L2:	
	mov al, Fila2[ebx + 1] 				; atualiza o registrador com a posição seguinte da fila inferior
										; mesma rotina de tratamento que a fila superior
    .IF Fila2[ebx] == 1 && al == 2 		
	     call colisao	

	.ELSEIF Fila2[ebx] != 1
		mov Fila2[ebx], al

	.ELSEIF Fila2[ebx]==1 && al == 3
		call Incrementa_Vida

	.ENDIF		

	inc ebx

LOOP L2

	call Gera_Arvore					; gera os proximos obstaculos 	
	call Escreve_Fila					; imprime os proximos obstaculos 
	ret

Move_Arvore ENDP

Escreve_Fila PROC 
	mov ecx, 7							
	mov ebx, 0

L0:

	push ecx 							; Salva o valor de ecx em uma pilha, para podermos usa-lo
	mov al, Fila0[ebx] 					; Salva o conteudo de fila0[X] no registrador auxiliar 
	.IF al == 2							; Se esse valor == 2, podemos desenhar o obstaculo
		call Desenha_Arvore 			; pois o 2 simboliza a presença de caracteres
	
	.ELSEIF al == 0						; Se esse valor == 0, apagamos o que estiver escrito 
		call Apaga_Arvore				; pois o 0 simboliza a ausencia de caracteres
		
	.ELSEIF al == 1 					; Se esse valor == 1, podemos desenhar o Personagem
		call Desenha_Dino
	
	.ELSEIF al == 3
		call Desenha_Ovo
					
   .ENDIF 
	pop ecx 							; Desempilha ecx
	add ArvoreX, 11
	add OvoX, 11 
	inc ebx 							; Anda uma posição para frente com os obstaculos

LOOP L0
	mov ArvoreX, 4
	add ArvoreY, 6
	mov OvoX, 4
	add OvoY, 6
	mov ecx, 7
	mov ebx, 0

L1:										; mesma coisa que o loop 0 para esse, mas para a segunda fila 
	push ecx
	mov al, Fila1[ebx]
	.IF al == 2
		call Desenha_Arvore
	.ELSEIF al == 0
		call Apaga_Arvore

	.ELSEIF al == 3
		call Desenha_Ovo

	.ELSEIF al == 1
		call Desenha_Dino

	.ENDIF
	pop ecx		
	add ArvoreX, 11
	add OvoX, 11
	inc ebx

LOOP L1

	mov ArvoreX, 4
	add ArvoreY, 6
	mov OvoX, 4
	add OvoY, 6
	mov ecx, 7
	mov ebx, 0

L2:										; mesma coisa que o loop 0 para esse, mas para a terceira fila
	push ecx
	mov al, Fila2[ebx]

	.IF al == 2
		call Desenha_Arvore

	.ELSEIF al == 0
		call Apaga_Arvore
	
	.ELSEIF al == 3
		call Desenha_Ovo

	.ELSEIF al == 1
		call Desenha_Dino

	.ENDIF

	pop ecx		
	add ArvoreX, 11
	add OvoX, 11
	inc ebx

LOOP L2

	mov ArvoreX, 4
	mov ArvoreY, 4
	mov OvoX, 4
	mov OvoY, 4

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
		mov  eax,green 					; definindo a cor do personagem
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

Desenha_Ovo PROC
	mov dl, OvoX 					; Salvando a posição atual
	mov dh, OvoY
	call GotoXY 						; atualizando o cursor


	mov esi, OFFSET Ovo 				; caracteres que compoe obstaculo
	mov ecx, 5							; contador de laços é igual ao quantidade de linhas que uma vida ocupa

Linha:
	push ecx 							; empilha ecx 
	mov ecx, 9							; contador de laços é igual a quantidade de caracteres que uma vida tem por linha
	Coluna:
		mov  eax, white					; definindo as cores do obstaculo
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

Desenha_Ovo ENDP

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


Apaga_Ovo PROC
	mov dl, OvoX						; Salva a posição atual 
	mov dh, OvoY
	call GotoXY
	mov ecx, 5							; contador de loop é igual a quantidade de linhas que uma vida tem 
	mov al, 32							; auxiliar de impressão é atualizado com o caracter vazio
Linha:
	PUSH ecx 							; empilha ecx
	mov ecx, 9							; atualiza o contador de laços com a quantidade de caracteres que uma vida tem por linha
	Coluna:
		call WriteChar 					; imprime o caracter vazio
	LOOP Coluna
	POP ecx 							; desempilha ecx, para imprimir para a linha debaixo							
	inc dh 								; incrementa o registrador de linha
    call GotoXY

LOOP Linha

	ret

Apaga_Ovo ENDP

										; APAGANDO O PERSONAGEM 

Apaga_Dino PROC
	mov dl, DinoX						; Salva a posição atual do personagem
	mov dh, DinoY
	call GotoXY

	mov ecx, 5							; contador de loop é igual a quantidade de linhas que o personagem tem 
	mov al, 32							; auxiliar de impressão é atualizado com o caracter vazio

Linha:
	PUSH ecx 							; empilha ecx
	mov ecx, 9							; atualiza o contador de laços com a quantidade de caracteres que um obstaculo tem por linha
	Coluna:
		call WriteChar					; imprime o caracter vazio
		LOOP Coluna

	POP ecx 							; desempilha ecx, para imprimir para a linha debaixo
	inc dh 								; incrementa o registrador de linha
    call GotoXY

LOOP Linha

	ret

Apaga_Dino ENDP

										; TRATAMENTO DE COLISAO

Colisao PROC

				;musica
;mov eax, SND_FILENAME			; define que o som será tocado a partir de um arquivo
;or eax, SND_ASYNC				; define que o som será tocado imediatamente sem parar o programa
;or eax, SND_LOOP				; define que o som será tocado repetidamente até ser interrompido
;INVOKE PlaySound, ADDR obstaculo, NULL, eax		; tocar música de obstaculo
	.IF vidinha == 0
		call Clrscr
		mov dl, 1							; escolhendo posição para imprimir o texto no fim do jogo
		mov dh, 7
		call GotoXY
		mov  eax, red 						; escolhendo a cor vermelha para o texto de game over
		call SetTextColor					
		mov edx, OFFSET GameOver			
		call WriteString 					; imprimindo game over
		call HUD							; imprime um quadro branco na tela
		call Pontu 							; exibe pontuação final 

		mov dl, 60  						; escolhe a coluna em que o curor sera setado
		mov dh, 23							; escollhe a linha em que o cursor sera setado
		call GotoXY
		mov  eax, white						; cor branca
		call SetTextColor					
		movzx eax, Pont 					
		call WriteDec
		mov eax, 2000
		call delay
		exit
	.ENDIF
	call Decrementa_Vida

	ret

Colisao ENDP

Decrementa_Vida PROC
	sub vidinha, 1
	mov dl, 20							; escolhendo a posição a ser impressa a pontuação
	mov dh, 23
	call GotoXY
	push eax							
		mov eax, green					; escrevendo a pontuação
		call SetTextColor				
		movzx eax, vidinha					
		call WriteDec					
	pop eax
	
	ret

Decrementa_Vida ENDP

Incrementa_Vida PROC


	
	.IF vidinha != 3
		add vidinha, 1							; Vidas incrementadas em 1 cada vez que existe uma colisao com ovo
								;musica
			;mov eax, SND_FILENAME				; define que o som será tocado a partir de um arquivo
			;or eax, SND_ASYNC					; define que o som será tocado imediatamente sem parar o programa
			;or eax, SND_LOOP					; define que o som será tocado repetidamente até ser interrompido
			;INVOKE PlaySound, ADDR stage, NULL, eax		; tocar música de vitória
		
		mov dl, 20							; escolhendo a posição a ser impressa a pontuação
		mov dh, 23
		call GotoXY
		push eax							
			mov eax, green					; escrevendo a pontuação
			call SetTextColor				
			movzx eax, vidinha					
			call WriteDec					
		pop eax
	
	.ENDIF
	
	ret

Incrementa_Vida ENDP



											;INICIO DO JOGO 


main PROC	
    INVOKE GetStdHandle,STD_OUTPUT_HANDLE 
	mov outHandle, eax
	INVOKE SetConsoleScreenBufferSize, 
	outHandle,scrSize

	mov vidinha, 0
											; Imprimindo a tela inicial
	mov dl, 1 								; Primeiro o nome do jogo 
	mov dh, 8
	call GotoXY
	mov  eax, white
	call SetTextColor
	mov edx, OFFSET Dinossauro
    call WriteString
	mov dl, 1 								; Depois o quadro de opções
	mov dh, 16
	call GotoXY
	mov edx, OFFSET Opcoes
    call WriteString	 
	call HUD	 							; Com o quadro branco envolta
	mov ecx, 0
Op:	
    mov  eax,50								; lendo a opção escolhida no teclado          
    call Delay        						; com o delay para o processamento da entrada
	call ReadKey
	push edx 

	.IF al == 31h 							; se a entrada for o numero 1
		call Clrscr							; apaga a tela inicial
		mov DinoX, 4 						; escolhe uma posição para o personagem iniciar
        mov DinoY, 10
		jmp Continua          				; pula para o jogo de fato

	.ENDIF

	.IF ecx == 0  							; personagem que fica passando pela tela de espera
		call Apaga_Dino 					; Apagando tudo o que estiver no espaço a ser desenhado o personagem
		mov DinoX, 3						; posição escolhida
		mov DinoY, 3

	.ELSEIF ecx == 67 						; se o contador chegar ao final, inicia novamente
		mov ecx, -1							; para o personagem passar várias vezes

	.ENDIF

	push ecx 
		call Apaga_Dino 					; Apaga tudo o que estiver na localização escolhida
		inc DinoX							; incrementa o eixo x, pra ele andar para frente 
		call Desenha_Dino  					; printa o personagem 	
		mov eax, 80							; usa um delay entre a movimentação
		call Delay
	pop ecx 
	inc ecx

	pop edx
    cmp dx,VK_ESCAPE 						; Procura pela entrada esc 

 jne OP 									; Se não tiver esc, continua na tela de inicio 
 je Sair 									; se tiver, pula para a parte de fechar o jogo 

 Continua: 									; INICIANDO O JOGO DE VERDADE
	call HUD								; Desenha as bordas
	call Pontu 								; escreve o texto pontuação
	call Vidas
	call Gera_Arvore 						; define os obstaculos 
	call Escreve_Fila						; escreve os obstaculos	
	call GetMseconds
	mov Tempo,eax

Setas:	
    mov  eax,50    							; procurando pelas entradas do teclado, com um pequeno delay para processamento   
    call Delay        					
	call ReadKey        	
	   	
    .IF ah == 48h && DinoY != 4				; Se a entrada for == a seta para cima && o personagem não estiver na primeira posição da tela
		call Apaga_Dino 					; apaga o personagem na posição antiga
		sub DinoY, 6						; subtrai o eixo y em 6, para o personagem subir 6 posições
		call Move_Dino						; movimenta o personagem 
		call Desenha_Dino					; desenha a nova posição do personagem
		
		
		;push eax
		;mov eax, 1000
		;call delay
		;call Apaga_Dino					; TESTE	
		;add DinoY, 6						; TESTE
		;call Move_Dino						; TESTE
		;Call Desenha_Dino					; TESTE
		;pop eax
	
	
	
	
	
	.ELSEIF ah == 50h && DinoY != 16		; se a entrada for == a seta para baixo && o personagem não estiver na ultima posição da tela
	    call Apaga_Dino 					; apaga o personagem na posição antiga
		add DinoY, 6 						; incrementa o eixo y em 6, para o personagem descer 6 posições
		call Move_Dino 						; Movimenta o personagem
		call Desenha_Dino	          	    ; desenha o personagem na nova posição 	

	.ENDIF

	call Atraso_Ctrl 						
	call GetMseconds
	sub eax, Tempo	

	.IF eax > Atraso
	   call Move_Arvore
	   call GetMseconds
	   mov Tempo, eax

	.ENDIF

    cmp dx,VK_ESCAPE 						; procura por um esc para sair do jogo

 jne Setas   								; Se não encontra um esc, continua a procurar por entradas e movimentar os objetos

 Sair:										

	exit 									; fechando o jogo

main ENDP

END main