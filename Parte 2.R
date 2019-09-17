#######################
### PRÁTICA PARTE 2 ###
#######################


################################################
## Onde encontrar dados dos preços dos ativos ##
################################################

install.packages("TTR")
install.packages("quantmod", dependencies = F)
# install.packages é uma função para baixar pacotes de terceiros para dentro do R
# Estes pacotes são geralmente feitos pela comunidade de usuários.
# O parametro "depedencies" diz para função que é para baixar todos os pacotes que o pacote
# principal utiliza dentro dele.

library(TTR)
library(quantmod)
# Além de baixarmos o pacote, temos que carregar ele dentro do ambiente do R
# para isto que existe a função library, que carrega o pacote que especificarmos.

# O pacote quantmod é um pacote com soluções para quem quer fazer pesquisa em cima de dados
# financeiros, e possui dados de OHLC da maioria dos ativos brasileiros.
# Estes dados são disponibilizados pela Google e Yahoo.


Ativo <- "WEGE3.SA"
# Ativo <- "VALE3.SA"
# Ativo <- "PETR3.SA"
# Ativo <- "ELET3.SA"
# Ativo <- "USIM3.SA"
# Ativo <- "BBDC3.SA"
# Ativo <- "MGLU3.SA"
# Ativo <- "ELET3.SA"

# Baixando os dados de preço do ativo
papel <- getSymbols(Ativo, auto.assign = F)

# Padronizando os nomes das colunas
colnames(papel)

colnames(papel) <- gsub(Ativo, "", colnames(papel))
colnames(papel)

gsub(".", "", colnames(papel))
gsub("[.]", "", colnames(papel))

colnames(papel) <- gsub("[.]", "", colnames(papel))





############################
### Verificando os dados ###
############################

# Entendendo o objeto
str(papel)
# xts é uma classe especial de matriz onde os valores são indexados pela data.
rownames(papel)
index(papel)
str(index(papel))

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
barChart(papel, log.scale = T, subset = "2019::2019", name = Ativo) # Reduzindo o período





################################################
### Criando indicadores em cima destes dados ###
################################################


barChart(papel, log.scale = T, subset = "2017::2019", name = Ativo, theme = "white")

addTA(TTR::ZigZag(papel[, c("High", "Low")]), on = T)
addTA(TTR::BBands(papel[, c("High", "Low", "Close")]), on = T)
addTA(TTR::volatility(papel$Close))
addTA(TTR::ultimateOscillator(papel[, c("High", "Low", "Close")]))


#################################################
### Criando estratégias com estes indicadores ###
#################################################


## Algumas limitações por conta do tempo:
# Somente operações compradas.
# Somente preço de fechamento.

periodoInicioTeste <- "2017-01-01"
periodoTeste <- which(index(papel) >= periodoInicioTeste)
periodoTeste <- periodoTeste[periodoTeste != 1]
# A função which nos da a posição dos valores verdadeiros

head(papel, 10)
# A função head nos dá os n primeiros elementos do objeto.

papelTestes <- head(papel, periodoTeste[1])

tail(papelTestes, 10)
# tail é a equivalente de head para as últimas linhas


### Gerando colunas para guardar os resultados
papel$resultado <- 0
# Este resultado tera somente a nossa variação de capital diaria
papel$posicao <- 0
# Aqui vamos usar um código para cada posição no fim do dia
# 0 para fora do ativo
# 1 para comprado

papel$retAcumEstrategia <- 0
# Guarda o retorno acumulado da estratégia definida
papel$retAcumpapel <- 0
# Guarda o retorno acumulado da estratégiia buy and hold

for(linha in periodoTeste) {
  # for é uma função que cria um loop onde cada elemento da variável usada é processada.
  # Neste exemplo, linha tera, para cada iteração no loop, um valor de periodoTeste.
  ### Funções para controle dentro do loop:
    # break encerra o loop naquele momento, ignorando iterações ainda não realizadas.
    # next: encerra iteração atual no estado atual e começa a próxima.
  
  #break
  
  ### Cortando os dados ###
  papelTestes <- head(papel, linha)
  # Queremos trabalhar só com os dados que teriamos no momento da compra.
  
  ### Adicionando Indicadores ###
  # Adicionando Bandas de Bollinger:
  papelTestes <- cbind(papelTestes,
                       TTR::BBands(HLC = papelTestes[, c("High", "Low", "Close")]))
  
  # Visualizando
  tail(papelTestes[, c("Close", "dn", "mavg", "up")])
  
  
  
  ## Vamos comprar somente quando o preco de fechamento for menor que a banda inferior e
  ## ainda não estivermos comprados
  
  if( ! papel[linha - 1, "posicao"][[1]])
    if(papelTestes[linha, "Close"] < papelTestes[linha, "dn"]) {
      # is.na é uma função para posições com valores faltantes.
      
      # stop()
      # papelTestes[linha, ]
      papel[linha, "posicao"] <- 1
    }
  
  ## E vamos sair de nossa posição comprada somente quando o close alcançar a faixa superior
  ## das Bandas de Bollinger
  if(papel[linha - 1, "posicao"]) {
    # Guardando o resultado do dia.
    papel[linha, "resultado"] <- 
      as.numeric(papel[linha, "Close"]) / as.numeric(papel[linha - 1, "Close"]) - 1
    
    if(papelTestes[linha, "Close"] > papelTestes[linha, "up"]) {
      # stop()
      papelTestes[linha, ]
      # Testando a condição de venda
      papel[linha, "posicao"] <- 0
    } else {
      papel[linha, "posicao"] <- 1
    }
  }
  
  papel$retAcumEstrategia[linha] <- prod(papel$resultado + 1)
  papel$retAcumpapel[linha] <- as.numeric(papel[linha, "Close"]) /
    as.numeric(papel[periodoTeste[1], "Close"])
  
  print(paste("Lucro atual:",
              round(papel$retAcumEstrategia[linha] - 1, 3) * 100,
              "% - Buy and hold:",
              round(papel$retAcumpapel[linha] - 1, 3) * 100,
              "%"))
  rm(papelTestes)
}



# Plotando o Retorno da Estratégia Escolhida x Buy and Hold
plot(papel[periodoTeste, c("retAcumpapel", "retAcumEstrategia")],
     main = "Retorno Estratégia x Buy and Hold")





