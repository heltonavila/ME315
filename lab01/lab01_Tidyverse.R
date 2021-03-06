---
title: "Laboratorio01"
date: "8 de agosto de 2018"
output: html_document
---
#Manipulação de Dados no Formato Tidy

##Q1
```{r eval=FALSE}
install.packages("tidyverse", repos="http://cran.us.r-project.org") #Instala o pacote tidyverse
```

##Q2
```{r}
library("tidyverse") #Carrega o pacote tidyverse
```

##Q3: Apresentar os bancos de dados
```{r}
table1 #Exibe a tibble chamada table1
table2 #Exibe a tibble chamada table2
table3 #Exibe a tibble chamada table3
table4a #Exibe a tibble chamada table4a
table4b #Exibe a tibble chamada table4b
```

##Q4
  No que se refere a table1 cada coluna representa uma variável, cada linha representa uma observação e cada célula tem um valor único, portanto é formato tidy.

  A table2 não está em formato tidy, pois a coluna type indica qual variável a coluna count está representando (população ou número de casos de tuberculose). Para transformar essa tibble em formato tidy deveriámos transformar as colunas *type* e *count* nas colunas *cases* e *population*.
  
  A table3 não está no formato tidy, pois da forma como está organizada a coluna *rate* apresenta dois valores em cada uma de suas células. Seria tidy caso fossem os valores reais da taxa.

  A table4a não está no formato tidy, colunas representam os anos, uma variável, e para cada coluna *year* tem-se a contagem de casos de tuberculose. Para deixar a tabela no formato tidy seria necessário transformar os anos numa coluna *year* e os valores atualmente nessas colunas seriam transferidos para uma coluna *cases*.

  A table4b não está no formato tidy, colunas representam os anos, uma variável, e para cada coluna ano tem-se a contagem da população. Para deixar a tabela no formato tidy seria necessário transformar os anos numa coluna *year* e os valores atualmente nessas colunas seriam transferidos para uma coluna *population*.

##Q5
```{r}
#Cria uma nova coluna em table1 com a taxa de casos para 10000 pessoas.
table1 %>%
  mutate( rate=10000*(cases/population))
```

##Q6
```{r}
#Faz a soma de do número de casos de tuberculose na tabela para cada ano.
table1 %>%
  group_by( year) %>%
  summarise( total=sum(cases))
```

##Q7
```{r}
#Gráfico de linhas com a mudança no número de casos por país
table1 %>%
  ggplot( aes( x=year, y=cases, color=country)) +
    geom_line()
```

##Q8
```{r}
#Calcula a taxa para a tabela table2 e armazena o resultado na tabela table2rate
table2rate <- table2 %>%
  group_by( country, year) %>%
  summarise( rate=10000*(count[1]/count[2]))

#Calcula a taxa para as tabelas table4a+table4b e armazena o resultado na tabela table4rate
table4rate <- (10000*(table4a[,-1]/table4b[,-1])) %>%
  cbind( table4a[,1], .) %>%
  gather( key='year', value='rate', 2:3, convert=TRUE)
```

##Q9
```{r}
#Gráfico de linhas com a mudança no número de casos por país
table2 %>%
  filter( type=="cases") %>%
  ggplot( aes( x=year, y=count, color=country)) +
    geom_line()
```

##Q10
```{r}
#Transforma a table4a em formato tidy
tidy4a = table4a %>%
  gather( key='year', value='cases', c('1999', '2000'), convert=TRUE)
```

##Q11
```{r}
#Transforma a table4b em formato tidy
tidy4b = table4b %>%
  gather( key='year', value='population', c('1999', '2000'), convert=TRUE)
```

##Q12
```{r}
#União dos objetos tidy4a e tidy4b. O comando abaixo recebe dois argumentos x e y correspondentes a dois objetos de um mesmo conjunto de dados e copia os valores das variáveis distintas de y para o primeiro (x). Esse alinhamento das observações é feito pelo argumento by, no caso o sistema entende x=tidy4 e y=tidy4b vai reconhecer e usar as variáveis country e year para tal união.
left_join(tidy4a, tidy4b)
```

##Q13
```{r}
#Transforma a table2 em formato tidy
spread(table2, key = type, value = count)
```

##Q14
```{r}
#Transforma a table3 em formato tidy
table3 %>% 
  separate(col = 'rate', into = c('cases', 'population'), convert = TRUE)
```

#Importação de Dados

##Q15
```{r}
#A variável path armazena o caminho completo até os arquivos de banco de dados
path = 'C:/Users/ra137408/Downloads/flight-delays'

```

##Q16
```{r cache = TRUE}
#install.packages("tidyverse")
library( "tidyverse") #Carrega o pacote tidyverse

#Importa os bancos de dados de linhas aereas, aeroportos e voos.
airlines <- file.path(path, "airlines.csv") %>% read_csv()
airports <- file.path(path, "airports.csv") %>% read_csv()
flights <- file.path(path, "flights.csv") %>% read_csv()

```

##Q17

```{r}

#Encontra para cada mes qual voo, no formato ORIGEM-DESTINO, teve o maior atraso médio. Ignora voos partindo de aeroportos cujos simbolos comecam com o numero 1.
atrasos <- flights %>%
  filter( !startsWith( ORIGIN_AIRPORT, "1")) %>%
  mutate( ORIGIN_DESTINATION=str_c(ORIGIN_AIRPORT, 
                                   DESTINATION_AIRPORT, 
                                   sep="-")) %>% 
  group_by( MONTH, ORIGIN_DESTINATION) %>% 
  summarise( ATRASO=mean( ARRIVAL_DELAY, na.rm=TRUE)) %>% 
  top_n( 1, ATRASO)

```

##Q18
```{r}
#Modifica a tabela de atrasos para possuir nome completo e cidade dos aeroportos.
atrasos <- atrasos %>% 
  separate(col='ORIGIN_DESTINATION', 
           into=c('ORIGEM', 'DESTINO') ) %>% 
  left_join( select( airports, 
                     "IATA_CODE", 
                     "AIRPORT_ORIGEM"="AIRPORT", 
                     "CITY_ORIGEM"="CITY"), 
             by=c("ORIGEM"="IATA_CODE")) %>% 
  left_join( select( airports, 
                     "IATA_CODE", 
                     "AIRPORT_DESTINO"="AIRPORT", 
                     "CITY_DESTINO"="CITY"), 
             by=c("DESTINO"="IATA_CODE"))
```

##Q19
```{r }
#exibe tabela de atrasos
atrasos
```
