---
title: "lab04"
date: "29 de agosto de 2018"
output: html_document
---

```{r}
pkgs = c("tidyverse", "maps", "RColorBrewer", "rmarkdown", "knitr", "caTools", "tidyr")
#install.packages(pkgs, type="win.binary")
library("tidyverse")
```


 1 Importe, utilizando o pacote readr, cada um dos três arquivos disponíveis. Os objetos resultantes devem ser chamados flights,  airlines e airports.

 - Para o arquivo de vôos, importe apenas as colunas DESTINATION_AIRPORT e ARRIVAL_DELAY.
 - Para o arquivo de aeroportos, importe apenas as colunas IATA_CODE, CITY e STATE

```{r}
library(readr)

#Preparando diretório de trabalho
path = 'C:/Users/137408/Downloads/flight-delays'
setwd(path)

#Importando banco de dados

##Linhas aereas
airlines <- read_csv("airlines.csv")

##Aeroportos
airports <- read_csv("airports.csv",
                     col_types = cols_only(IATA_CODE='c',
                                           CITY='c',
                                           STATE='c'))

##voos
flights <- read_csv("flights.csv",
                    col_types = cols_only(DESTINATION_AIRPORT='c',
                                          ARRIVAL_DELAY='i'))
```

 2 Organize a tabela flights:
 
 - remova vôos em que o aeroporto de destino comece com a letra 1;
 - remova registros em que o valor da variável ARRIVAL_DELAY seja faltante;
 - para cada aeroporto de destino, determine o atraso médio na chegada para os vôos que ali aterrissaram. Este atraso médio deve ser armazenado na coluna MEAN_DELAY.
 - a tabela resultante deve ser armazenada (novamente, de forma a sobrescrever o objeto anterior) em flights.
 
```{r}
library("dplyr")

##Limpando a tabela flights
flights <- flights %>% 
  filter( !startsWith(DESTINATION_AIRPORT, "1"), !is.na(ARRIVAL_DELAY)) %>% 
  group_by(DESTINATION_AIRPORT) %>% 
  summarise(MEAN_DELAY = mean(ARRIVAL_DELAY))

```
 
 3 Selecione a operação apropriada join para incluir, na tabela flights, as colunas CITY e STATE. Para executar esta tarefa:
 - Identifique a coluna que é a chave na tabela flights;
 - Identifique a coluna que é a chave na tabela airports;
 - Apresente o comando que combine ambas as tabelas, indicando explicitamente as chaves;
 - Armazene a tabela resultante no objeto flights.

```{r}
 
#Comparando as colunas
glimpse(airports) #chave: "IATA_CODE"
glimpse(flights) #chave: "DESTINATION_AIRPORT"

#Fazendo a união das tabelas
flights <- left_join(flights, airports, by=c("DESTINATION_AIRPORT"="IATA_CODE"))

```

 4 Para cada estado de chegada:
 - Determine a média do atraso médio na chegada e chame esta variável de STATE_DELAY;
 - Agrupe a variável STATE_DELAY em quartis (utilizando as funções cut e quantile), lembrando-se de incluir a classificação para o menor dos valores (explore o comando cut para descobrir o argumento responsável por isso). Armazene os resultados na variável COLOR_CODE.
 - O objeto que conterá todos estes resultados deve ser chamado toMap.
 
```{r}

toMap <- flights %>% 
  group_by(STATE) %>% 
  summarise(STATE_DELAY = mean(MEAN_DELAY)) %>% 
  mutate(COLOR_CODE = cut(STATE_DELAY, quantile(STATE_DELAY), include.lowest = TRUE, labels = FALSE))
  
```
 
 5 O pacote maps fornece geometrias para fronteiras entre estados. Apresente o mapa estadual utilizando o comando map.
 
```{r}
library("maps")
 
map("state")
```
 
 6 Crie um objeto chamado info, da classe tibble, contendo duas colunas:
 - STATE: cujo valor será o conteúdo do vetor state.abb;
 - STATE_NAME: cujo valor será o conteúdo do vetor state.name.
 
```{r}
info <- tibble(STATE = state.abb,
               STATE_NAME = state.name)

```
 
 7 Utilize comandos join para responder:
 - Que “estados” aparecem listados em toMap e estão ausentes em info? Armazene estes registros num objeto chamado  faltantes.
 - Crie um objeto chamado info_completa que possua todas as informações (STATE, STATE_DELAY, COLOR_CODE, STATE_NAME) apenas para estados listados em ambas as tabelas, toMap e info.
 - Crie um objeto chamado banco_completo que possua todos os registros, independente de termos o nome de estado ou não.
 
```{r}

#Estados só em toMap
faltantes = anti_join(toMap, info, by = "STATE")
  #toMap %>% filter(!(STATE %in% info$STATE))


info_completa = inner_join(toMap, info, by = "STATE")

banco_completo = full_join(toMap, info, by = "STATE")

```
 
 8 Produza um mapa que apresente o atraso médio na chegada por estado.
 - Confirme que a tabela info_completa esteja na mesma ordem que info (caso não esteja na mesma ordem, ordene  info_completa de forma que tenha a mesma ordem que info).
 - Utilizando o pacote RColorBrewer, com o comando brewer.pal, extraia 4 cores (associadas com a coluna COLOR_CODE de  info_completa) da paleta de cores YlOrRd (brewer.pal(4, 'YlOrRd')). Crie um tibble, chamado cores, com duas colunas:  COLOR_CODE e COLOR.
 - Combine info_completa com cores utilizando o join apropriado. Armazene o resultado, novamente, em info_completa.
 - Refaça o mapa do item 5., adicionando os argumentos fill=TRUE e col=info_completa$COLOR.
 
```{r}
library("RColorBrewer")
 
idx <- match(info$STATE, info_completa$STATE)
info_completa = info_completa[idx,]
  #info_completa %>% arrange(STATE_NAME)

cores <- tibble(COLOR_CODE=1:4,
               COLOR=brewer.pal(4, 'YlOrRd'))

info_completa <- info_completa %>% left_join(cores, by="COLOR_CODE")

map("state", fill = TRUE, col = info_completa$COLOR)
```
 
