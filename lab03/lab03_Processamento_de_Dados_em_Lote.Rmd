---
title: "Tarefa03"
date: "22 de agosto de 2018"
output: html_document
---

```{r }
#install.packages('tidyverse')
#install.packages('magrittr')
#install.packages('devtools')
#devtools::install_github('jayjacobs/ggcal')

library('tidyverse')
library('magrittr')
library('lubridate')
library('ggplot2')
library('devtools')
library('ggcal')

```

##1
As estatísticas são o número total de vôo por companhia aérea e o número total de atrasos por companhia aérea.

##2
Crie uma função chamada getStats que, para um conjunto de qualquer tamanho de dados provenientes de flights.csv.zip, execute as seguintes tarefas (usando apenas verbos do dplyr:
Filtre o conjunto de dados de forma que contenha apenas observações das seguintes Cias. Aéreas: AA, DL, UA e US;
Remova observações que tenham valores faltantes em campos de interesse;
Agrupe o conjunto de dados resultante de acordo com: dia, mês e cia. aérea;
Para cada grupo em b., determine as estatísticas suficientes apontadas no item 1. e os retorne como um objeto da classe tibble;
A função deve receber apenas dois argumentos:
input: o conjunto de dados (referente ao lote em questão);
pos: argumento de posicionamento de ponteiro dentro da base de dados. Apesar de existir na função, este argumento não será empregado internamente.

```{r }
getStats <- function(input, pos){
  input %>% 
    filter(AIRLINE %in% c('AA', 'DL', 'UA', 'US'), !is.na(ARRIVAL_DELAY)) %>% 
    group_by(MONTH, DAY, AIRLINE) %>% 
      summarise(atraso=sum(ARRIVAL_DELAY > 10),
                n=n())
}


colunas = cols_only(MONTH='i',
                    DAY='i',
                    AIRLINE='c',
                    ARRIVAL_DELAY='i')


atrasos = read_csv_chunked('flights.csv',
                       callback=DataFrameCallback$new(getStats),
                       chunk_size=1e5,
                       col_types=colunas)

library('lubridate')

computeStats = function(stats){
  stats %>%
    group_by(MONTH, DAY, AIRLINE) %>% 
      summarise(Atr = sum(atraso),
              n = sum (n)) %>% 
    group_by(MONTH, DAY, AIRLINE) %>% 
      summarise(Perc = Atr/n,
              Data = ymd(paste(2015, MONTH, DAY))) %>% 
    ungroup() %>% 
    select(Cia = AIRLINE, Data, Perc)
}

calendario = atrasos %>% computeStats()
```

```{r }
pal = scale_fill_gradient(low ='#4575b4', high = '#d73027')

library('magrittr')

baseCalendario = function(stats, cia){
  base = stats %>% 
    filter(Cia == cia) %$%  #####Magrittr
    ggcal(Data, Perc)
}

cAA = baseCalendario(calendario,'AA')
cDL = baseCalendario(calendario,'DL')
cUA = baseCalendario(calendario,'UA')
cUS = baseCalendario(calendario,'US')

cAA + pal + ggtitle("Percentual de vôos atrasados na chegada para a Cia. Aérea AA")
cDL + pal + ggtitle("Percentual de vôos atrasados na chegada para a Cia. Aérea DL")
cUA + pal + ggtitle("Percentual de vôos atrasados na chegada para a Cia. Aérea UA")
cUS + pal + ggtitle("Percentual de vôos atrasados na chegada para a Cia. Aérea US")

```
