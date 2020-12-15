.data

lf: .asciiz	"\n"
ne: .asciiz	" Resultado neurônio : "
re: .asciiz	" Resultado real : "
s:  .asciiz	" + " 
p:  .asciiz	"Pesos finais : " 
w0: .float 0.00000000
w1: .float 0.80000000
ta: .float 0.05000000
n:  .word 5

.text

main: add $t1, $zero, $zero
 
  # Carregando variaveis
  lw $s0, n
  l.s $f1, w0
  l.s $f2, w1
  l.s $f3, ta

  FOR: slt $t0, $t1, $s0
    beq $t0, $zero, FIM
    addi $t1, $t1, 1

    mtc1 $t1, $f9
    cvt.s.w $f9, $f9

    # Multiplicandos peso pela entrada
    mul.s $f4, $f1, $f9 
    mul.s $f5, $f2, $f9
    
    # Somando resultados das multiplicações.
    # O resultado da soma é o que o neurônio acha que é o certo
    add.s $f4, $f4, $f5

    # O resultado dessa soma é o que realmente está certo
    add $s2, $t1, $t1

    mtc1 $s2, $f5
    cvt.s.w $f5, $f5

    # O resultado dessa subtração representa o erro.
    # Quanto mais perto de 0 mais acertivo o neurônio está.
    sub.s $f6, $f5, $f4

    # Recalculando pesos com base no erro
    mul.s $f7, $f3, $f9
    mul.s $f7, $f6, $f7
    # Peso 1 recaclculado
    add.s $f1, $f1, $f7
    # Peso 2 recaclculado
    add.s $f2, $f2, $f7

    s.s $f1, w0
    s.s $f2, w1

    # Mostra graficamente a soma
    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 4 
	  la $a0, s
	  syscall

    li $v0, 1
    move $a0, $t1
    syscall

    # Mostra graficamente o resultado real
    li $v0, 4 
	  la $a0, re
	  syscall

    li $v0, 1
    move $a0, $s2
    syscall

    # Mostra graficamente o resultado do neurônio
    li $v0, 4 
	  la $a0, ne
	  syscall

    li $v0, 2
    mov.s $f12, $f4
    syscall

    li $v0, 4 
	  la $a0, lf
	  syscall

  j FOR

  # Mostra graficamente os pesos finais que podem atualizar os pesos atuais
  FIM: li $v0, 4 
  la $a0, lf
  syscall

  li $v0, 4 
  la $a0, p
  syscall

  li $v0, 4 
  la $a0, lf
  syscall

  li $v0, 2
  mov.s $f12, $f1
  syscall
    
  li $v0, 4 
  la $a0, lf
  syscall

  li $v0, 2
  mov.s $f12, $f2
  syscall

  jr $ra

end:

