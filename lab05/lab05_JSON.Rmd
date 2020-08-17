---
title: "Laboratório 05: Manipulação de Dados - JSON"
output: html_document
---

##Instalação de pacotes essenciais

```{r eval=FALSE}
options(install.packages.check.source = "no")
pkgs = c('tidyverse', 'maps', 'RColorBrewer', 
         'rmarkdown', 'knitr', 'caTools', 'tidyr',
         'jsonlite', 'dplyr', 'tibble', 'digest',
         'magrittr', 'tidyr', 'formatR')
install.packages(pkgs, type='win.binary')

path = "~/Downloads"
setwd(path)
```

##Manipulação de Objetos JSON em R

  O pacote jsonlite pode ser utilizado para a manipulação de objetos JSON. O comando **fromJSON** recebe uma entrada em formato JSON e a converte para um objeto apropriado em R (vetor, matriz ou data.frame). O comando **toJSON** trabalha na direção oposta, recebendo um objeto em R e convertendo-o para JSON.

  A leitura de um arquivo JSON pode ser feita utilizando o comando **read_json** deste mesmo pacote jsonlite. O comando **read_json** possui um segundo argumento chamado **simplifyVector**, que assume o valor FALSE por padrão. O argumento **simplifyVector=FALSE** causa com que o objeto resultante seja uma lista; com **simplifyVector=TRUE**, o resultado é convertido para um objeto R mais apropriado (data.frame).

##Descrição dos Dados

  Uma start-up norte-americana disponibilizou uma plataforma de crowdsourcing para plataformas móveis iOS e Android. Usuários, após um cadastro inicial, podem visitar páginas de projetos e escolher contribuir com um valor monetário. Estes eventos de visita e contribuição financeira são registradas no campo event_name, do arquivo crowdsource.json disponibilizado, como View Project e Fund Project. O arquivo também disponibiliza informações dadas durante o cadastro:

 - gender: sexo - F (female), M (male), U (unknown);
 - age: idade - 18-24, 25-34, 35-44, 45-54 ou 55+;
 - marital_status: estado civil - single ou married;
 - device: iOS ou android
 - latitude: latitude
 - longitude: longitude
 - city: cidade
 - state: estado
 - zip_code: CEP

  Para os 50 mil registros disponibilizados, informam-se também a categoria (category) do projeto visitado/financiado, a quantia doada (amount) quando o usuário decidiu financiar o projeto e a data/hora (formato UNIX a partir de 01 de janeiro de 1970) no fuso-horário GMT.

```{r }
library(jsonlite)
library(tidyverse)
library(lubridate)

dados = read_json("data.json", simplifyVector=TRUE)
dados = dados$data
dados = cbind(dados[ , -9], dados[, 9])
dados = as_tibble(dados)

dados <- dados %>% transform(client_time = as_datetime(client_time))
dados$amount[is.na(dados$amount)] = 0
```

 - Quantos usuários diferentes utilizaram a plataforma no período coletado?

```{r }

user = dados %>% select(gender, age, marital_status, device, city, state, zip_code) %>% distinct()
nuser = nrow(user)
user$user_id = 1:nuser

dados = left_join(dados, user)
```

No período analisado foram identificados `r nuser` usuários diferentes.

 - Qual é a distribuição de perfis dos usuário de acordo com as variáveis gender, age, marital_status e device? Apresente uma tabela com contagens de usuários em cada classe. A tabela final deve ter as seguintes colunas: gender, marital_status, device, 18-24,  25-34, 45-54, 55+. Insira a tabela no texto utilizando o comando knitr::kable.

```{r }

tabela1 = dados %>%
  select(gender, marital_status, device, age, user_id) %>%
  distinct() %>% 
  group_by(gender, age, marital_status, device) %>% 
    summarise(n = n()) %>% 
  spread(key = age, value = n)


knitr::kable(tabela1)
```

Existe a suspeita de que o número de indivíduos que utilizam iOS é maior que o número de usuários de Android nos grupos de pessoas casadas. Apresente um gráfico, utilizando ggplot2, que mostre se esta suspeita é plausível. O gráfico deve incluir as informações de sexo, idade e estado civil.

```{r }
library(ggplot2)

tabela2 = dados %>%
  select(gender, marital_status, device, age, user_id) %>%
  distinct() %>% 
  group_by(gender, age, marital_status, device) %>% 
    summarise(n = n())

tabela2 %>%
  filter(marital_status == "married") %>% 
    ggplot(aes(device, n, fill=device)) +
    geom_bar(stat = "identity") +
    facet_grid(gender ~ age)
  

  ggplot( aes(x))
```

Qual é a distribuição geográfica destes usuários em função do nome do estado? Qual é o estado que possui o maior número de usuários da plataforma de crowdsourcing?

```{r }
uestado = user %>% 
  group_by(state) %>% 
  count() %>% ungroup()

uestado %>% top_n(1)
```

Para cada nível de category, considere apenas os usuários únicos que viram ou financiaram projetos daquela categoria. Agrupe estes usuários por sexo, idade, estado civil e dispositivo. Para cada um destes grupos, qual é o percentual de financiamento dos projetos? Apresente o resultado em uma tabela com as seguintes colunas: category, gender, marital_status, device, 18-24, 25-34, 35-44,  45-54 e 55+.

```{r }

#doaram = dados %>% group_by(user_id) %>% mutate(fund = max(amount))
#se for > 0 é doação

```

Exporte todas as tabelas criadas para arquivos CSV

```{r }

```
