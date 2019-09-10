#######################
### PRÁTICA PARTE 2 ###
#######################


################################################
## Onde encontrar dados dos preços dos ativos ##
################################################

install.packages("quantmod", dependencies = F)
# install.packages é uma função para baixar pacotes de terceiros para dentro do R
# Estes pacotes são geralmente feitos pela comunidade de usuários.
# O parametro "depedencies" diz para função que é para baixar todos os pacotes que o pacote
# principal utiliza dentro dele.


library(quantmod)
# Além de baixarmos o pacote, temos que carregar ele dentro do ambiente do R
# para isto que existe a função library, que carrega o pacote que especificarmos.

# O pacote quantmod é um pacote com soluções para quem quer fazer pesquisa em cima de dados
# financeiros, e possui dados de OHLC da maioria dos ativos brasileiros.
# Estes dados são disponibilizados pela Google e Yahoo.


Ativo <- "WEGE3.SA"

# Baixando os dados de preço do ativo
papel <- getSymbols(Ativo, auto.assign = F)

# Padronizando os nomes das colunas
colnames(papel)

colnames(papel) <- gsub(Ativo, "", colnames(papel))
colnames(papel)

gsub(".", "", colnames(papel))
gsub("[.]", "", colnames(papel))

colnames(papel) <- gsub("[.]", "", colnames(papel))





#########################################
### Verificando a qualidade dos dados ###
#########################################

# Entendendo o objeto
str(papel)

# Explorando os dados
View(papel)

# Numero de dias com volume igual a 0
table(papel$Volume == 0)

# Tirando linhas onde o volume é 0
papel <- papel[papel$Volume != 0, ]
papel


# Visualizando os dados
plot(papel$Close, main = Ativo)
plot(papel$Adjusted, main = Ativo)


# Ajustando preços OHLC indexando pelo preço ajustado
papel[, c("Open", "High", "Low", "Close", "Volume")] <- 
  papel[, c("Open", "High", "Low", "Close", "Volume")] *
  as.numeric(papel$Adjusted / papel$Close)


# Visualizando
plot(papel[, 1 : 4], main = Ativo)


# Visualizando com a função específica do quantmod
barChart(papel)
barChart(papel, name = Ativo) # Nomeando o gráfico
barChart(papel, log.scale = T, name = Ativo) # Colocando o log
barChart(papel, log.scale = T, subset = "2017::2019", name = Ativo) # Reduzindo o período





################################################
### Criando indicadores em cima destes dados ###
################################################

install.packages("TTR")
library(TTR)

barChart(papel, log.scale = T, subset = "2017::2019", name = Ativo)

addTA(TTR::ZigZag(papel[, c("High", "Low")]), on = T)
addTA(TTR::BBands(papel[, c("High", "Low", "Close")]), on = T)
addTA(TTR::volatility(papel$Close))
addTA(TTR::ultimateOscillator(papel[, c("High", "Low", "Close")]))


#################################################
### Criando estratégias com estes indicadores ###
#################################################


### Para criar e testar as estratégias, precisamos tomar alguns cuidados: ###

# O primeiro cuidado é recortar em outro objeto somente os dados que queremos usar
# no teste.

# Isso é fácil quando usamos um loop com um corte de dados.

periodoInicioTeste <- "2017-01-01"
periodoTeste <- which(index(papel) >= periodoInicioTeste)

for(t in periodoTeste) {
  
}




#############################################
### Verificando o retorno das estratégias ###
#############################################



# Cruzamento de Médias
# Bandas de Bollinger
# Indicador de Volume



# Simulando uma operação






