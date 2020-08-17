---
title: "Lab06"
date: "26 de setembro de 2018"
output: html_document
---
#Introdução

#Objetivos

Ao fim deste laboratório, você deve ser capaz trabalhar com dados extraídos do twitter, incluindo informação de metadata. Você também terá ferramentas de análise de processamento de strings do pacote stringr (parte do tidyverse), bem como de análise de texto do pacote tm.

```{r}
pkgs = c('tidyverse', 'caTools', 'rmarkdown', 'knitr',
         'tm', 'wordcloud', 'rtweet', "htmlwidgets")
install.packages(pkgs, type = 'win.binary')
```

#Algumas consultas no Twitter

```{r}
load("~/Downloads/unicamp.Rdata")
load("~/Downloads/ds.Rdata")
```

#Expressões regulares

##1
 O pacote stringr oferece várias ferramentas que facilitam a manipulação de strings. Em particular, str_view oferece uma ferramenta para visualização de expressões regulares. Crie um vetor x com as palavras “primeiro”, “carro”, “livro”, “passos”, “pouco”, “houve”, “morreu”. Depois, crie três expressões regulares: uma que detecta consoantes consecutivas (não precisam ser as mesmas), vogais consecutivas (não precisam ser as mesmas) e letras idênticas consecutivas. Use a ferramenta str_view(x, "regex") onde "regex" é uma das expressões que você criou, e visualize o resultado (você pode usar str_view para aperfeiçoar sua expressão regular).

```{r}
library("stringr")
x <- c("primeiro", "carro", "livro", "passos", "pouco", "houve", "morreu")

#http://www.dreambank.net/regex.html
#Encontrar pelo menos duas vogais seguidas
str_view(x, "[aeiou]{2,}")

#Encontrar pelo menos duas consoantes seguidas
str_view(x, "[^aeiou]{2,}")

#Encontrar qualquer letra consecutiva
str_view(x, "([a-z])\\1+")
```


##2
 Nós eventualmente vamos remover links dos tweets (normalmente, começando com “http:” ou “https:” e posicionados no fim da mensagem). Escreva (e use str_view para visualizar) uma expressão regular que detecta os links nos dois tweets a seguir. Se você quiser remover apenas o link no final da mensagem, como faria? E se você quiser remover todos os links?

```{r, eval = FALSE}
# Tweets 4, 1181 na lista
x2 <- c("Convidamos a todos para um dos eventos do IEEE mais aguardado do ano... o IEEE Day! :D\n\nFiquem atentos pois ocorrerão pré-eventos nos dias 27/09 e 01/10!\n\n\"Leveraging Technology for a Better Tomorrow\"... https://t.co/arxSuhgkqk", "Unicamp começa a adotar sistema de reserva de cotas (http://t.co/lfewTCjsSG) #pontejornalismo #cotasraciais http://t.co/Lq0oGL1RCW")

#Seleciona tudo que começa em http: ou https:
str_view_all(x2, "https?:")

#Seleciona tudo que começa em http até antes de um espaço, aspas ou parenteses.
str_view_all(x2, "https?:[^_\"\\)]*")

#Para remover os links eu faria
str_replace_all(x2, "https?:[^_\"\\)]*", "")
#Pega tudo que começa com http, que tenha ou não o s, depois : e todos os caracteres que não sejam espaço, aspas ou parenteses.
```

##3
Escreva uma expressão regular que detecte artigos (definidos ou indefinidos, “a o as os um uma uns umas”) e a palavra seguinte (presumidamente, um substantivo) com dois grupos de referência. Em seguida, mantendo apenas a coluna text do tibble unicamp, utilize  tidyr::extract para separar as palavras em duas colunas novas, “artigo” e “substantivo” (extract retorna NA se não há um match, ou o primeiro se há mais de um match).

```{r}
library('tidyr')
library('dplyr')

extrato <- unicamp %>% 
  select(text) %>% 
  extract(text, c("artigo", "substantivo"),regex = "\\b(a|o|as|os|um|uma|uns|umas)\\s(\\w+)") %>% 
  drop_na()
```


#Análise dos dados do Twitter

##1
Usando a informação da coluna is_retweet, remova os retweets do banco de dados ds e unicamp. Em seguida, mantenha apenas as colunas de created_at, screen_name e text (mas veja item 2).

```{r}
ds <- ds %>% 
  filter(is_retweet == TRUE) %>% 
  select(created_at, screen_name, text)

unicamp <- unicamp %>% 
  filter(is_retweet == TRUE) %>% 
  select(created_at, screen_name, text)
```


##2
Remova os @username dos tweets (como os twitter handles não podem contem espaço, pode assumir que o próximo espaço é o fim do username) e os links (que em geral começam com http: ou https:). Em geral, o jeito mais fácil é com str_replace (substitua o que quiser remover por espaços vazios ""). Você também pode usar os links na coluna url e url.t para verificar que removeu os links.

```{r}
str_replace_all("https?:[^_\"\\)]*|@\\w+", "")
##aplicar no BD
```


##3
Troque os caracteres de nova linha, espaço e tabulação por espaço em branco. Remova toda pontuação. Alguns tweets tem problemas de encoding, e você pode precisar usar algo como iconv(text, 'utf-8', 'latin1', sub='') para garantir que o tweet tem caracteres válidos apenas.

##4
Com o comando wordcloud, do pacote homônimo, selecione apenas a coluna texto para obter uma visualização interessante dos dados. A nuvem é organizada de modo que cada palavra tenha tamanho correspondente a sua frequencia relativa. Você pode alterar o parâmetro  min.freq para ter uma wordcloud mais clara.

##5
Considerando a coluna com o nome do usuário, quais usuários têm postagem sobre os dois assuntos? Faça um wordcloud do texto deles. Use o comando join se fizer sentido (mas tome cuidado, pois um join desnecessário vai travar seu computador facilmente).

##6
Você também pode usar a função tm_map do pacote tm, em conjunto com removeWords, para remover stopwords("portuguese") (são palavras comuns da língua portuguesa e consideradas não-informativas). Como muda sua wordcloud?

##7
Considerando agora só os usuários dos dois bancos que não escreveram sobre o assunto do outro banco: Leia a ajuda da função  comparison.cloud, crie os objetos TermDocumentMatrix necessários e construa as comparison.clouds. O que está nos tweets de quem fala de data science, mas não da unicamp?

##Mais sobre regex:
Indicação do Hadley Wickham: https://regexcrossword.com/
