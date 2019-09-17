#######################
### PRÁTICA PARTE 1 ###
#######################

# Como fazer operações matemáticas, criar objetos e manipulá-los #


#####################################
### Fazendo operações aritméticas ###
#####################################

# Somas:
2 + 2

# Subtrações:
10 - 4

# Multiplicações:
5 * 5
10 * 0
Inf * 0

# Divisões:
12 / 2
10 / 0
10 / Inf

# Potencias:
10 ^ 2
2 ^ 10
10 ^ 0
10 ^ Inf

# Raizes:
sqrt(4)
4 ^ (1 / 2)
sqrt(-4)
- 4 ^ (1 / 2)
(- 4) ^ (1 / 2)

## Bonus
# Inteiro
22 %/% 5
# Resto
22 %% 5
# Ajuda
help("+")





#####################################
### Fazendo operações relacionais ###
#####################################

# Igualdade (==)
2 == 2
2 == "a"

# Diferença (!=)
3 != 3
"A" != "B"

# Maior que (>), menor que (<), maior ou igual a (>=) e menor ou igual a (<=)
34 > 10
"a" < "b"
4 >= "a"
5 <= "z"

# Ajuda
help("==")





#################################
### Fazendo operações lógicas ###
#################################

## Detalhes
# 1 e 0, TRUE e FALSE, T e F.

# Valores Verdadeiros
TRUE == T
TRUE == 1

# Valores Falsos
FALSE == F
FALSE == 0

## Operações
# Operação NÃO ( ! )
! TRUE
! FALSE

# Operação E (&)
TRUE & TRUE
TRUE & FALSE
FALSE & FALSE

# Operação OU (|)
TRUE | TRUE
TRUE | FALSE
FALSE | FALSE

# Operação OU-EXCLUSIVO (função xor())
xor(TRUE, TRUE)
xor(TRUE, FALSE)
xor(FALSE, FALSE)

## Bonus
# conversão de números para valores lógicos
as.logical(0)
as.logical(2)
# Ajuda
help("&")





#######################
### Criando objetos ###
#######################

# Atribuindo valores a um objeto
numero = 2
numero

caracter <- "nome"
caracter

logico <- TRUE
logico

vazio <- numeric()
vazio

nulo <- NULL
nulo

valorFaltante <- NA
valorFaltante

naoNumerico <- NaN
naoNumerico

# Bonus
# Formas de atribuir
b = 2 * (a <- 2)
b * 2 -> c
a
b
c

# Listando objetos (função ls)
ls()

# removendo objetos (função rm | remove)
rm(numero, caracter)
rm(list = ls())


## Atribuindo Vetores, matrizes, arrays, data.frames
# Vetores
vetorNumerico <- 0 : 50 + .5
vetorNumerico
class(vetorNumerico)

vetorLogico <- c(T, T, F, T, F, F)
vetorLogico
class(vetorLogico)

vetorCaracteres <- c("Mini", "Curso", "em", "R", "da", "Semana", "Acadêmica")
vetorCaracteres
class(vetorCaracteres)

# Matrizes
matriz1 <- matrix(1 : 100, nrow = 10, ncol = 3)
matriz1
class(matriz1)

matriz2 <- matrix(1 : 100, nrow = 10, byrow = T)
matriz2

matriz3 <- cbind(matriz1, vetorNumerico) # Função cbind cola uma coluna ao lado a outra)
matriz3

matriz4 <- cbind(vetorCaracteres, vetorLogico, vetorNumerico)
matriz4

str(matriz4) # str é uma função que resume as caracteristicas do objeto que estamos analizando
View(matriz4) # View é uma função que abre o objeto em uma aba nova para visualização

# arrays
array <- array(1:64, dim = c(4, 4, 4))
array

# Data Frames
dataframe <- data.frame(vetorCaracteres[1 : 6], vetorLogico[1 : 6], vetorNumerico[1 : 6])
View(dataframe)
str(dataframe)

data.frame(vetorCaracteres, vetorLogico, vetorNumerico)


#####################################
### Fazendo operações com objetos ###
#####################################

# Selecionando parte do objeto

matriz1[, 1]

matriz1[, 3]

array[1 : 3, 1 : 2, 3 : 4]

dataframe[1, ]

dataframe$vetorCaracteres.1.6.

# Renomeando linhas e colunas

rownames(dataframe) # a função rownames revela o nome da linha do objeto e
                    # podemos atribuir valores a ela, contando que vetor que
                    # estamos usando tenha o mesmo número de variáveis que ela
rownames(dataframe) <- "linha"

paste("linha", 1 : 6) # A função cola objetos do tipo caracter um ao lado do outro
rownames(dataframe) <- paste("linha", 1 : 6)


colnames(dataframe) # equivalente da função rownames para o nome da coluna


# Todas operações lógicas, relacionais e aritméticas estão disponíveis para
# vetores, arrays e data.frames.

vetorNumerico

vetorNumerico > 50

cbind(vetorNumerico, vetorNumerico > 25)


matriz1
matriz1 >= 25


matriz2[, 1] < vetorNumerico[1:10] + 30

array > 25






## Limpando o ambiente R para a próxima etapa

rm(list = ls())

